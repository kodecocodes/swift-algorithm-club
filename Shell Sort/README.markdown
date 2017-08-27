# Shell Sort

Shell sort is based on [insertion sort](../Insertion%20Sort/) as a general way to improve its performance, by breaking the original list into smaller sublists which are then individually sorted using insertion sort.

[There is a nice video created at Sapientia University](https://www.youtube.com/watch?v=CmPA7zE8mx0) which shows the process as a Hungarian folk dance.

## How it works

Instead of comparing elements that are side-by-side and swapping them if they are out of order, the way insertion sort does it, the shell sort algorithm compares elements that are far apart.

The distance between elements is known as the *gap*. If the elements being compared are in the wrong order, they are swapped across the gap. This eliminates many in-between copies that are common with insertion sort.

The idea is that by moving the elements over large gaps, the array becomes partially sorted quite quickly. This makes later passes faster because they don't have to swap so many items anymore.

Once a pass has been completed, the gap is made smaller and a new pass starts.  This repeats until the gap has size 1, at which point the algorithm functions just like  insertion sort. But since the data is already fairly well sorted by then, the final pass can be very quick.

## An example

Suppose we want to sort the array `[64, 20, 50, 33, 72, 10, 23, -1, 4]` using shell sort.

We start by dividing the length of the array by 2:

    n = floor(9/2) = 4

This is the gap size.

We create `n` sublists. In each sublist, the items are spaced apart by a gap of size `n`. In our example, we need to make four of these sublists. The sublists are sorted by the `insertionSort()` function.

That may not have made a whole lot of sense, so let's take a closer look at what happens.

The first pass is as follows. We have `n = 4`, so we make four sublists:

	sublist 0:  [ 64, xx, xx, xx, 72, xx, xx, xx, 4  ]
	sublist 1:  [ xx, 20, xx, xx, xx, 10, xx, xx, xx ]
	sublist 2:  [ xx, xx, 50, xx, xx, xx, 23, xx, xx ]
	sublist 3:  [ xx, xx, xx, 33, xx, xx, xx, -1, xx ]

As you can see, each sublist contains only every 4th item from the original array. The items that are not in a sublist are marked with `xx`. So the first sublist is `[ 64, 72, 4 ]` and the second is `[ 20, 10 ]`, and so on. The reason we use this "gap" is so that we don't have to actually make new arrays. Instead, we interleave them in the original array.

We now call `insertionSort()` once on each sublist.

This particular version of [insertion sort](../Insertion%20Sort/) sorts from the back to the front. Each item in the sublist is compared against the others. If they're in the wrong order, the value is swapped and travels all the way down until we reach the start of the sublist.

So for sublist 0, we swap `4` with `72`, then swap `4` with `64`. After sorting, this sublist looks like:

    sublist 0:  [ 4, xx, xx, xx, 64, xx, xx, xx, 72 ]

The other three sublists after sorting:

	sublist 1:  [ xx, 10, xx, xx, xx, 20, xx, xx, xx ]
	sublist 2:  [ xx, xx, 23, xx, xx, xx, 50, xx, xx ]
	sublist 3:  [ xx, xx, xx, -1, xx, xx, xx, 33, xx ]
    
The total array looks like this now:

	[ 4, 10, 23, -1, 64, 20, 50, 33, 72 ]

It's not entirely sorted yet but it's more sorted than before. This completes the first pass.

In the second pass, we divide the gap size by two:

	n = floor(4/2) = 2

That means we now create only two sublists:

	sublist 0:  [  4, xx, 23, xx, 64, xx, 50, xx, 72 ]
	sublist 1:  [ xx, 10, xx, -1, xx, 20, xx, 33, xx ]

Each sublist contains every 2nd item. Again, we call `insertionSort()` to sort these sublists. The result is:

	sublist 0:  [  4, xx, 23, xx, 50, xx, 64, xx, 72 ]
	sublist 1:  [ xx, -1, xx, 10, xx, 20, xx, 33, xx ]

Note that in each list only two elements were out of place. So the insertion sort is really fast. That's because we already sorted the array a little in the first pass.

The total array looks like this now:

	[ 4, -1, 23, 10, 50, 20, 64, 33, 72 ]

This completes the second pass. The gap size of the final pass is:

	n = floor(2/2) = 1

A gap size of 1 means we only have a single sublist, the array itself, and once again we call `insertionSort()` to sort it. The final sorted array is:

	[ -1, 4, 10, 20, 23, 33, 50, 64, 72 ]

The performance of shell sort is **O(n^2)** in most cases or **O(n log n)** if you get lucky. This algorithm produces an unstable sort; it may change the relative order of elements with equal values.
  
## The gap sequence

The "gap sequence" determines the initial size of the gap and how it is made smaller with each iteration. A good gap sequence is important for shell sort to perform well.

The gap sequence in this implementation is the one from Shell's original version: the initial value is half the array size and then it is divided by 2 each time. There are other ways to calculate the gap sequence.

## Just for fun...

This is an old Commodore 64 BASIC version of shell sort that Matthijs used a long time ago and ported to pretty much every programming language he ever used:

	61200 REM S is the array to be sorted
	61205 REM AS is the number of elements in S
	61210 W1=AS
	61220 IF W1<=0 THEN 61310
	61230 W1=INT(W1/2): W2=AS-W1
	61240 V=0
	61250 FOR N1=0 TO W2-1
	61260 W3=N1+W1
	61270 IF S(N1)>S(W3) THEN SH=S(N1): S(N1)=S(W3): S(W3)=SH: V=1
	61280 NEXT N1
	61290 IF V>0 THEN 61240
	61300 GOTO 61220
	61310 RETURN

## The Code:
Here is an implementation of Shell Sort in Swift:
```
var arr = [64, 20, 50, 33, 72, 10, 23, -1, 4, 5]

public func shellSort(_ list: inout [Int]) {
    var sublistCount = list.count / 2
    while sublistCount > 0 {
        for pos in 0..<sublistCount {
            insertionSort(&list, start: pos, gap: sublistCount)
        }
        sublistCount = sublistCount / 2
    }
}

shellSort(&arr)
```

## See also

[Shellsort on Wikipedia](https://en.wikipedia.org/wiki/Shellsort)

[Shell sort at Rosetta code](http://rosettacode.org/wiki/Sorting_algorithms/Shell_sort)

*Written for Swift Algorithm Club by [Mike Taghavi](https://github.com/mitghi) and Matthijs Hollemans*
