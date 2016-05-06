# Radix Sort

Radix sort is a sorting algorithm that takes as input an array of integers and uses a sorting subroutine( that is often another efficient sorting algorith) to sort the integers by their radix, or rather their digit.  Counting Sort, and Bucket Sort are often times used as the subroutine for Radix Sort.

##Example

* Input Array: [170, 45, 75, 90, 802, 24, 2, 66]
* Output Array (Sorted):  [2, 24, 45, 66, 75, 90, 170, 802]

###Step 1:
The first step in this algorithm is to define the digit or rather the "base" or radix that we will use to sort.
For this example we will let radix = 10, since the integers we are working with in the example are of base 10.

###Step 2:
The next step is to simply iterate n times (where n is the number of digits in the largest integer in the input array), and upon each iteration perform a sorting subroutine on the current digit in question.

###Algorithm in Action

Let's take a look at our example input array.

The largest integer in our array is 802, and it has three digits (ones, tens, hundreds).  So our algorithm will iterate three times whilst performing some sorting algorithm on the digits of each integer.

* Iteration 1:  170, 90, 802, 2, 24, 45, 75, 66
* Iteration 2:  802, 2, 24, 45, 66, 170, 75, 90
* Iteration 3:  2, 24, 45, 66, 75, 90, 170, 802



See also [Wikipedia](https://en.wikipedia.org/wiki/Radix_Sort).

*Written for the Swift Algorithm Club by Christian Encarnacion*
