# Lazy Propagation in Segment Tree

In previous implement about the Segment Tree by **Artur Antonov**, it's a strong data structure with *Generic* `<T>`. And we can pass a closure parameter `function: (T, T) -> T` to reflect the relationship between parent and child node. And in particular, Generic can solve multiple strings stitching problem. It's just like the sample in Playground:

```swift
stringSegmentTree.replaceItem(at: 0, withItem: "I")
stringSegmentTree.replaceItem(at: 1, withItem: " like")
stringSegmentTree.replaceItem(at: 2, withItem: " algorithms")
stringSegmentTree.replaceItem(at: 3, withItem: " and")
stringSegmentTree.replaceItem(at: 4, withItem: " swift")
stringSegmentTree.replaceItem(at: 5, withItem: "!")
print(stringSegmentTree.query(leftBound: 0, rightBound: 5))
// "I like algorithms and swift!"
```

The use of `<T>` is so exciting. But we seldom use the Segment Tree to solve string problem instead of *Suffix Array*. And the Segment Tree is a kind of *Interval Tree* to solve the Interval Problem in mathemtics and statistics, which is a structure for storing intervals, or segments, and allows querying which of the stored segments contain a given point. A segment tree for a set *I* of n intervals uses `O(nlogn)` storage and can be built in `O(nlogn)` time. Segment trees support searching for all the intervals that contain a query point in O(log n+k), k being the number of retrieved intervals or segments.

But that is common Segment Tree. By **Lazy Propagation**, we can implement to modify an interval in `O(logn)` time. Let's explore together in following:

## `PushUp` - update to the top

At first, we reference the implement of **Artur Antonov** about Segment Tree. This code contained *build*, *single update* and *interval query* three operation. The implement of *build* and *single update* operation is following:

```swift
// Author: Artur Antonov
public init(array: [T], leftBound: Int, rightBound: Int, function: @escaping (T, T) -> T) {
	self.leftBound = leftBound
	self.rightBound = rightBound
	self.function = function
	// ①
	if leftBound == rightBound {
		value = array[leftBound]
	} 
	// ②
	else {
		let middle = (leftBound + rightBound) / 2
		leftChild = SegmentTree<T>(array: array, leftBound: leftBound, rightBound: middle, function: function)
		rightChild = SegmentTree<T>(array: array, leftBound: middle+1, rightBound: rightBound, function: function)
		value = function(leftChild!.value, rightChild!.value)
	}
}
```

In position ①, it means the current node is *leaf* because its left bound data is equal to the right. So we assign a value to it directly. In position ②, it means the current node is *parent* (which has one or more children), and we need to recursion down and update current node's data in the follow-up process.

And then, we have a look for *interval query* operation:

```swift
// Author: Artur Antonov
public func query(leftBound: Int, rightBound: Int) -> T {
	if self.leftBound == leftBound && self.rightBound == rightBound {
		return self.value
	}
	guard let leftChild = leftChild else { fatalError("leftChild should not be nil") }
	guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }
	// ①
	if leftChild.rightBound < leftBound {
		return rightChild.query(leftBound: leftBound, rightBound: rightBound)
	} 
	// ②
	else if rightChild.leftBound > rightBound {
		return leftChild.query(leftBound: leftBound, rightBound: rightBound)
	}
	// ③ 
	else {
		let leftResult = leftChild.query(leftBound: leftBound, rightBound: leftChild.rightBound)
		let rightResult = rightChild.query(leftBound:rightChild.leftBound, rightBound: rightBound)
		return function(leftResult, rightResult)
	}
}
```

Position ① means that the left bound of current query interval is on the  right of this right bound, so recurs to right direction. Position ② is opposite of position ①, recurs to left direction. Position ③ means our check interval is included the interval we need, so recurs deeply.

![pushUp](Images/pushUp.png)

There are common part from the two parts of code above - **recurs deeply below, and update data up**. So we can decouple this operation named `func pushUp(lson: LazySegmentTree, rson: LazySegmentTree)`:

```swift
// MARK: - Push Up Operation
private func pushUp(lson: LazySegmentTree, rson: LazySegmentTree) {
    self.value = lson.value + rson.value
}
```

(This code only describe the *Sum Segment Tree*)

And then, we can update the implement before:

