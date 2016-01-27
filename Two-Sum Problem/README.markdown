# Two-Sum Problem

You're given an array `a` with numbers. Write an algorithm that checks if there are any two entries in the array that add up to a given number `k`. In other words, is there any `a[i] + a[j] == k`?

There are a variety of solutions to this problem (some better than others) but I quite like the following. 

**Note**: This particular algorithm requires that the array is sorted, so if the array isn't sorted yet (usually it won't be), you need to sort it first. The time complexity of the algorithm itself is **O(n)** but if you have to sort first, the total time complexity becomes **O(n log n)**. Slightly worse but still quite acceptable.

Here is the code in Swift:

```swift
func twoSumProblem(a: [Int], k: Int) -> ((Int, Int))? {
  var i = 0
  var j = a.count - 1

  while i < j {
    let sum = a[i] + a[j]
    if sum == k {
      return (i, j)
    } else if sum < k {
      ++i
    } else {
      --j
    }
  }
  return nil
}
```

The `twoSumProblem()` function takes as parameters the array `a` with the numbers, which it assumes is sorted, and `k`, the sum we're looking for. If there are two numbers that add up to `k`, the function returns a tuple containing their array indices. If not, it returns `nil`.

To test it, copy the code into a playground and add the following:

```swift
let a = [2, 3, 4, 4, 7, 8, 9, 10, 12, 14, 21, 22, 100]
if let (i, j) = twoSumProblem(a, k: 33) {
  a[i] + a[j]  // 33
}
```swift

This returns the tuple `(8, 10)` because `a[8] = 12` and `a[10] = 21`, and together they add up to `33`.

So how does this algorithm work? It takes advantage of the array being sorted. That's true for many algorithms, by the way. If you first sort the data, it's often easier to perform your calculations.

In the example, the sorted array is:

	[ 2, 3, 4, 4, 7, 8, 9, 10, 12, 14, 21, 22, 100 ]

The algorithm uses the two variables `i` and `j` to point to the beginning and end of the array, respectively. Then it increments `i` and decrements `j` until the two meet. While it's doing this, it checks whether `a[i]` and `a[j]` add up to `k`.

Let's step through this. Initially, we have:

	[ 2, 3, 4, 4, 7, 8, 9, 10, 12, 14, 21, 22, 100 ]
      i                                        j

The sum of these two is `2 + 100 = 102`. That's obviously too much, since `k = 33` in this example. There is no way that `100` will ever be part of the answer, so decrement `j`.

We have:

	[ 2, 3, 4, 4, 7, 8, 9, 10, 12, 14, 21, 22, 100 ]
      i                                    j

The sum is `2 + 22 = 24`. Now the sum is too small. We can safely conclude at this point that the number `2` will never be part of the answer. The largest number on the right is `22`, so we at least need `11` on the left to make `33`. Anything less than `11` is not going to cut it. (This is why we sorted the array!)

So, `2` is out and we increment `i` to look at the next small number.

	[ 2, 3, 4, 4, 7, 8, 9, 10, 12, 14, 21, 22, 100 ]
         i                                 j

The sum is `3 + 22 = 25`. Still too small, so increment `i` again.

	[ 2, 3, 4, 4, 7, 8, 9, 10, 12, 14, 21, 22, 100 ]
            i                              j

In fact, we have to increment `i` a few more times, until we get to `12`:

	[ 2, 3, 4, 4, 7, 8, 9, 10, 12, 14, 21, 22, 100 ]
                               i           j

Now the sum is `12 + 22 = 34`. It's too high, which means we need to decrement `j`. This gives:

	[ 2, 3, 4, 4, 7, 8, 9, 10, 12, 14, 21, 22, 100 ]
                               i       j

And finally, we have the answer: `12 + 21 = 33`. Yay!

It's possible, of course, that there are no values for `a[i] + a[j]` that sum to `k`. In that case, eventually `i` and `j` will point at the same number. Then we can conclude that no answer exists and we return `nil`.

I'm quite enamored by this little algorithm. It shows that with some basic preprocessing on the input data -- sorting it from low to high -- you can turn a tricky problem into a very simple and beautiful algorithm.
