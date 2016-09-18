# Segment Tree

I'm pleased to present to you Segment Tree. It's actually one of my favorite data structures because it's very flexible and simple in realization.

Let's suppose that you have an array **a** of some type and some associative function **f**. For example, the function can be sum, multiplication, min, max, [gcd](../GCD/), and so on.

Your task is to:

- answer a query for an interval given by **l** and **r**, i.e. perform `f(a[l], a[l+1], ..., a[r-1], a[r])`
- support replacing an item at some index `a[index] = newItem`

For example, if we have an array of numbers:

```swift
var a = [ 20, 3, -1, 101, 14, 29, 5, 61, 99 ]
```

We want to query this array on the interval from 3 to 7 for the function "sum". That means we do the following:

	101 + 14 + 29 + 5 + 61 = 210
	
because `101` is at index 3 in the array and `61` is at index 7. So we pass all the numbers between `101` and `61` to the sum function, which adds them all up. If we had used the "min" function, the result would have been `5` because that's the smallest number in the interval from 3 to 7.

Here's naive approach if our array's type is `Int` and **f** is just the sum of two integers:

```swift
func query(array: [Int], l: Int, r: Int) -> Int {
  var sum = 0
  for i in l...r {
    sum += array[i]
  }
  return sum
}
```

The running time of this algorithm is **O(n)** in the worst case, that is when **l = 0, r = n-1** (where **n** is the number of elements in the array). And if we have **m** queries to answer we get **O(m*n)** complexity.

If we have an array with 100,000 items (**n = 10^5**) and we have to do 100 queries (**m = 100**), then our algorithm will do **10^7** units of work. Ouch, that doesn't sound very good. Let's look at how we can improve it.

Segment trees allow us to answer queries and replace items with **O(log n)** time. Isn't it magic? :sparkles:

The main idea of segment trees is simple: we precalculate some segments in our array and then we can use those without repeating calculations.

## Structure of segment tree

A segment tree is just a [binary tree](../Binary Tree/) where each node is an instance of the `SegmentTree` class:

```swift
public class SegmentTree<T> {
  private var value: T
  private var function: (T, T) -> T
  private var leftBound: Int
  private var rightBound: Int
  private var leftChild: SegmentTree<T>?
  private var rightChild: SegmentTree<T>?
}
```

Each node has the following data:

- `leftBound` and `rightBound` describe an interval
- `leftChild` and `rightChild` are pointers to child nodes
- `value` is the result of applying the function `f(a[leftBound], a[leftBound+1], ..., a[rightBound-1], a[rightBound])`

If our array is `[1, 2, 3, 4]` and the function `f = a + b`, the segment tree looks like this:

![structure](Images/Structure.png)

The `leftBound` and `rightBound` of each node are marked in red.

## Building a segment tree

Here's how we create a node of the segment tree:

```swift
public init(array: [T], leftBound: Int, rightBound: Int, function: @escaping (T, T) -> T) {
    self.leftBound = leftBound
    self.rightBound = rightBound
    self.function = function

    if leftBound == rightBound {                    // 1
      value = array[leftBound]
    } else {
      let middle = (leftBound + rightBound) / 2     // 2

      // 3
      leftChild = SegmentTree<T>(array: array, leftBound: leftBound, rightBound: middle, function: function)
      rightChild = SegmentTree<T>(array: array, leftBound: middle+1, rightBound: rightBound, function: function)

      value = function(leftChild!.value, rightChild!.value)  // 4
    }
  }
```

Notice that this is a recursive method. You give it an array such as `[1, 2, 3, 4]` and it builds up the entire tree, from the root node to all the child nodes.

1. The recursion terminates if `leftBound` and `rightBound` are equal. Such a `SegmentTree` instance represents a leaf node. For the input array `[1, 2, 3, 4]`, this process will create four such leaf nodes: `1`, `2`, `3`, and `4`. We just fill in the `value` property with the number from the array.

2. However, if `rightBound` is still greater than `leftBound`, we create two child nodes. We divide the current segment into two equal segments (at least, if the length is even; if it's odd, one segment will be slightly larger).

3. Recursively build child nodes for those two segments. The left child node covers the interval **[leftBound, middle]** and the right child node covers **[middle+1, rightBound]**.

4. After having constructed our child nodes, we can calculate our own value because **f(leftBound, rightBound) = f(f(leftBound, middle), f(middle+1, rightBound))**. It's math!

Building the tree is an **O(n)** operation.

## Getting answer to query

We go through all this trouble so we can efficiently query the tree.

Here's the code:

```swift
  public func query(withLeftBound: leftBound: Int, rightBound: Int) -> T {
    // 1
    if self.leftBound == leftBound && self.rightBound == rightBound {
      return self.value
    }
    
    guard let leftChild = leftChild else { fatalError("leftChild should not be nil") }
    guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }
    
    // 2
    if leftChild.rightBound < leftBound {
      return rightChild.query(withLeftBound: leftBound, rightBound: rightBound)
      
    // 3
    } else if rightChild.leftBound > rightBound {
      return leftChild.query(withLeftBound: leftBound, rightBound: rightBound)
      
    // 4
    } else {
      let leftResult = leftChild.query(withLeftBound: leftBound, rightBound: leftChild.rightBound)
      let rightResult = rightChild.query(withLeftBound: rightChild.leftBound, rightBound: rightBound)
      return function(leftResult, rightResult)
    }
  }
```

Again, this is a recursive method. It checks four different possibilities.

1) First, we check if the query segment is equal to the segment for which our current node is responsible. If it is we just return this node's value.

![equalSegments](Images/EqualSegments.png)

2) Does the query segment fully lie within the right child? If so, recursively perform the query on the right child.

![rightSegment](Images/RightSegment.png)

3) Does the query segment fully lie within the left child? If so, recursively perform the query on the left child.

![leftSegment](Images/LeftSegment.png)

4) If none of the above, it means our query partially lies in both children so we combine the results of queries on both children.

![mixedSegment](Images/MixedSegment.png)

This is how you can test it out in a playground:

```swift
let array = [1, 2, 3, 4]

let sumSegmentTree = SegmentTree(array: array, function: +)

sumSegmentTree.query(withLeftBound: 0, rightBound: 3)  // 1 + 2 + 3 + 4 = 10
sumSegmentTree.query(withLeftBound: 1, rightBound: 2)  // 2 + 3 = 5
sumSegmentTree.query(withLeftBound: 0, rightBound: 0)  // just 1
sumSegmentTree.query(withLeftBound: 3, rightBound: 3)  // just 4
```

Querying the tree takes **O(log n)** time.

## Replacing items

The value of a node in the segment tree depends on the nodes below it. So if we want to change a value of a leaf node, we need to update all its parent nodes too.

Here is the code:

```swift
  public func replaceItem(at index: Int, withItem item: T) {
    if leftBound == rightBound {
      value = item
    } else if let leftChild = leftChild, rightChild = rightChild {
      if leftChild.rightBound >= index {
        leftChild.replaceItem(at: index, withItem: item)
      } else {
        rightChild.replaceItem(at: index, withItem: item)
      }
      value = function(leftChild.value, rightChild.value)
    }
  }
```

As usual, this works with recursion. If the node is a leaf, we just change its value. If the node is not a leaf, then we recursively call `replaceItem(at: )` to update its children. After that, we recalculate the node's own value so that it is up-to-date again.

Replacing an item takes **O(log n)** time.

See the playground for more examples of how to use the segment tree.

## See also

[Segment tree at PEGWiki](http://wcipeg.com/wiki/Segment_tree)

*Written for Swift Algorithm Club by [Artur Antonov](https://github.com/goingreen)*
