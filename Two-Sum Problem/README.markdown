# Two-Sum Problem

You're given an array `a` with numbers. Write an algorithm that checks if there are any two entries in the array that add up to a given number `k`. In other words, is there any `a[i] + a[j] == k`?

There are a variety of solutions to this problem (some better than others). The following solutions both run in **O(n)** time.

# Solution 1

This solution uses a dictionary to store differences between each element in the array and the sum `k` that we're looking for. The dictionary also stores the indices of each element.

With this approach, each key in the dictionary corresponds to a new target value. If one of the successive numbers from the array is equal to one of the dictionary's keys, then we know there exist two numbers that sum to `k`. 

```swift
func twoSumProblem(a: [Int], k: Int) -> ((Int, Int))? {
  var dict = [Int: Int]()

  for i in 0 ..< a.count {
    if let newK = dict[a[i]] {
      return (newK, i)
    } else {
      dict[k - a[i]] =  i
    }
  }

  return nil  // if empty array or no entries sum to target k
}
```

The `twoSumProblem()` function takes two parameters: the array `a` with the numbers, and `k`, the sum we're looking for. It returns the first set of indices `(i, j)` where `a[i] + a[j] == k`, or `nil` if no two numbers add up to `k`.

Let's take a look at an example and run through the algorithm to see how it works. Given is the array:

```swift
[ 7, 2, 23, 8, -1, 0, 11, 6  ]
```

Let's find out if there exist two entries whose sum is equal to 10.

Initially, our dictionary is empty. We begin looping through each element:

- **i = 0**: Is `7` in the dictionary? No. We add the difference between the target `k` and the current number to the dictionary. The difference is `10 - 7 = 3`, so the dictionary key is `3`. The value for that key is the current index, `0`. The dictionary now looks like this:

```swift
[ 3: 0 ]
```

- **i = 1:** Is `2` in the dictionary? No. Let's do as above and add the difference (`10 - 2 = 8`) and the array index (`1`). The dictionary is:

```swift
[ 3: 0, 8: 1 ]
```

- **i = 2:** Is `23` in the dictionary? No. Again, we add it to the dictionary. The difference is `10 - 23 = -13` and the index is `2`:

```swift
[ 3: 0, 8: 1, -13: 2 ]
```

- **i = 3:** Is `8` in the dictionary? Yes! That means that we have found a pair of entries that sum to our target. Namely the current number `8` and `array[dict[8]]` because `dict[8] = 1`, `array[1] = 2`, and `8 + 2 = 10`. Therefore, we return the corresponding indices of these numbers. For `8` that is the current loop index, `3`. For `2` that is `dict[8]` or `1`. The tuple we return is `(1, 3)`.

The given array actually has multiple solutions: `(1, 3)` and `(4, 6)`. However, only the first solution is returned.

The running time of this algorithm is **O(n)** because it potentially may need to look at all array elements. It also requires **O(n)** additional storage space for the dictionary.

# Solution 2

**Note**: This particular algorithm requires that the array is sorted, so if the array isn't sorted yet (usually it won't be), you need to sort it first. The time complexity of the algorithm itself is **O(n)** and, unlike the previous solution, it does not require extra storage. Of course, if you have to sort first, the total time complexity becomes **O(n log n)**. Slightly worse but still quite acceptable.

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

*Written for Swift Algorithm Club by Matthijs Hollemans and Daniel Speiser*
