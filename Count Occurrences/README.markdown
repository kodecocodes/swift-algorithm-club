# Count Occurrences

Goal: Count how often a certain value appears in an array.

The obvious way to do this is with a [linear search](../Linear Search/) from the beginning of the array until the end, keeping count of how often you come across the value. That is an **O(n)** algorithm.

However, if the array is sorted you can do it much faster, in **O(log n)** time, by using a modification of [binary search](../Binary Search/).

Let's say we have the following array:

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

If we want to know how often the value `3` occurs, we can do a regular binary search for `3`. That could give us any of these four indices:

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
	           *  *  *  *

But that still doesn't tell you how many other `3`s there are. To find those other `3`s, you'd still have to do a linear search to the left and a linear search to the right. That will be fast enough in most cases, but in the worst case -- when the array consists of nothing but `3`s -- it still takes **O(n)** time.

The trick is to use two binary searches, one to find where the `3`s start (the left boundary), and one to find where they end (the right boundary).

In code this looks as follows:

```swift
func countOccurrencesOfKey(_ key: Int, inArray a: [Int]) -> Int {
  func leftBoundary() -> Int {
    var low = 0
    var high = a.count
    while low < high {
      let midIndex = low + (high - low)/2
      if a[midIndex] < key {
        low = midIndex + 1
      } else {
        high = midIndex
      }
    }
    return low
  }
  
  func rightBoundary() -> Int {
    var low = 0
    var high = a.count
    while low < high {
      let midIndex = low + (high - low)/2
      if a[midIndex] > key {
        high = midIndex
      } else {
        low = midIndex + 1
      }
    }
    return low
  }
  
  return rightBoundary() - leftBoundary()
}
```

Notice that the helper functions `leftBoundary()` and `rightBoundary()` are very similar to the [binary search](../Binary Search/) algorithm. The big difference is that they don't stop when they find the search key, but keep going.

To test this algorithm, copy the code to a playground and then do:

```swift
let a = [ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

countOccurrencesOfKey(3, inArray: a)  // returns 4
```

> **Remember:** If you use your own array, make sure it is sorted first!

Let's walk through the example. The array is:

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]

To find the left boundary, we start with `low = 0` and `high = 12`. The first mid index is `6`:

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
	                    *

With a regular binary search you'd be done now, but here we're not just looking whether the value `3` occurs or not -- instead, we want to find where it occurs *first*.

Since this algorithm follows the same principle as binary search, we now ignore the right half of the array and calculate the new mid index:

	[ 0, 1, 1, 3, 3, 3 | x, x, x, x, x, x ]
	           *

Again, we've landed on a `3`, and it's the very first one. But the algorithm doesn't know that, so we split the array again:

	[ 0, 1, 1 | x, x, x | x, x, x, x, x, x ]
	     *

Still not done. Split again, but this time use the right half:

	[ x, x | 1 | x, x, x | x, x, x, x, x, x ]
	         *

The array cannot be split up any further, which means we've found the left boundary, at index 3.

Now let's start over and try to find the right boundary. This is very similar, so I'll just show you the different steps:

	[ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
	                    *

	[ x, x, x, x, x, x, x | 6, 8, 10, 11, 11 ]
	                              *

	[ x, x, x, x, x, x, x | 6, 8, | x, x, x ]
	                           *

	[ x, x, x, x, x, x, x | 6 | x | x, x, x ]
	                        *

The right boundary is at index 7. The difference between the two boundaries is 7 - 3 = 4, so the number `3` occurs four times in this array.

Each binary search took 4 steps, so in total this algorithm took 8 steps. Not a big gain on an array of only 12 items, but the bigger the array, the more efficient this algorithm becomes. For a sorted array with 1,000,000 items, it only takes 2 x 20 = 40 steps to count the number of occurrences for any particular value.

By the way, if the value you're looking for is not in the array, then `rightBoundary()` and `leftBoundary()` return the same value and so the difference between them is 0.

This is an example of how you can modify the basic binary search to solve other algorithmic problems as well. Of course, it does require that the array is sorted.

*Written for Swift Algorithm Club by Matthijs Hollemans*
