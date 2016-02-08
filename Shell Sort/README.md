# Shell Sort

Shell sort is based on [Insertion Sort](https://github.com/hollance/swift-algorithm-club/tree/master/Insertion%20Sort) as a general way to improve its performance by breaking the original list into smaller sublists which can be then indivually sorted using Insertion Sort.

[There is a nice video created at Sapientia University which shows the process as Hungarian fol dance.](https://www.youtube.com/watch?v=CmPA7zE8mx0)


# Process

Assume we want to sort [64,23,72,33,4] using Shellsort.

We start by creating a sublist by diving length of list by 2.

    n = floor(5/2) = 2

then we iterate 0 to n times and create n sublists which its items are far apart by n.

Sublists are created by `insertionSort()` function. It uses start position of an item and
the gap between items to create a sublist.

n = floor(5/2) = 2

    i = 0    64 23 72 33 4
             ``    ``    ``
        	64 23 4 33 72
		   4 23 64 33 72

    i = 1    4  23 64 33 72
                ``    ``

n = floor(2/2) = 1

    i = 0    4  23 64 33 72
             `` `` `` `` ``
	     ( normal insertionSort operations )
	       4  23 33 64 72
	       
Each item in sublist is compared against each other, if the condition is met, the value is swapped and that value travels all the way down and compared against previous items until we reach our start point.


# See also

[Shellsort on Wikipedia](https://en.wikipedia.org/wiki/Shellsort)

*Written for Swift Algorithm Club by [Mike Taghavi](https://github.com/mitghi)*