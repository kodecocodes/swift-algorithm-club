# 3Sum and 4Sum

3Sum and 4Sum are extensions of a popular algorithm question, the [2Sum][5]. 

## 3Sum

> Given an array of integers, find all subsets of the array with 3 values where the 3 values sum up to a target number. 
>
> **Note**: The solution subsets must not contain duplicate triplets.
>
> For example, given the array [-1, 0, 1, 2, -1, -4], and the target **0**:
> The solution set is: [[-1, 0, 1], [-1, -1, 2]] // The two **-1** values in the array are considered to be distinct

There are 2 key procedures in solving this algorithm. Sorting the array, and avoiding duplicates.

### Sorting

Sorting your input array allows for powerful assumptions:

* duplicates are always adjacent to each other
* moving an index to the right increases the value, while moving an index to the left decreases the value

You'll make use of these two rules to create an efficient algorithm.

### Avoiding Duplicates

Since you pre-sort the array, duplicates will be adjacent to each other. You just need to skip over duplicates by comparing adjacent values:

```swift
extension Collection where Element: Equatable {
  
  /// In a sorted collection, replaces the given index with a successor mapping to a unique element.
  ///
  /// - Parameter index: A valid index of the collection. `index` must be less than `endIndex`
  func formUniqueIndex(after index: inout Index) {
    var prev = index
    repeat {
      prev = index
      formIndex(after: &index)
    } while index < endIndex && self[prev] == self[index]
  }
}
```

A similar implementation is used to get the unique index *before* a given index:

```swift
extension BidirectionalCollection where Element: Equatable {
  
  /// In a sorted collection, replaces the given index with a predecessor that maps to a unique element.
  ///
  /// - Parameter index: A valid index of the collection. `index` must be greater than `startIndex`.
  func formUniqueIndex(before index: inout Index) {
    var prev = index
    repeat {
      prev = index
      formIndex(before: &index)
    } while index > startIndex && self[prev] == self[index]
  }
}
```

### Assembling the Subsets

You'll keep track of 3 indices to represent the 3 numbers. The sum at any given moment is `array[l] + array[m] + array[r]`:

```swift
      m ->      <- r
[-4, -1, -1, 0, 1, 2]
  l   
```

The premise is quite straightforward (given that you're familiar with 2Sum). You'll iterate `l` through the array. For every iteration, you also apply the 2Sum algorithm to elements after `l`. You'll check the sum every time you moving the indices to check if you found match. Here's the algorithm:

```swift
func threeSum<T: BidirectionalCollection>(_ collection: T, target: T.Element) -> [[T.Element]] where T.Element: Numeric & Comparable {
  let sorted = collection.sorted()
  var ret: [[T.Element]] = []
  var l = sorted.startIndex
  
  ThreeSum: while l < sorted.endIndex { defer { sorted.formUniqueIndex(after: &l) }
    var m = sorted.index(after: l)
    var r = sorted.index(before: sorted.endIndex)
    
    TwoSum: while m < r && r < sorted.endIndex { 
      let sum = sorted[l] + sorted[m] + sorted[r]
      if sum == target {
        ret.append([sorted[l], sorted[m], sorted[r]])
        sorted.formUniqueIndex(after: &m)
        sorted.formUniqueIndex(before: &r)
      } else if sum < target {
        sorted.formUniqueIndex(after: &m)
      } else {
        sorted.formUniqueIndex(before: &r)
      }
    }
  }
  
  return ret
}
```

## 4Sum

> Given an array S of n integers, find all subsets of the array with 4 values where the 4 values sum up to a target number. 
>
> **Note**: The solution set must not contain duplicate quadruplets.

### Solution

Foursum is a very straightforward extension to the threeSum algorithm. In threeSum, you kept track of 3 indices:

```swift
      m ->      <- r
[-4, -1, -1, 0, 1, 2]
  l   
```

For fourSum, you'll keep track of 4:

```swift
         mr ->  <- r
[-4, -1, -1, 0, 1, 2]
  l  ml -> 
```

Here's the code for it (notice it is very similar to 3Sum):

```swift
func fourSum<T: BidirectionalCollection>(_ collection: T, target: T.Element) -> [[T.Element]] where T.Element: Numeric & Comparable {
  let sorted = collection.sorted()
  var ret: [[T.Element]] = []
  
  var l = sorted.startIndex
  FourSum: while l < sorted.endIndex { defer { sorted.formUniqueIndex(after: &l) }
    var ml = sorted.index(after: l)
    
    ThreeSum: while ml < sorted.endIndex { defer { sorted.formUniqueIndex(after: &ml) }
      var mr = sorted.index(after: ml)
      var r = sorted.index(before: sorted.endIndex)
      
      TwoSum: while mr < r && r < sorted.endIndex {
        let sum = sorted[l] + sorted[ml] + sorted[mr] + sorted[r]
        if sum == target {
          ret.append([sorted[l], sorted[ml], sorted[mr], sorted[r]])
          sorted.formUniqueIndex(after: &mr)
          sorted.formUniqueIndex(before: &r)
        } else if sum < target {
          sorted.formUniqueIndex(after: &mr)
        } else {
          sorted.formUniqueIndex(before: &r)
        }
      }
    }
  }
  return ret
}
```

[5]:	https://github.com/raywenderlich/swift-algorithm-club/tree/master/Two-Sum%20Problem

*Written for the Swift Algorithm Club by Kai Chen and Kelvin Lau*