```swift
public init(array: [Int], leftBound: Int, rightBound: Int) {
    self.leftBound = leftBound
    self.rightBound = rightBound
    self.value = 0
    self.lazyValue = 0
    
    guard leftBound != rightBound else {
        value = array[leftBound]
        return
    }
    
    let middle = leftBound + (rightBound - leftBound) / 2
    leftChild = LazySegmentTree(array: array, leftBound: leftBound, rightBound: middle)
    rightChild = LazySegmentTree(array: array, leftBound: middle + 1, rightBound: rightBound)
    if let leftChild = leftChild, let rightChild = rightChild {
        pushUp(lson: leftChild, rson: rightChild)
    }
}
// MARK: - One Item Update
public func update(index: Int, incremental: Int) {
    guard self.leftBound != self.rightBound else {
        self.value += incremental
        return
    }
    guard let leftChild  = leftChild  else { fatalError("leftChild should not be nil") }
    guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }
    
    let middle = self.leftBound + (self.rightBound - self.leftBound) / 2
    
    if index <= middle { leftChild.update(index: index, incremental: incremental) }
    else { rightChild.update(index: index, incremental: incremental) }
    pushUp(lson: leftChild, rson: rightChild)
}
```

## `PushDown` - Lazy Propagation 

You may feel that the `pushUp` is so simple. In fact, this's just to lead `pushDown` this function.

Before this, I want to talk about the topic about **interval operation**. The interval operation is a way to update all elements of a continuous subset. But these isn't in the version of **Artur Antonov**. You might disdain with this, because it's solved with a `for` loop:

```swift
// Sample: update the elements with subscript [2, 5] 
for index in 2 ... 5 {
    sumSegmentTree.update(index: index, incremental: 3)
}
```

It is a `O(n)` time operation, which make the interval operation uses `O(nlogn)` time to update these elements. We need a `O(logn)` way to maintain the elegance of Segment Tree. 

 Check the data structure of Segment Tree again:
 
 ![Segment-tree](Images/Segment-tree.png)
 
We only catch the root node in programming. If we want to explore the bottom of the tree, and use `pushUp` to update every node, the task will be reached. So it asked us to traverse the tree, that spent `O(n)` time to do this with any way. This can't conform our expectations.  

Then we started to think about `pushDown` to update down from the root. **After we update the parent, the data continued to distributed to its children according to law.** But it still need `O(n)` time to do this. Keep thinking, we **only update the parent, and to update the children when `query` time**. Yeah, that's the key of **lazy propagation**. Because the recursing direct of the `query` and `update interval` is same. So we got it! 😁 Let's check this sample:

![lazy-sample-2](Images/lazy-sample-2.png)

`update` make the subscript 1...3 elements plus 2, so we make the 1st node in 2 depth and 3rd in 3 depth get a *lazy mark*, which means these node need to be updated. And we shouldn't add a *lazy mark* for root node, because it was updated before the `pushDown` in the first recursing. 

In `query` operation, we accord to the original method to recurs the tree, and find the 1st node held *lazy mark* in 2 depth, so to update it. It's the same situation about the 1st node in 3 depth.

Do you understand the **lazy propagation**? **In short, we only update the wide range node data and add it a lazy mark. Then they will be update when we need to query them.** And the *Update Down* operation is the function of `pushDown`.

This is the complete implementation about the Sum Segment Tree with interval update operation:

