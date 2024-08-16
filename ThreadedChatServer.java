<!DOCTYPE html>
<!-- if Finnish: fi-Fi -->
<html lang="en-GB">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="styles.css">
  <title>ThreadedChatServer in java</title>
<style>
  pre {
    padding-left: 10px;
  }
</style>
</head>
<body>

<div class="topnav" id="myTopnav">
  <a href="index.html"><i class ="fa fa-fw fa-home"></i>Home</a>
  <a href="itskills.html"><i class="fa fa-fw fa-laptop"></i>IT Skills</a>
  <a href="projects.html"><i class="fa fa-fw fa-briefcase"></i>Projects</a>
  <a href="hobbies.html"><i class="fa fa-fw fa-heart"></i>Hobbies</a>
  <a href="contact.html"><i class="fa fa-fw fa-envelope"></i>Contact</a>
  <a href="javascript:void(0);" class="icon" onclick="myFunction()">
    <i class="fa fa-bars"></i>
  </a>
</div>

<pre>
import java.io.IOException;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.LinkedList;
import java.util.Scanner;
import java.util.concurrent.locks.ReentrantLock;

public class ThreadedChatServer {

    // initializing the list containing references to threads
    static LinkedList<Server> serverList = null;

    // Initialization of the lock. The lock is static so that each thread does not get its own lock.
    static private final ReentrantLock sharedLock = new ReentrantLock();
    
    // Lock for admin commands
    private final ReentrantLock adminCommandLock = new ReentrantLock(); 

    // Server socket for listening
    ServerSocket chatServerSocket = null;

    // Flag for shutting down the server
    private volatile boolean isRunning = true;

    public static void main(String[] args) {

    	// Initializing the thread list
        serverList = new LinkedList<Server>(); 

        ThreadedChatServer chatServerThread;

        // Default port for listening
        int listeningPort = 12345;

        // Enabling input for the port from the command line.
        if (args.length > 0) listeningPort = Integer.valueOf(args[0]);

        // This constructor opens the connection
        chatServerThread = new ThreadedChatServer(listeningPort);

        // Announce the port we will soon commence listening to
        System.out.println("Listening to port " + listeningPort);
        
        // Start a new thread for the listening of incoming connections
        new Thread(new Runnable() {
            @Override
            public void run() {
                chatServerThread.listenForConnections();
            }
        }).start();
        
        // Start a new thread for listening for shutdown command from server admin
        new Thread(new Runnable() {
            @Override
            public void run() {
                chatServerThread.listenForShutdownCommand();
            }
        }).start(); // Start the shutdown listener thread
        
        // Above two threads can also be implemented using lambda-syntax, shown below
        // new Thread(() -> chatServerThread.listenForConnections()).start();
        // new Thread(() -> chatServerThread.listenForShutdownCommand()).start();
        
        // listening to admin commands can also be done without threading in current implementation, with the code below
        // chatServerThread.listenForShutdownCommand();

    } // main()

    public ThreadedChatServer(int listeningPort) {
        try {
            chatServerSocket = new ServerSocket(listeningPort);
        } catch (Exception e) {
            System.err.println(e);
            chatServerSocket = null;
        }
    }

    public void listenForConnections() {

        try {
            while (isRunning) { // Continuous loop serves successive connections

                // Waiting for a new connection
                Socket incomingSocket = chatServerSocket.accept();

                // Ensuring data integrity by using a lock.
                // Therefore, we do not want to send messages using the LinkedList while modifying data in the LinkedList.	
                sharedLock.lock();
                try {
                    Server clientHandler = new Server(incomingSocket);
                    serverList.add(clientHandler);  // Adds the thread to the thread list
                    clientHandler.start();            // Starts the created thread
                    System.out.println("Connection-thread added.");
                } finally {
                    sharedLock.unlock(); // Lock is released
                }
            }
        } catch (Exception e) {
            if (isRunning) {
                System.err.println(e);
            }
            chatServerSocket = null;
        }
    }   // listenForConnections()

