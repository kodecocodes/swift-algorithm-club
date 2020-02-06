# Heap Sort

Sorts an array from low to high using a heap.

A [heap](../Heap/) is a partially sorted binary tree that is stored inside an array. The heap sort algorithm takes advantage of the structure of the heap to perform a fast sort.

To sort from lowest to highest, heap sort first converts the unsorted array to a max-heap, so that the first element in the array is the largest.

Let's say the array to sort is:

	[ 5, 13, 2, 25, 7, 17, 20, 8, 4 ]

This is first turned into a max-heap that looks like this:

![The max-heap](Images/MaxHeap.png)

The heap's internal array is then:

	[ 25, 13, 20, 8, 7, 17, 2, 5, 4 ]

That's hardly what you'd call sorted! But now the sorting process starts: we swap the first element (index *0*) with the last one at index *n-1*, to get:

	[ 4, 13, 20, 8, 7, 17, 2, 5, 25 ]
	  *                          *

Now the new root node, `4`, will be smaller than its children, so we fix up the max-heap up to element *n-2* using the *shift down* or "heapify" procedure. After repairing the heap, the new root is now the second-largest item in the array:

	[20, 13, 17, 8, 7, 4, 2, 5 | 25]

Important: When we fix the heap, we ignore the last item at index *n-1*. That now contains the array's maximum value, so it is in its final sorted place already. The `|` bar indicates where the sorted portion of the array begins. We'll leave that part of the array alone from now on.

Again, we swap the first element with the last one (this time at index *n-2*):

	[5, 13, 17, 8, 7, 4, 2, 20 | 25]
	 *                      *

And fix up the heap to make it valid max-heap again:

	[17, 13, 5, 8, 7, 4, 2 | 20, 25]

As you can see, the largest items are making their way to the back. We repeat this process until we arrive at the root node and then the whole array is sorted.

> **Note:** This process is very similar to [selection sort](../Selection%20Sort/), which repeatedly looks for the minimum item in the remainder of the array. Extracting the minimum or maximum value is what heaps are good at.

Performance of heap sort is **O(n log n)** in best, worst, and average case. Because we modify the array directly, heap sort can be performed in-place. But it is not a stable sort: the relative order of identical elements is not preserved.

Here's how you can implement heap sort in Swift:

```swift
extension Heap {
  public mutating func sort() -> [T] {
    for i in stride(from: (elements.count - 1), through: 1, by: -1) {
      swap(&elements[0], &elements[i])
      shiftDown(0, heapSize: i)
    }
    return elements
  }
}
```

This adds a `sort()` function to our [heap](../Heap/) implementation. To use it, you would do something like this:

```swift
var h1 = Heap(array: [5, 13, 2, 25, 7, 17, 20, 8, 4], sort: >)
let a1 = h1.sort()
```

Because we need a max-heap to sort from low-to-high, you need to give `Heap` the reverse of the sort function. To sort `<`, the `Heap` object must be created with `>` as the sort function. In other words, sorting from low-to-high creates a max-heap and turns it into a min-heap.

We can write a handy helper function for that:

```swift
public func heapsort<T>(_ a: [T], _ sort: @escaping (T, T) -> Bool) -> [T] {
  let reverseOrder = { i1, i2 in sort(i2, i1) }
  var h = Heap(array: a, sort: reverseOrder)
  return h.sort()
}
```

*Written for Swift Algorithm Club by Matthijs Hollemans*
