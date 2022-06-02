#!/usr/bin/perl
use warnings;
use strict;

# 'Bubble Sort optimized' -algorithm
# Code written by Antti Kiviniemi, 2022 


# array of numbers between 1-9 in random order
my @numbers = qw(8 1 5 2 9 3 4 7 6);

my @test1 = qw( 1 1 1 0 0 0 );

my @test2 = qw( 11 11 33 33 -1 0 -90 0 0 0 );

my @test3 = qw( 0 0 0 0 0 0 0 0 0 0 0 );

# create array @sorted_numbers for storing the sorted @numbers array
my @sorted_numbers = bubble_sort(@numbers);

print("Array ", '@numbers', ": ", "\n", "@numbers", "\n");

print("Array ", '@sorted_numbers', ": ", "\n", "@sorted_numbers", "\n");

my @sorted_test1 = bubble_sort(@test1);

print("Array ", '@test1', ": ", "\n", "@test1", "\n");

print("Array ", '@sorted_test1', ": ", "\n", "@sorted_test1", "\n");

my @sorted_test2 = bubble_sort(@test2);

print("Array ", '@test2', ": ", "\n", "@test2", "\n");

print("Array ", '@sorted_test2', ": ", "\n", "@sorted_test2", "\n");

my @sorted_test3 = bubble_sort(@test3);

print("Array ", '@test3', ": ", "\n", "@test3", "\n");

print("Array ", '@sorted_test3', ": ", "\n", "@sorted_test3", "\n");

sub bubble_sort{
  # Create a temporary array
  my @tmpArray = @_;
  
  # variable for holding the length of the array
  my $n = @tmpArray;
  
  # Scalar variable for holding values temporarily
  my $temp;
  
  # break condition
  my $swapped = 1;
  
  for(my $i =0; $i < ($n - 1); $i++) {
	  $swapped = 0;
	  # last i elements are already in place
	  for (my $j = 0; $j < ($n - $i - 1); $j++) {
        if ($tmpArray[$j] > $tmpArray[($j + 1)]) {
		    # swap
			$temp = $tmpArray[($j + 1)];
			$tmpArray[($j + 1)] = $tmpArray[$j];
			$tmpArray[$j] = $temp;
			
			# Remember a swap has occurred
			$swapped = 1;
		}
	  }
	  # break out of the outer loop if no swaps occur in the inner loop
	  last if($swapped == 0);
  }
  return @tmpArray;
}

# Time complexity:
# In short: Worst case: O(N^2), Best case: O(N), Average case: O(N^2)
# Below is long explanations for time complexities
#------------
# Time complexity = T(N)
# Number of swaps = S(N)
# Number of comparisons = C(N)
#   -Done by observing the number of times the lines 41-48 run in each case
# T(N) = S(N) + C(N) OR Time complexity equals number of swaps plus number of comparisons
# Which goes as follows:
# T(N) = T(N-1) + N
# C(N) = C(N-1) + (N-1)
# S(N) depends on hows the elements are within the array
# ------------
# Worst case: 
# E.g. array is in reverse order.
# Meaning: array is in descending order when we want to sort it into ascending order
# Number of swaps is equal to number of comparisons, since every element is out of place
# T(N) = C(N) = S(N) = N*(N-1)/2
# Therefore, 
# Number of Comparisons: O(N^2) steps
# Number of swaps: O(N^2) steps
# Because T(N) = S(N) + C(N) = O(N^2) + O(N^2) = O(2*N^2) =~ O(N^2)
# ------------
# Best case: 
# If the array is already sorted.
# It takes one iteration through the array for the algorithm
# to realize it is sorted.
# T(N) = C(N) = N
# Number of swaps is 0, S(N) = 0
# ------------
# Average case:
# Number of comparisons in Bubble sort is constant,
# therefore in avg case there is O(N^2) comparisons.
# This is not dependant on the arrangement of the elements
# For the number of swaps, following points are to be considered:
# -if element is in index 1 but it should be in index 2, it will takes
#  a minimum of 2-1 swaps to bring the element to the correct position
# -An element E will be at distance of 3 from its position in sorted array.
#  Max value of E is n-1 for edge elements and it will be N/2 for the elements
#  at the middle
# -Sum of maximum difference in position across every element is as follows:
# (N-1) + (N-3) + (N-5) ... + 0 + ... + (N-3) + (N-1)
# = N x N - 2x(1 + 3 + 5 + ... + N/2)
# = N^2 - 2 x N^2 / 4
# = N^2 - N^2 / 2
# = N^2 /2
# Therefore average number of swaps is =(N^2 / 2)
# Therefore, average case time complexity of Bubble Sort is as follows: 
# - Number of comparisons: O(N^2 /2) 
# - Number of swaps: O(N^2)
# Total complexity: T(N) = S(N) + C(N) = O(N^2) + O(N^2 / 2) = O(2 * N^2 /2) = O(N^2)