    public void shutdown() {
    	// Lock for admin commands
        adminCommandLock.lock(); 
        try {
            isRunning = false; // Update shared state, causes listening thread-loops to seize.
                  
            // Lock for modifying shared serverList
            sharedLock.lock(); 
            
            try {

            	// Close the server socket to stop accepting new connections
            	if (chatServerSocket != null && !chatServerSocket.isClosed()) {
            		chatServerSocket.close();
            	}

            	
            	for (Server clientHandler : serverList) {
            		// Notify all connected clients before closing
            		clientHandler.sendBroadcast("Server is shutting down.");
            		
            		// Wait for all threads to finish
            		clientHandler.interrupt();
            	}

            	// Join all client handlers to wait for them to finish processing
            	for (Server clientHandler : serverList) {
            		clientHandler.join();
            	}
            }  finally {
                sharedLock.unlock();
            }

            System.out.println("Server has been shut down gracefully.");
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        } finally {
            adminCommandLock.unlock();
        }
    }
    
    private void listenForShutdownCommand() {
        try (Scanner scanner = new Scanner(System.in)) {
            while (isRunning) { // Loop while the server is running
                if (scanner.hasNextLine()) {
                    String command = scanner.nextLine();
                    if ("SHUTDOWN".equalsIgnoreCase(command)) {
                        shutdown(); // Call your shutdown method
                        break; // Exit the loop after issuing shutdown
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // 'public class Server' Serves a single connection in a threaded manner.
    // The 'public class ThreadedChatServer' enables handling of multiple connections.
    public class Server extends Thread {

        // initializing a PrintWriter that is used in sendBroadcast() method for sending messages
        private PrintWriter outgoingWriter;

        // Socket for client
        Socket clientConnection;

        public Server(Socket incomingSocket) {
            // Create a new PrintWriter instance when the client connects
            try {
                clientConnection = incomingSocket;
                outgoingWriter = new PrintWriter(clientConnection.getOutputStream(), true);
            } catch (IOException e) {
                System.err.println("Error creating PrintWriter: " + e.getMessage());
            }
        }

        public Socket getSocket() {
            return this.clientConnection;
        }

        public void sendBroadcast(String outgoingMessage) {
        	System.out.println("Broadcasting message: " + outgoingMessage);
            try {
                // Send the message to the connected clients using the already fully initialized PrintWriter
                outgoingWriter.println(outgoingMessage);
            } catch (NullPointerException e) {
                System.err.println("Connection is not established for message: " + outgoingMessage);
            } catch (Exception e) {
                System.err.println("An unexpected error occurred while sending message: " + outgoingMessage + " Error: " + e.getMessage());
            }
        }

        public void run() {
            try (Scanner clientInputScanner = new Scanner(clientConnection.getInputStream())) {
            	
            	// Display client details
                System.out.println("New connection: " + clientConnection.getInetAddress() + ":" + clientConnection.getPort()); 
                
                sendBroadcast("Server: Welcome " + clientConnection.getInetAddress() + "! Connection established. Input a text and I will broadcast it to all participants. Command END disconnects the service.");

                boolean loop = true;

                while (loop) {
                    String receivedMessage;

                    // Check if there is a next line to read
                    if (clientInputScanner.hasNextLine()) {
                        receivedMessage = clientInputScanner.nextLine();
                    } else {
                        break; // Breaks in case of socket closure
                    }

                    if (receivedMessage.equalsIgnoreCase("END")) { // Remove thread from list
                        sharedLock.lock();
                        try {
                        	
                        	// Goodbye message
                            outgoingWriter.println("Goodbye! Closing connection."); 

                            if (!clientConnection.isClosed()) {
                                clientConnection.close();
                                
                                System.out.println("Clientsocket has been closed for user " + clientConnection.getInetAddress());
                            }
                            serverList.remove(this); // Remove this thread from the list
                            // Notify others that this user has left
                            for (Server targetChatServer : serverList) {
                                targetChatServer.sendBroadcast("User " + clientConnection.getInetAddress() + " has left the chat.");
                                
                                // Notify the server that the user has left the server
                                System.out.println("User " + clientConnection.getInetAddress() + " has left the cat.");

                            }
                        } catch (Exception e) {
                            System.err.println("Error closing socket: " + e);
                        } finally {
                            sharedLock.unlock(); // Release lock
                        }
                        return; // Stop thread execution
                    } else { // Message is anything other than END
                        String broadcastMessage = clientConnection.getInetAddress() + " : " + receivedMessage;
                        // Send messages to other clients
                        for (Server targetChatServer : serverList) {
                            targetChatServer.sendBroadcast(broadcastMessage);
                        }
                    }
                }

            } catch (Exception e) {
                System.err.println("Error in communication with client: " + e);
            } finally {
                // Close the writer when we're done with it
                if (outgoingWriter != null) {
                    outgoingWriter.close();
                }
            }
        }
    }
}
</pre>

<script src="app.js"></script>
</body>
</html>
