# Bottom-up Segment Tree

## Structure of segment tree

A Bottom-up Segment Tree is decribed by an array which store the values of original array and some calculated results. The major difference between Bottom-up Segment Tree and Segment Tree are type of stored properties and instance build sequences.  Here are some preparations in advanced of implementing a Bottom-up Segment Tree class, and we can use it generically in the future:

```swift
public protocol InitializeWithoutParametersable: Comparable {
	init()
	static var nomalizeValue: Self {get}
}
extension Int: InitializeWithoutParametersable {
	public static var nomalizeValue: Int {
		return 1
	}
}
extension Double: InitializeWithoutParametersable {
	public static var nomalizeValue: Double {
		return 1.0
	}
}
extension String: InitializeWithoutParametersable {
	public static var nomalizeValue: String {
		return ""
	}
}
```
Each node of a Bottom-up Segment Tree lives inside an array, so it doesn't use parent/child pointers.

```swift
public class BottomUpSegmentTree<T: InitializeWithoutParametersable> {
	private var arrayCount: Int!
	private var leavesCapacity: Int!
	private var function: (T, T) -> T
	private var associatedtypeInitValue: T!
	private var result: [T]!
}
```

- Each element of `result` array is a node of tree, and its value is the result of applying the function `f(a[leftBound], a[leftBound+1], ..., a[rightBound-1], a[rightBound])`.
- `leftBound` and `rightBound` describe an interval
- `arrayCount` and `leavesCapacity` are the count of array and maximun count of the source array can appending elements without increaseing the result array capacity.
- `value` is the result of applying the function `f(a[leftBound], a[leftBound+1], ..., a[rightBound-1], a[rightBound])`

![Structure](Images/BUST1.png)

### Bitwise Operators

If `i` is the index of a node, then the following formulas give the array indices of its parent and child nodes:

	parent(i) = i>>1
	left(i)   = i<<1
	right(i)  = i<<1 + 1


If our array is `[1, 2, 3, 4]` and the function `f = a + b`, the segment tree looks like this:

`[0, 10, 3, 7, 1, 2, 3, 4]`

For example, the `result[2] = 3` is the result of applying the function `f(a[0], a[1]`. `a[0]` and `a[1]` are stored in `result[4]` and 'result[5]`, and their parent is stored in `result[2]`.
> Note: Please note that the start index of the node of a BottomUpSegmentTree is `1`. The value stored in the `result[0]` is useless.

## Building a bottom-up segment tree

Here's how we create a instance of the bottom-up segment tree:

```swift
// For best applies to most of functions, initialize an instance with providing associated type initial Value.
public init(array: [T], function: (T, T) -> T, associatedtypeInitValue: T) {
	self.function = function
	self.associatedtypeInitValue = associatedtypeInitValue
	self.arrayCount = array.count
	self.leavesCapacity = leavesCapacityUpdate(array)
	self.result = resultUpdate(array)
}

// Normally, for most calculating functions,  T() = (0) or T.nomalizeValue = (1) are the best initial value of a numeric associated type.
public init(array: [T], function: (T, T) -> T, associatedtypeNeedInitValue: Bool) {
	self.function = function
	if associatedtypeNeedInitValue {
		self.associatedtypeInitValue = T.nomalizeValue
	} else {
		self.associatedtypeInitValue = T()
	}
	self.arrayCount = array.count
	// 1
	self.leavesCapacity = leavesCapacityUpdate(array)
	// 2 & 3
	self.result = resultUpdate(array)
}

// simply use T() = (0) for initialize an associated type .
public convenience init(array: [T], function: (T, T) -> T) {
	self.init(array: array, function: function, associatedtypeNeedInitValue: false)
}

// helping methods for build an BottomUpSegmentTree instance
private func leavesCapacityUpdate(array: [T]) -> Int {
	var n = array.count - 1
	for i in 1...64 {
		n /= 2
		if n == 0 {
			// 1
			return 1<<i
		}
	}
	return 0
}

private func resultUpdate(array: [T]) -> [T] {
	// 2
	var result = [T](count: leavesCapacity * 2, repeatedValue: associatedtypeInitValue)
	for i in array.indices {
		// 3
		result[leavesCapacity+i] = array[i]
	}
	// 4
	for j in (leavesCapacity-1).stride(to: 0, by: -1) {
		result[j] = function(result[j << 1], result[(j << 1) + 1])
	}
	return result
}
```
Notice that this is non-recursive method. You give it an array such as `[1, 2, 3, 4]` and it builds up the entire tree, from the leaf node to all the parent nodes using loop operations. `result[j] = function(result[j<<1], result[(j<<1)+1])` describe the value of a parent node index `j` is the result of applying function to children nodes index `j>>1` & `(j<<1) + 1`

1. Determine the `leavesCapacity` maximum numbers of leaves nodes we need to prepare for tree build. The value of `leavesCapacity` is `2^x` where `x` is the minimum interger to make `2^x` just greater than or equal the count of input array. For example, `[1,2,3,4,5,6]` is the input array and it's count is `6`, so the `leavesCapacity = 2^3 = 8`.

2. Creat an array with doule of leavesCapacity.

