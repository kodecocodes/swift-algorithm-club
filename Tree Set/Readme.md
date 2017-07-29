# Tree Set

[Hash Set](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Hash%20Set) has been introduced and implemented by Swift built-in Dictionary.
It has `O(1)` insert, remove and search time complexity. Compared to Hash Set, all actions time complexity are `O(logn)` since it's implemented by [Balance 
binary search tree](https://en.wikipedia.org/wiki/Self-balancing_binary_search_tree) (BST). 

## Benefits

We already have Hash Set, what's the benefits from Tree Set? Here are some.

* In worst case, Hash Set will have `O(n)` time complexity. If the hash function is not good enough, there will have a lot of collisions. For BST, it's strictly `O(logn)` time. 
* If you want to get all keys that are sorted. For Hash Set, it will cost `O(n)` to get and `O(nlogn)` time to sort. For BST, just `O(n)` time since all keys are sorted in the tree.
* If you want to get the first key or last key. Hash Set will cost `O(nlogn)` time, BST just cost `O(logn)` time.

## Implementation

Usually Tree Set is implemented by [Red-Black Tree](https://en.wikipedia.org/wiki/Red%E2%80%93black_tree) (RBTree). It's very stable and in the worst case it still have `O(logn)` time for all actions. We already have [RBTree Implementation](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Red-Black%20Tree), so Tree Set will implement based on this.

There are 2 kinds of Set. 
* MulitiSet. Allow duplicates.
* Set. Don't Allow.

In the RBTree, when insert a key, it will check if the key already existed. Then based on the duplicate requirement to insert or drop the key.

Here is the code.

```swift
public func insert(key: T) {
    // If key must be unique and find the key already existed, quit
    if search(input: key) != nil && !allowDuplicateNode {
        return
    }

    if root.isNullLeaf {
        root = RBNode(key: key)
    } else {
        insert(input: RBNode(key: key), node: root)
    }

    size += 1
}
```

Here is Tree Set Implementation.

```swift
public struct TreeSet<T: Comparable> {
    private var tree: RedBlackTree<T>

    public init(_ isMultiset: Bool = false) {
        tree = RedBlackTree<T>(isMultiset)
    }

    public mutating func insert(_ element: T) {
        tree.insert(key: element)
    }

    public mutating func remove(_ element: T) {
        tree.delete(key: element)
    }

    public func contains(_ element: T) -> Bool {
        return tree.search(input: element) != nil
    }

    public func allElements() -> [T] {
        return tree.allElements()
    }

    public var count: Int {
        return tree.count()
    }

    public var isEmpty: Bool {
        return tree.isEmpty()
    }
}
```



 
