# Fenwick Tree

Fenwick Tree or Binary Indexed Tree is a data structure that can efficiently update elements and calculate prefix sums in an array of numbers.

Fenwick Tree is really usefull when the array is dynamically changed. Because if there aren't many changes happening to the array, cumulative sum will be probably the best way to go.

Your task is to:
- Answer sum of elements between ranges [L, R)
- Update an item at specific position

For example, if we have an array of numbers:

```swift
var a = [5, 2, -1, 84, -4, 13, 5]
```

We want to query this array on the interval from 2 to 5, so the answer will be as following:

	2 + -1 + 84 + -4 = 81

The native approach would be to sum all numbers inside the interval range which will lead to **O(n)** time complexity:

```swift
func query(array: [Int], l: Int, r: Int) -> Int {
  var sum = 0
  for i in l...r {
    sum += array[i]
  }
  return sum
}
```
Fenwick Tree allows us to answer queries and update itmes in **O(log n)**, how? keep on reading.

The main idea of Fenwick tree is to hold partly cumulative sums from specific ranges in the array so for updating an item or querying an interval, we don't have to go through all items, just related items.

## Structure of Fenwick tree

A Fenwick tree is based up on an one-based array of elements, but we don't actually hold children of parent inside the nodes. here's Fenwick's class:

```swift
public class FenwickTree<T> {
	/// Holds values regarding to fenwick tree
	fileprivate(set) var fenwickTree: [T]
	/// Holds real values after updates
	fileprivate(set) var array: [T]
	let zero: T
	fileprivate let addFunction: (T, T) -> T
	fileprivate let subFunction: (T, T) -> T
	
	fileprivate let leastSignificantBit: (Int) -> Int = { $0 & -$0 }
}
```

Each node has at max **log(n)** children (Exactly **log(LSOne(n))** children), and one parent. If we drop an index'es LSOne(Least Significant One) we will reach a node's left-sibling, and if we add an index with it's LSOne, we will reach a node's parent index.

![structure](http://community.topcoder.com/i/education/binaryIndexedTrees/BITimg.gif)

## Updates

If an item is updated, it only affects it's parent. (and of-course this relationship is recursive i.e it's parent will affect it's grand-parent and so on...) so for updating an item, we just need to keep updating values and changing index to our parent till we reach end of an array (reaching bigger index than size of the array)

```swift
func add(itemAt index: Int, with value: T) {
		array[index] = addFunction(array[index], value)
		var index = index + 1
		while index <= fenwickTree.count {
			fenwickTree[index - 1] = addFunction(fenwickTree[index - 1], value)
			index += leastSignificantBit(index)
		}
		
	}
```

*Used `index-1` because fenwick must be based on an one-based array*

## Queries
Here's how we perform queries from start of array:

```swift
func sum(to: Int) -> T {
		guard to >= 0 && to < fenwickTree.count
			else {
				return zero
		}
		
		var sum = zero
		var index = to + 1
		while index > 0 {
			sum = addFunction(sum, fenwickTree[index - 1])
			index -= leastSignificantBit(index)
		}
		return sum
	}
```

We keep summing a node's value with all of it's left-siblings, this value will be equal to cumulative sum from start of array.

It's obvious that if we want to calculate an interval, we can just calculate their cumulative sums and subtract them from each other:

```swift
func sum(from: Int, to: Int) -> T {
		let leftSum = from == 0 ? zero : sum(to: from - 1)
		let rightSum = sum(to: to)
		return subFunction(rightSum, leftSum)
	}
```

There's also one additional query in fenwick tree which in some cases you might want to know the first index which cumulative sum has reached some minimum value, we can also calculate this index like this:

```swift
extension FenwickTree where T: Comparable {
	func index(forMinimumSum minSum: T) -> Int {
		var index = 1
		var localSum = zero
		while index != fenwickTree.count && addFunction(localSum, fenwickTree[index - 1]) < minSum {
			let lsb = leastSignificantBit(index)
			if index + lsb <= fenwickTree.count && addFunction(localSum, fenwickTree[index + lsb - 1]) < minSum {
				index += lsb
			}
			else {
				localSum = addFunction(localSum, fenwickTree[index - 1])
				index += 1
			}
		}
		return index - 1
	}
}
```


All mentioned operations are in **O(log n)** complexity time.


## Segment Tree vs Fenwick Tree

This is very popular topic when it comes to Fenwick and Segment. Both of them perform operations in same order but Segment trees are more customizable and more understandable because it's a binary tree. but with fenwick, understanding relations between nodes requires bit-operation knowledge and understanding what happenes when LSOne is added or subtracted from a number. But anyway, For cumulative sums (or multiplications) fenwick tree is faster than segment. It's because all operations are in binary level and based on static array (hence it might be optimized due to cash memory and other low-level stuff)

## See Also

[Fenwick Tree in TopCoder](https://www.topcoder.com/community/data-science/data-science-tutorials/binary-indexed-trees/)

[Segment Tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Segment%20Tree)

*Written for Swift Algorithm Club by [Farzad Sharbafian](https://github.com/FarzadShbfn)*
*Follow me on Twitter [FarzadShbfn](https://twitter.com/FarzadShbfn)*