3. Put elements of input array to tree. The relation of indexies of both array is `result[leavesCapacity+i] = array[i]`

4. Update the remaining values from leaves till the root.

4. After having constructed our child nodes, we can calculate our own value because **f(leftBound, rightBound) = f(f(leftBound, middle), f(middle+1, rightBound))**. It's math!

Building the tree is an **O(n)** operation.

## Getting answer to query

We go through all this trouble so we can efficiently query the tree.

Here's the code of query methodes:

```swift
extension BottomUpSegmentTree {
	// MARK: - query
	
	public func queryWithLeftBound(leftBound: Int, rightBound: Int) -> T {
		// 1
		guard leftBound >= 0 && leftBound <= arrayCount && rightBound >= 0 && rightBound <= arrayCount else { fatalError("index error") }
		guard leftBound <= rightBound else { fatalError("leftBound should be equal or less than rightBound") }
		// 2
		var s = leftBound + leavesCapacity - 1, t = rightBound + leavesCapacity + 1
		var ans = associatedtypeInitValue
		while s ^ t != 1 {
			// result will be effected if the sequence of input arguments is different
			ans = s & 1 == 0 ? function(ans, result[s+1]) : ans
			ans = t & 1 == 1 ? function(result[t-1], ans) : ans
			s>>=1
			t>>=1
		}
		return ans
	}
	
	public func queryWithRange(range: Range<Int>) -> T {
		return queryWithLeftBound(range.startIndex, rightBound: range.endIndex - 1)
	}
}
```
Again, this is a non-recursive method. It checks four different possibilities.

![](Images/BUST2.png)
![](Images/BUST3.png)

1) First, we check if the query interval is legal.

2) Make some calculation to transform index of input array to the index of tree, their relation is `index(node) = index(input) + leavesCapacity`. And use open interval to describe the query segment.

3) Use bitwise logical operations, we can easily know a node is a leftChild or a rightChild of its parent node. So we can know the query segment fully lie within the right child, or within the left child or none of above. By doing the calqulation, we can know how to combine minimum numbers of nodes value to get final results. For example, query range is `1...4` and input array size is 6. Please refer diagrams above, we only need to combine values of `node9`, `node5` and `node12` to get the result.

This is how you can test it out in a playground:

```swift
let array = [1, 2, 3, 4]

var sumSegmentTree = BottomUpSegmentTree(array: array, function: +)

sumSegmentTree.queryWithLeftBound(0, rightBound: 3)  // 1 + 2 + 3 + 4 = 10
sumSegmentTree.queryWithLeftBound(1, rightBound: 2)  // 2 + 3 = 5
sumSegmentTree.queryWithLeftBound(0, rightBound: 0)  // just 1
sumSegmentTree.queryWithLeftBound(3, rightBound: 3)  // just 4
//sumSegmentTree.queryWithLeftBound(3, rightBound: 2)  // fatal error

sumSegmentTree.queryWithRange(0...3)
sumSegmentTree.queryWithRange(1...2)
sumSegmentTree.queryWithRange(0...0)
sumSegmentTree.queryWithRange(3...3)
//sumSegmentTree.queryWithRange(3...2) // fatal error
```

Querying the tree takes **O(log n)** time.

## Replacing items

The value of a node in the segment tree depends on the nodes below it. So if we want to change a value of a leaf node, we need to update all its parent nodes too. We can append new element as well. A Bottom-up segment tree is very flexible to appending new element. After appending, if the input array size is not exceed `leavesCapacity`, the updating process is as simple as replace a item. 

> Note: The tree capacity will neet to enlarge if the input array size is exceed `leavesCapacity`.

Here is the code:

```swift
extension BottomUpSegmentTree {
	// MARK: - Replace Item
	
	public func replaceItemAtIndex(index: Int, withItem item: T) {
		self.result[index + leavesCapacity] = item
		var j = (leavesCapacity + index)>>1
		while j > 0 {
			result[j] = function(result[j<<1], result[j<<1 + 1])
			j>>=1
		}
	}
	
	public func appendArray(newElement: T) {
		if arrayCount == leavesCapacity {
			var array = [T]()
			for i in leavesCapacity..<leavesCapacity<<1 {
				array.append(result[i])
			}
			array.append(newElement)
			self.leavesCapacity = leavesCapacityUpdate(array)
			self.result = resultUpdate(array)
		} else {
			replaceItemAtIndex(arrayCount, withItem: newElement)
			arrayCount =  arrayCount + 1
		}
	}
}
```
Replace and append work with non-recursion.

Replacing an item takes **O(log n)** time.

## Debugging

```swift

extension BottomUpSegmentTree: CustomStringConvertible {
	// MARK: - Debugging, CustomStringConvertible
	
	public var description: String {
		return result.description
	}
}
```
See the playground for more examples of how to use the segment tree.

## See also

[Bottom-up Segment tree (Chinese)](http://wenku.baidu.com/link?url=57dSmipYHQx56SfyjgSXf62-gsRw7Fmg3xrMjLzdu12LroANGLvCWPUW1kOSFsVrmqfOK64xvmYw8MtZkUX49O27ZupjnBo7CD72I0L2Ou3)



