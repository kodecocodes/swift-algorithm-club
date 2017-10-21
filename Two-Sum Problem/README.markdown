# Two-Sum Problem

Given an array of integers and an integer target, return the indices of two numbers that add up to the target.

There are a variety of solutions to this problem (some better than others). The following solutions both run in **O(n)** time.

# Solution 1

This solution looks at one number at a time, storing each number in the dictionary. It uses the number as the key and the number's index in the array as the value.

For each number n, we know the complementing number to sum up to the target is `target - n`. By looking up the complement in the dictionary, we'd know whether we've seen the complement before and what its index is.

```swift
func twoSum(_ nums: [Int], target: Int) -> (Int, Int)? {
    var dict = [Int: Int]()
    
    // For every number n,
    for (currentIndex, n) in nums.enumerated() {
        // Find the complement to n that would sum up to the target.
        let complement = target - n
        
        // Check if the complement is in the dictionary.
        if let complementIndex = dict[complement] {
            return (complementIndex, currentIndex)
        }
        
        // Store n and its index into the dictionary.
        dict[n] = currentIndex
    }
    
    return nil
}
```

The `twoSum` function takes two parameters: the `numbers` array and the target sum. It returns the two indicies of the pair of elements that sums up to the target, or `nil` if they can't be found.

Let's run through the algorithm to see how it works. Given the array:

```swift
[3, 2, 9, 8]
```

Let's find out if there exist two entries whose sum is 10.

Initially, our dictionary is empty. We begin looping through each element:

- **currentIndex = 0** | n = nums[0] = 3 | complement = 10 - 3 = 7

Is the complement `7` in the dictionary? No, so we add `3` and its index `0` to the dictionary.

```swift
[3: 0]
```

- **currentIndex = 1** | n = 2 | complement = 10 - 2 = 8

Is the complement `8` in the dictionary? No, so we add `2` and its index `1` to the dictionary.

```swift
[3: 0, 2: 1]
```

- **currentIndex = 2** | n = 9 | complement = 10 - 9 = 1

Is the complement `1` in the dictionary? No, so we add `9` and its index `2` to the dictionary.:

```swift
[3: 0, 2: 1, 9: 2]
```

- **currentIndex = 3** | n = 8 | complement = 10 - 8 = 2

Is the complement `2` in the dictionary? Yes! That means that we have found a pair of entries that sum to the target!

Therefore, the `complementIndex = dict[2] = 1` and the `currentIndex = 3`. The tuple we return is `(1, 3)`.

If the given array has multiple solutions, only the first solution is returned.

The running time of this algorithm is **O(n)** because it may look at every element in the array. It also requires **O(n)** additional storage space for the dictionary.

# Solution 2

**Note**: This particular algorithm requires that the array is sorted, so if the array isn't sorted yet (usually it won't be), you need to sort it first. The time complexity of the algorithm itself is **O(n)** and, unlike the previous solution, it does not require extra storage. Of course, if you have to sort first, the total time complexity becomes **O(n log n)**. Slightly worse but still quite acceptable.

Here is the code in Swift:

```swift
func twoSumProblem(_ a: [Int], k: Int) -> ((Int, Int))? {
  var i = 0
  var j = a.count - 1

  while i < j {
    let sum = a[i] + a[j]
    if sum == k {
      return (i, j)
    } else if sum < k {
      i += 1
    } else {
      j -= 1
    }
  }
  return nil
}
```

As in the first solution, the `twoSumProblem()` function takes as parameters the array `a` with the numbers and `k`, the sum we're looking for. If there are two numbers that add up to `k`, the function returns a tuple containing their array indices. If not, it returns `nil`. The main difference is that `a` is assumed to be sorted.

To test it, copy the code into a playground and add the following:

```swift
let a = [2, 3, 4, 4, 7, 8, 9, 10, 12, 14, 21, 22, 100]
if let (i, j) = twoSumProblem(a, k: 33) {
  a[i] + a[j]  // 33
}
```

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

## Additional Reading

* [3Sum / 4Sum](https://github.com/raywenderlich/swift-algorithm-club/tree/master/3Sum%20and%204Sum)

*Written for Swift Algorithm Club by Matthijs Hollemans and Daniel Speiser*
