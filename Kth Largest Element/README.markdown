# k-th Largest Element Problem

You're given an integer array `a`. Write an algorithm that finds the kth largest element in the array.

The following solution is semi-naive. Its time complexity is O(n log n) since it first sorts the array, and uses an additional O(n) space. Better solutions using heaps exist that run in O(n) time.

```swift
func kthLargest(a: [Int], k: Int) -> Int? {
    let len = a.count

    if (k <= 0 || k > len || len < 1) { return nil }

    let sorted = a.sort()

    return sorted[len - k]
}
```

The `kthLargest()` function takes two parameters: the array `a` with consisting of integers, and `k`, in order to find the kth largest element. It returns the kth largest element.

Let's take a look at an example and run through the algorithm to see how it works. Given `k = 4` and the array:

```swift
[ 7, 92, 23, 9, -1, 0, 11, 6 ]
```

Initially there's no direct way to find the kth largest element, but after sorting the array it's rather straightforward. Here's the sorted array:

```swift
[ -1, 0, 6, 7, 9, 11, 23, 92 ]
```

Now, all we must do is take the kth largest value, which is located at: `a[a.count - k] = a[8 - 4] = a[4] = 9`

*Written by Daniel Speiser*
