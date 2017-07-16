# 3Sum and 4Sum

## 3Sum
Given an array S of n integers, are there elements a, b, c in S such that a + b + c = 0? 
Find all unique triplets in the array which gives the sum of zero.

**Note**: The solution set must not contain duplicate triplets.

> For example, given array S = [-1, 0, 1, 2, -1, -4],
> A solution set is: [[-1, 0, 1], [-1, -1, 2]]

### Solution
Like [2Sum][5], we can sort the array first, then use 2 pointers method to solve the problem. But here, we need 3 numbers, so we need add one more pointer. But how to play with 3 pointers?

The key idea here is we split the array into 2 parts, if we have a pointer `i`, let’s assume we got `i` position already. What’ next? Actually, next is just a 2Sum problem right? We can just apply 2 pointers method in 2Sum. But what’s 2Sum’s target sum? Is it `target2Sum = target3Sum - nums[i]` ? That’s awesome! 

How we figure out `i`? We can loop i from `0` to `nums.count - 1`.

How we avoid duplicate triplets? Since the array has been sorted, we just need to check if `a[i] == a[i-1]`. Why? Because if `a[i] == a[i-1]`, it means that `a[i-1]` already covers all `a[i]` solutions, we should not do it, otherwise it will have duplicate answers. The same for `j` and `k` which runs for 2Sum.

So, we successfully downgrade 3Sum to 2Sum problem with some tricks. Next, you will see how we downgrade 4Sum to 3Sum.

## 4Sum
Given an array S of n integers, are there elements a, b, c, and d in S such that a + b + c + d = target? Find all unique quadruplets in the array which gives the sum of target.

**Note**: The solution set must not contain duplicate quadruplets.

### Solution
After 3Sum, you should have feeling actually we just need a same idea to downgrade it to 3Sum, and then 2Sum, and then solve it.

How? I will leave it as a challenge for you to figure out first and see if you really master the idea behind this kind of problems.

Feel free to check out the solution if you are blocked.

## Where to go next?
If it’s a KSum, and `K` is a big number, do we need to create `K` pointers and solve it?

I will write another topic to present how we will solve this KSum problem with a generic way soon.





[5]:	https://github.com/raywenderlich/swift-algorithm-club/tree/master/Two-Sum%20Problem
