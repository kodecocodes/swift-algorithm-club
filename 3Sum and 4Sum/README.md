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

# 3Sum

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

Since you pre-sort the array, duplicates will be adjacent to each other. You just need to skip over duplicates by comparing adjacent values:

```
extension Collection where Element: Equatable {
  
  /// Returns next index with unique value. Works only on sorted arrays.
  ///
  /// - Parameter index: The current `Int` index.
  /// - Returns: The new `Int` index. Will return `nil` if new index happens to be the `endIndex` (out of bounds)
  func uniqueIndex(after index: Index) -> Index? {
    guard index < endIndex else { return nil }
    var index = index
    var nextIndex = self.index(after: index)
    while nextIndex < endIndex && self[index] == self[nextIndex] {
      formIndex(after: &index)
      formIndex(after: &nextIndex)
    }
    
    if nextIndex == endIndex {
      return nil
    } else {
      return nextIndex
    }
  }
}
```

A similar implementation is used to get the unique index *before* a given index:

```
extension BidirectionalCollection where Element: Equatable {
  
  /// Returns next index with unique value. Works only on sorted arrays.
  ///
  /// - Parameter index: The current `Int` index.
  /// - Returns: The new `Int` index. Will return `nil` if new index happens to come before the `startIndex` (out of bounds)
  func uniqueIndex(before index: Index) -> Index? {
    return indices[..<index].reversed().first { index -> Bool in
      let nextIndex = self.index(after: index)
      guard nextIndex >= startIndex && self[index] != self[nextIndex] else { return false }
      return true
    }
  }
}
```

## 4Sum
Given an array S of n integers, find all subsets of the array with 4 values where the 4 values sum up to a target number. 

**Note**: The solution set must not contain duplicate quadruplets.

### Solution
After 3Sum, we already have the idea to change to a problem to a familiar problem we solved before. So, the idea here is straightforward. We just need to downgrade 4Sum to 3Sum. Then we can solve 4Sum.

It's easy to think that we loop the array and get the first the element, then the rest array is 3Sum problem. Since the code is pretty simple, I will avoid duplicate introducation here.

[5]:	https://github.com/raywenderlich/swift-algorithm-club/tree/master/Two-Sum%20Problem
