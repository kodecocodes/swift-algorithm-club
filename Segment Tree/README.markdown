# Segment Tree

I'm pleased to present to you Segment Tree. It's actually one of my favorite data structures because it's very flexible and simple in realization.

Let's suppose that you have array **a** of some type and some associative function _**f**_(e.g. sum, multiplication, min, max, gcd).
Your task is:
 * answer a queries for given **l** and **r**: `f(a[l], a[l+1], ..., a[r-1], a[r])`
 * support replacing item at some index `a[index] = newItem`

Here's naive approach if our array's type is Int and _**f**_ is just sum of two integers:
```swift
func query(array: [Int], l: Int, r: Int) -> Int {
  var sum = 0
  for i in l...r {
    sum += array[i]
  }
  return sum
}
```
The running time of this algorithm is **O(n)** in worst case (**l = 0, r = n-1**). And if we have **m** queries to answer we get **O(m*n)** complexity.
If we have **n = 10^5** and **m = 100** our algorithm will do **10^7** units of work, ouh it's sounds not very good. Let's look how we can improve it.

Segment trees allow us answer a queries and replace items on **O(log n)**, isn't it magic?:sparkles:
The main idea of segment trees is simple: we precalculate some segments in our array and then we can use it without repeating calculation.
## Structure of segment tree

Segment tree is just [binary tree](../Binary Tree/) where each node has:
  * `leftBound`
  * `rightBound`
  * `value` is actually `f(a[leftBound], a[leftBound+1], .., a[rightBound])`
  * `leftChild`
  * `rightChild`

Here's structure of segment tree for given array `[1, 2, 3, 4]` and **f = a+b**, pairs of leftBound and rightBound marked in red

![structure](Images/Structure.png)

## Building segment tree

Let's see how to build node of segment tree.
```swift
init(array: [T], leftBound: Int, rightBound: Int, function: (T, T) -> T) {
    self.leftBound = leftBound
    self.rightBound = rightBound
    self.function = function
    if leftBound == rightBound {
      value = array[leftBound]
    } else {
      let middle = (leftBound + rightBound) / 2
      leftChild = SegmentTree<T>(array: array, leftBound: leftBound, rightBound: middle, function: function)
      rightChild = SegmentTree<T>(array: array, leftBound: middle+1, rightBound: rightBound, function: function)
      value = function(leftChild!.value, rightChild!.value)
    }
  }
```

If out current leftBound and rightBound are equal it means that we are in leaf so we don't have any child nodes and we just fill in `value` property with `array[leftBound]` else we have two child nodes. In that case we divide our current segment into two equal (if length is even) segments: `middle = (leftBound + rightBound) / 2` **[leftBound, middle]** and **[middle+1, rightBound]** and then we build our child nodes for that segments. After we build our child nodes so we can easily calculate our value as `value = function(leftChild!.value, rightChild!.value)` because **f(leftBound, rightBound) = f(f(leftBound, middle), f(middle+1, rightBound))**

## Getting answer to query

```swift
public func queryWithLeftBound(leftBound: Int, rightBound: Int) -> T {
    if self.leftBound == leftBound && self.rightBound == rightBound { {
      return self.value
    } else if leftChild!.rightBound < leftBound {
      return rightChild!.queryWithLeftBound(leftBound, rightBound: rightBound)
    } else if rightChild!.leftBound > rightBound {
      return leftChild!.queryWithLeftBound(leftBound, rightBound: rightBound)
    } else {
      let leftResult = leftChild!.queryWithLeftBound(leftBound, rightBound: leftChild!.rightBound)
      let rightResult = rightChild!.queryWithLeftBound(rightChild!.leftBound, rightBound: rightBound)
      return function(leftResult, rightResult)
    }
  }
```
Firstly, we check if current query segment is equal to segment for which our current node responsible, if it is we just return its value.
```swift
return self.value
```

![equalSegments](Images/EqualSegments.png)

Else we check that our query segment fully lies in rightChild, if so we return result of query on rightChild
```swift
return rightChild!.queryWithLeftBound(leftBound, rightBound: rightBound)
```

![rightSegment](Images/RightSegment.png)

else if segment lies in leftChild we return result of query on leftChild.
 ```swift
 return leftChild!.queryWithLeftBound(leftBound, rightBound: rightBound)
 ```

![leftSegment](Images/LeftSegment.png)

If none of above-descripted runs it means our query lies in both child so we combine results of query on both child.

```swift
let leftResult = leftChild!.queryWithLeftBound(leftBound, rightBound: leftChild!.rightBound)
let rightResult = rightChild!.queryWithLeftBound(rightChild!.leftBound, rightBound: rightBound)
return function(leftResult, rightResult)
```

![mixedSegment](Images/MixedSegment.png)

## Replacing items

```swift
public func replaceItemAtIndex(index: Int, withItem item: T) {
    if leftBound == rightBound {
      value = item
    } else {
      if leftChild!.rightBound >= index {
        leftChild!.replaceItemAtIndex(index, withItem: item)
      } else {
        rightChild!.replaceItemAtIndex(index, withItem: item)
      }
      value = function(leftChild!.value, rightChild!.value)
    }
  }
```
Foremost, we check if current node is leaf and if so we just change its value otherwise we need to find out to which child index belongs and call same function on that child. After that we recalculate our value because it needs to be in actual state.

## Examples

Examples of using segment trees can be found in playground

## See also

[Segment tree](http://wcipeg.com/wiki/Segment_tree)

*Written for Swift Algorithm Club by [Artur Antonov](https://github.com/goingreen)*