```swift
public class LazySegmentTree {
    
    private var value: Int
    
    private var leftBound: Int
    
    private var rightBound: Int
    
    private var leftChild: LazySegmentTree?
    
    private var rightChild: LazySegmentTree?
    
    // Interval Update Lazy Element
    private var lazyValue: Int
    
    // MARK: - Push Up Operation
    // Description: pushUp() - update items to the top
    private func pushUp(lson: LazySegmentTree, rson: LazySegmentTree) {
        self.value = lson.value + rson.value
    }
    
    // MARK: - Push Down Operation
    // Description: pushDown() - update items to the bottom
    private func pushDown(round: Int, lson: LazySegmentTree, rson: LazySegmentTree) {
        guard lazyValue != 0 else { return }
        lson.lazyValue += lazyValue
        rson.lazyValue += lazyValue
        lson.value += lazyValue * (round - (round >> 1))
        rson.value += lazyValue * (round >> 1)
        lazyValue = 0
    }
    
    public init(array: [Int], leftBound: Int, rightBound: Int) {
        self.leftBound = leftBound
        self.rightBound = rightBound
        self.value = 0
        self.lazyValue = 0
        
        guard leftBound != rightBound else {
            value = array[leftBound]
            return
        }
        
        let middle = leftBound + (rightBound - leftBound) / 2
        leftChild = LazySegmentTree(array: array, leftBound: leftBound, rightBound: middle)
        rightChild = LazySegmentTree(array: array, leftBound: middle + 1, rightBound: rightBound)
        if let leftChild = leftChild, let rightChild = rightChild {
            pushUp(lson: leftChild, rson: rightChild)
        }
    }
    
    public convenience init(array: [Int]) {
        self.init(array: array, leftBound: 0, rightBound: array.count - 1)
    }
    
    public func query(leftBound: Int, rightBound: Int) -> Int {
        if leftBound <= self.leftBound && self.rightBound <= rightBound {
            return value
        }
        guard let leftChild  = leftChild  else { fatalError("leftChild should not be nil") }
        guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }
        
        pushDown(round: self.rightBound - self.leftBound + 1, lson: leftChild, rson: rightChild)
        
        let middle = self.leftBound + (self.rightBound - self.leftBound) / 2
        var result = 0
        
        if leftBound <= middle { result +=  leftChild.query(leftBound: leftBound, rightBound: rightBound) }
        if rightBound > middle { result += rightChild.query(leftBound: leftBound, rightBound: rightBound) }
        
        return result
    }
    
    // MARK: - One Item Update
    public func update(index: Int, incremental: Int) {
        guard self.leftBound != self.rightBound else {
            self.value += incremental
            return
        }
        guard let leftChild  = leftChild  else { fatalError("leftChild should not be nil") }
        guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }
        
        let middle = self.leftBound + (self.rightBound - self.leftBound) / 2
        
        if index <= middle { leftChild.update(index: index, incremental: incremental) }
        else { rightChild.update(index: index, incremental: incremental) }
        pushUp(lson: leftChild, rson: rightChild)
    }
    
    // MARK: - Interval Item Update
    public func update(leftBound: Int, rightBound: Int, incremental: Int) {
        if leftBound <= self.leftBound && self.rightBound <= rightBound {
            self.lazyValue += incremental
            self.value += incremental * (self.rightBound - self.leftBound + 1)
            return 
        }
        
        guard let leftChild  = leftChild  else { fatalError("leftChild should not be nil") }
        guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }
        
        pushDown(round: self.rightBound - self.leftBound + 1, lson: leftChild, rson: rightChild)
        
        let middle = self.leftBound + (self.rightBound - self.leftBound) / 2
        
        if leftBound <= middle { leftChild.update(leftBound: leftBound, rightBound: rightBound, incremental: incremental) }
        if middle < rightBound { rightChild.update(leftBound: leftBound, rightBound: rightBound, incremental: incremental) }
        
        pushUp(lson: leftChild, rson: rightChild)
    }
    
}
```

Explain some sample snippets:

```swift
private var lazyValue: Int
```

Here we add a new property for Segment Tree to represent *lazy mark*. And it is a incremental value for Sum Segment Tree. If the `lazyValue` isn't equal to zero, the current node need to be updated. And its real value is equal to `value + lazyValue * (rightBound - leftBound + 1)`.

```swift
    // MARK: - Push Down Operation
    // Description: pushDown() - update items to the bottom
private func pushDown(round: Int, lson: LazySegmentTree, rson: LazySegmentTree) {
    guard lazyValue != 0 else { return }
    lson.lazyValue += lazyValue
    rson.lazyValue += lazyValue
    lson.value += lazyValue * (round - (round >> 1))
    rson.value += lazyValue * (round >> 1)
    lazyValue = 0
}
```

![pushdown](Images/pushdown.png)

At first we check whether the node needs to be updated. If the `lazyValue` isn't equal to zero, we need to `pushDown`. And the update rules are the `lazyValue * (rightBound - leftBound + 1)`. At last, reset the `lazyValue` to zero.

## Conclusion

This is the introduce of the Lazy Propagation in Segment Tree. You can also learn **Functional Segment Tree** to understand the Lazy Propagation deeply. In addition, I learn from the *notonlysuccess*'s code about Segment Tree described by C, this is the [link](http://www.cnblogs.com/Destiny-Gem/articles/3875243.html).

In fact, the operation of Segment Tree is far more than that. It can also be used to handle problems between collections. I want to implement it with Swift in the future and make the Swift Segment Tree stronger and stronger. 😁

---

*Written for Swift Algorithm Club by [Desgard_Duan](https://github.com/desgard)*
