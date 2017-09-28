# 3Sum and 4Sum

3Sum and 4Sum are extensions of a popular algorithm question, the [2Sum][5]. This article will talk about the problem and describe possible solutions.

## 3Sum

Given an array of integers, find all subsets of the array with 3 values where the 3 values sum up to a target number. 

**Note**: The solution subsets must not contain duplicate triplets. (Each element in the array can only be used once)

> For example, given the array [-1, 0, 1, 2, -1, -4], and the target **0**:
> The solution set is: [[-1, 0, 1], [-1, -1, 2]] // The two **-1** values in the array are considered to be distinct

### Example

Consider the following array of integers, and a target sum of **0**:

```
[-1, 0, 1, 2, -1, -4]
```

#### 1. Sorting

You'll first sort the array in ascending order:

```
[-4, -1, -1, 0, 1, 2]
```

#### 2. Two Sum's Methodology

The 3Sum problem can be solved by augmenting the 2Sum solution, so let's begin by doing a quick explanation on how 2Sum handles the solution. 2Sum begins by comparing the left and right most values:

```
[-4, -1, -1, 0, 1, 2]
  l                r
```

Your target sum is **0**. Given the current left and right values, you won't be able to make the target number. However, you've gained a valuable hint for your next step. 

```
-4 + 2 = -2 // too small!
```

The result of `l + r` gave you a value that is smaller than the target number. Thus, you have two options:

1. Increase the lower number. 
2. Increase the higher number.

Because your array is sorted, you can quickly identify that you cannot pick option **2**, since the rightmost number is already the biggest number. Thus, you have no choice but to try for a different number from the left end of the array:

```
[-4, -1, -1, 0, 1, 2]
      l            r
```

This time, you'll get the following result from summing `l` and `r`:

```
-1 + 2 = 1 // too big!
```

This time, the value is too big! I hope you see where it goes from here. Since the array is already sorted, you can only decrease the value on the right side in an attempt to balance things out. Hence, the next iteration of your algorithm will look like this:

```
[-4, -1, -1, 0, 1, 2]
      l         r 
```

And then you've found a match :]

```
-1 + 1 = 0
```

#### Augmenting 2Sum

Let's start from scratch and consider the same problem where you've sorted your input and you're target sum is **0**:

```
[-4, -1, -1, 0, 1, 2]
  l                r
```

Your goal this time is the following equation:

```
l + r + m = 0
```

You have the values of `l` and `r`:

```
-4 + 2 + m = 0

// in other words
m = 4 - 2 = 2
```

For the current values of `l` and `r`, you need to find a value of **2** in the array to satisfy your target sum...

#### Finding `m`

```
         m -- where?
[-4, -1, -1, 0, 1, 2]
  l                r 
```

There are slight optimizations you can do to find `m`, but to keep things simple, you'll just iterate through the array from `l` index to the `r` index. Once you find a value where `l + r + m = target`, you've found your first match! 

#### Avoiding Duplicates

// TODO: Work in progress

Avoiding duplicate values is fairly straightforward if you've understood everything so far. Let's consider a sample array that has a few duplicates:

```
target = 0

[-1, -1, -1, -1, 0, 1, 1, 1]
```

One possible subset is `[-1, 0, 1]`, and in fact is the only subset for 3Sum. 

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
