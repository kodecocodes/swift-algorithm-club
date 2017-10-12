# 3Sum and 4Sum

3Sum and 4Sum are extensions of a popular algorithm question, the [2Sum][5]. This article will talk about the problem and describe possible solutions.

## 3Sum

> Given an array of integers, find all subsets of the array with 3 values where the 3 values sum up to a target number. 
>
> **Note**: The solution subsets must not contain duplicate triplets.
>
> For example, given the array [-1, 0, 1, 2, -1, -4], and the target **0**:
> The solution set is: [[-1, 0, 1], [-1, -1, 2]] // The two **-1** values in the array are considered to be distinct

There are 2 key procedures in solving this algorithm. Sorting the array, and avoiding duplicates.

### Pre-sorting

Sorting your input array allows for powerful assumptions:

* duplicates are always adjacent to each other
* moving an index to the right increases the value, while moving an index to the left decreases the value

You'll make use of these two rules to create an efficient algorithm.

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
