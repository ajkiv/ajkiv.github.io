#!/usr/bin/perl
use warnings;
use strict;

# 'Bogo Sort' -algorithm
# Code written by Antti Kiviniemi, 2022 

# Warning: Do not use long arrays with this algorithm.
# Else the runtime will be very long and your processor
# could get overworked.
# -----
# Warning: Theoretical Worst Case is O(Infinite)!

# array of numbers between 1-9 in random order
my @numbers1 = qw( 1 5 2 3 4);

print("Array ", '@numbers1', ": ", "\n", "@numbers1", "\n");

my @numbers1_sorted = bogo_sort(@numbers1);

print("Array ", '@numbers1_sorted', ": ", "\n", "@numbers1_sorted", "\n");

sub bogo_sort {
	my @tmpArr = @_;
	
	my $check = 0;
	
	my @shuffledArr;
	
	while ($check == 0) {
		@shuffledArr = shuffle(@tmpArr);
		$check = is_sorted(@shuffledArr);
	}
	return @shuffledArr;
}


# Fisher-Yates Shuffle Modernized
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
	    $rand_idx = int rand(($last_idx + 1));
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

sub is_sorted {
	my @tempArray = @_;
	
	my $len = @tempArray;
	
	# return 1, representing true, if array length is 0 or 1
	if ($len == 0 || $len == 1) {
		return 1;
	}
	
	my $last_idx = $len - 1;
	
	while ($last_idx > 0) {
		    # unsorted pair found, return 0
		    if ($tempArray[$last_idx] < $tempArray[$last_idx - 1]) {
				return 0;
			}	
			$last_idx = $last_idx - 1;
	}
	return 1;
}


# Time complexity:
# bogo Sort time complexity consists of 3 parts
# 1. Number of shuffles.
# 2. Shuffling algorithm
# 3. checking if the array is in order
# -----
# Let's check Time complexity of 2. and 3. first
# -----
# Shuffling algorithm is Fisher-Yates modernized:
# sub shuffle
# -----
# the while loop is length N
# each step within while loop is constant, O(1)
# Therefore time complexity of the algorithm is O(N)
# ----
# Space Complexity:
# we did everything within the array itself
# Therefore the space complexity is constant, O(1)
# -----
# Checking whether or not the array is in order
# sub is_sorted
# Time complexity: 
# The subroutine goes through the list and compares 
# current and previous value at each value
# Worst case: O(N) (check goes until end before finding out list is sorted)
# Best case: O(1) (first check shows the array is not sorted)
# average case: O(1) (already first few elements will show the array is not sorted)
# -----
# Number of Shuffles:
# how many times we have to shuffle before the array is sorted?
# worst case: O(infinite), there is no upper limit, theoretically we can always get wrong permutation
# best case: O(1), first random permutation gives us a sorted array
# average case regarding 
# average case: O(N! / 2)
# Average case explained:
# -There are N! possible permutations
# -On average you will land on the correct permutation after 50%
#  of the guesses. Therefore it is N! / 2.
# -----
# Total runtime: 
# Worst case: O(infinite), there is no upper limit, theoretically we can always get wrong permutation'
# Best case: O(N), first random permutation gives us a sorted array
# -but creating the shuffled array takes O(N) time
# -and checking if the array is in order takes O(N) time
# -Total runtime: O(2 * N) =~ O(N)
# Average case: 
# -Average amount of guesses: N! / 2
# -Average Time Complexity of checking if sorted: N/2
# -Average Time Complexity of Creating a new shuffled array: O(N)
# -Total: O(N * N! / 2 / 2) = O(N * N! / 4) =~ O(N!)





