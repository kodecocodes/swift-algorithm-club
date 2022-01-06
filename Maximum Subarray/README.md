#  Maximum Subarray

In computer science, the maximum sum subarray problem is the task of finding a contiguous subarray with the largest sum, within a given one-dimensional array A[1...n] of numbers. Formally, the task is to find indices `i` and `j` with ` 1 <= i <= j <= n`, such that the sum

![alt text][sum]

[sum]: https://wikimedia.org/api/rest_v1/media/math/render/svg/3f4ae4590a685044ab6ba7cc8b23cc7c57f5689e "Logo Title Text 2"

is as large as possible. (Some formulations of the problem also allow the empty subarray to be considered; by convention, the sum of all values of the empty subarray is zero.) Each number in the input array A could be positive, negative, or zero.

For example, for the array of values `[−2, 1, −3, 4, −1, 2, 1, −5, 4]`, the contiguous subarray with the largest sum is `[4, −1, 2, 1]`, with sum `6`.

Some properties of this problem are:
    1. If the array contains all non-negative numbers, then the problem is trivial; a maximum subarray is the entire array.
    2. If the array contains all non-positive numbers, then a solution is any subarray of size 1 containing the maximal value of the array (or the empty subarray, if it is permitted).
    3. Several different sub-arrays may have the same maximum sum.

This problem can be solved using several different algorithmic techniques, including brute force, divide and conquer, dynamic programming, and reduction to shortest paths.

[Wikipedia](https://en.wikipedia.org/wiki/Maximum_subarray_problem)

## Kadane's Algorithm
Simple idea of the Kadane's algorithm is to look for all positive contiguous segments of the array and keep track of maximum sum contiguous segment among all positive segments. Each time we get a positive sum compare it with `current` and update `best` if it is greater than `current`

[Explanation](https://www.geeksforgeeks.org/largest-sum-contiguous-subarray/)

```
func maximumSubarray<T:Numeric & Comparable>(_ numbers:[T]) -> T {
    
    var best = numbers[0]
    var current = numbers[0]
    
    for i in 1..<numbers.count{
        current = max(current + numbers[i], numbers[i])
        best = max(current, best);
    }
    return best
}
```


-----------
* Function written for Swift Algorithm Club by Emrah Usar*
-----------
