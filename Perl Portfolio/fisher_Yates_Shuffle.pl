<!DOCTYPE html>
<!-- if Finnish: fi-Fi -->
<html lang="en-GB">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="../styles.css">
  <title>Antti's Contact</title>
<style>
</style>
</head>
<body>

<div class="topnav" id="myTopnav">
  <a href="index.html"><i class ="fa fa-fw fa-home"></i>Home</a>
  <a href="itskills.html"><i class="fa fa-fw fa-laptop"></i>IT Skills</a>
  <a href="projects.html"><i class="fa fa-fw fa-briefcase"></i>Projects</a>
  <a href="hobbies.html"><i class="fa fa-fw fa-heart"></i>Hobbies</a>
  <a class="active" href="contact.html"><i class="fa fa-fw fa-envelope"></i>Contact</a>
  <a href="javascript:void(0);" class="icon" onclick="myFunction()">
    <i class="fa fa-bars"></i>
  </a>
</div>

<pre>
#!/usr/bin/perl
use warnings;
use strict;

# 'Fisher-Yates Shuffle Modernized Version' -algorithm
# Code written by Antti Kiviniemi, 2022 

# array of numbers between 1-9 in sorted order
my @numbers = qw(1 2 3 4 5 6 7 8 9);

# call the subroutine for shuffling the array
	my @numbers_shuffled = shuffle(@numbers);

print("Array ", '@numbers_shuffled', ": ", "\n", "@numbers_shuffled", "\n");

sub shuffle {
	# create a temporary array so we do not lose the original array
	my @tempArray = @_;
	
	# length of the array
	my $len = @tempArray;
	
	# last index of the array
	my $last_idx = $len-1;
	
	# initializing variable for holding random index
	my $rand_idx;
	
	# initializing variable for holding values temporarily in order to perform swap
	my $temp;
	
	while ($last_idx > 0) {
		# create a random integer
		# the int rand creates a random integer, between 0 and last index.
		# if last index is 5, then integer produced is one of the following: 
		# 0, 1, 2, 3, 4, 5
	    $rand_idx = int rand($last_idx) + 1;
		# perform swap between value at last index and value at random index.
		# after every swap the random swapped with last index becomes 
		# part of the shuffled array.
		$temp = $tempArray[$last_idx];
		$tempArray[$last_idx] = $tempArray[$rand_idx];
		$tempArray[$rand_idx] = $temp;
		$last_idx = $last_idx - 1;
	}
	return @tempArray;
}


# Time complexity:
# the while loop is length N
# each step within while loop is constant, O(1)
# Therefore time complexity of the algorithm is O(N)
# ----
# Space Complexity:
# we did everything within the array itself
# Therefore the space complexity is constant, O(1)






</pre>

<script src="app.js"></script>
</body>
</html>
