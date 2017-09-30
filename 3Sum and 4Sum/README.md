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

Avoiding duplicate values is fairly straightforward if you've understood everything so far. Let's consider a sample array that has a few duplicates:

```
target = 0

[-1, -1, -1, -1, 0, 1, 1, 1]
```

One possible subset is `[-1, 0, 1]`, and in fact is the only subset for 3Sum. 

The easiet way is using set. We can maintain a solution set, then we can check if the triplets is in the set or not to determine whether it's duplicate.

Set introduces space complexity. So we still want to avoid extra space using. Let's change an angle consider, we can loop the array first find `m` then next thing is to find `l` and `r`. 

For example

```
​```
[-1, 0, 1, 2, -1, -4] // unsorted

1)
[-4, -1, -1, 0, 1, 2]
      m   l        r

2)
[-4, -1, -1, 0, 1, 2]
          m  l     r

3)
[-4, -1, -1, 0, 1, 2]
      m      l     r
​```

We loop `m` in `0..<n`. We will do another inner loop at the same time, `l..r` loops in `i+1..<n`. 
In 1), we will check if `a[i] == a[i-1]`? It's not in this case, then the problem is 2sum (`l..r`).
In 2), Since `a[i] == a[i-1]`, it means `a[i-1]` covers `a[i]` case. Because case 3) contains case 2) solutions.
```



## 4Sum
Given an array S of n integers, find all subsets of the array with 4 values where the 4 values sum up to a target number. 

**Note**: The solution set must not contain duplicate quadruplets.

### Solution
After 3Sum, we already have the idea to change to a problem to a familiar problem we solved before. So, the idea here is straightforward. We just need to downgrade 4Sum to 3Sum. Then we can solve 4Sum.

It's easy to think that we loop the array and get the first the element, then the rest array is 3Sum problem. Since the code is pretty simple, I will avoid duplicate introducation here.

[5]:	https://github.com/raywenderlich/swift-algorithm-club/tree/master/Two-Sum%20Problem
