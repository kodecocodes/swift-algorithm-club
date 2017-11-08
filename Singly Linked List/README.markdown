# Singly-Linked List

#### How is this different to the Linked List implementation?
The existing Linked list implementation represents the same concept. However, the existing implementation has reference semantics and does not conform to the Collection protocol implemented in the Swift's standard Library. What SinglyLinkedList aims to contribute is a more idiomatic Swift implementation, that uses value semantics and copy-on-write as well as conforms to the collection protocol.

#### Conceptual representation
A Singly linked list is a non-contiguous sequence of data items in memory. Each element links to the next via a memory reference. Additionally, this implementation keeps track of the last element, which can be retrived in order O(1). However, the list can only be traversed from head to tail.

    +--------+    +--------+    +--------+    +--------+
    |        |    |        |    |        |    |        |
    | node 0 |--->| node 1 |--->| node 2 |--->| node 3 |---> nil
    |        |    |        |    |        |    |        |
    +--------+    +--------+    +--------+    +--------+
    ^                                         ^
    |                                         |
    Head                                      Tail

Each element in the list is represented with an instance of SinglyLinkedListNode class, which basically contains some data and a reference of optional type to the next node, which means that the last node's next reference is `nil`.

#### In-memory representation
In Swift, data types can have value or reference semantics. This implementation of a singly-linked list uses value semantics. Support for copy-on-write has been added in order to improve performance and delay copying the elements of the array until strictly necessary.

The image below shows how initially, after variable `l2` is assigned `l1`, a new instance of the struct SinglyLinkedList is created. Nevertheless, the indirect storage is still shared as indicated by the references that both l1 and l2 have pointing to a common area in memory.

![alt text](Images/SharedIndirectStorage.png "Two linked lists sharing the indirect storage")

Once a mutating operation happens --for example on `l2` to append a new element--, then the indirect storage and all nodes in the list is actually copied and the references from `l1` and `l2` are updated. This is ilustrated in the following figure.

![alt text](Images/CopiedIndirectStorage.png "A copy is created after editing one of the lists")

#### Implementation details
1. Direct access to the tail in O(1) by keeping a reference that gets updated only when an operation to the list modifies the tail.
2. Value semantics. This implementation of a singly-linked list uses a struct. When the list struct is assigned into another variable or passed as an argument to a function, a copy of the struct is made.
3. Copy-on write. Instances of SinglyLinkedList have an internal reference to an indirect storage allocated in the heap. When a copy of the list is made (according to its value semantics) the indirect storage is initialy shared between the copies. This means that a potentially large list can be accessed to read values in it without an expensive copy having to take place. However, as soon as there is a write access to the indirect storage when there are more than one instances referencing to it, a copy will be performed to guarantee value semantics.
4. Conformance to the Collection protocol.





## Performance of linked lists

EDITION
- *append*: Appends a new node to the end of the list. This method will modify the list's tail. If the list is empty, it will also modify the head. This operation's time complexity is *O(1)* since there's a reference to the tail node in this implementation.
- *prepend*: Inserts a new node at the start of the list. If the list is empty, it will also modify the head. This operation's time complexity is *O(1)* since there's a reference to the head node.
- *delete*: Finds a node in the list and deletes it. This operation's time complexity has an upper bound described by a linear function; O(n).

SEARCH
- find k-th to last element. Given a list with `n` number of elements and `k` being the passed parameter with `0` <= `k` <= `n`, this method has *O(k)*.

## Conforming to the Collection protocol
Collections are sequences, therefore the first step is to conform to the Sequence protocol.

```
extension SinglyLinkedList: Sequence {
    public func makeIterator() -> SinglyLinkedListForwardIterator<T> {
        return SinglyLinkedListForwardIterator(head: self.storage.head)
    }
}
```

We have used `SinglyLinkedListForwardIterator` an iterator class to keep track of the progress while iterating the structure:

```
public struct SinglyLinkedListForwardIterator<T> : IteratorProtocol {

    public typealias Element = T

    private(set) var head: SinglyLinkedListNode<T>?

    mutating public func next() -> T? {
        let result = self.head?.value
        self.head = self.head?.next
        return result
    }
}
```

Next, a collection needs to be indexable. Indexes are implemented by the data structure class. We have encapsulated this knowledge in instances of the class `SinglyLinkedListIndex`. 

```
public struct SinglyLinkedListIndex<T>: Comparable {
    fileprivate let node: SinglyLinkedListNode<T>?
    fileprivate let tag: Int

    public static func==<T>(lhs: SinglyLinkedListIndex<T>, rhs: SinglyLinkedListIndex<T>) -> Bool {
        return (lhs.tag == rhs.tag)
    }

    public static func< <T>(lhs: SinglyLinkedListIndex<T>, rhs: SinglyLinkedListIndex<T>) -> Bool {
        return (lhs.tag < rhs.tag)
    }
}
```

Finally, the methods in the collection to manipulate indexes are implemented below:
- startIndex: Index of the first element. Can be calculated with O(1).
- endIndex: Index that follows the last valid index in the collection. That is, the index that follows the tail's index. Can be calculated with O(1) if the count of elements is kept internally. However, the implementation below is O(n) with `n` being the number of elements in the list. 

```
extension SinglyLinkedList : Collection {

    public typealias Index = SinglyLinkedListIndex<T>

    public var startIndex: Index {
        get {
            return SinglyLinkedListIndex<T>(node: self.storage.head, tag: 0)
        }
    }

public var endIndex: Index {
    get {
        if let h = self.storage.head {
        let (_, numberOfElements) = findTail(in: h)
            return SinglyLinkedListIndex<T>(node: h, tag: numberOfElements)
        } else {
            return SinglyLinkedListIndex<T>(node: nil, tag: self.startIndex.tag)
        }
    }
}

public subscript(position: Index) -> T {
    get {
        return position.node!.value
    }
}

public func index(after idx: Index) -> Index {
    return SinglyLinkedListIndex<T>(node: idx.node?.next, tag: idx.tag+1)
    }
}
```

Conforming to the Collection protocol allows our class SinglyLinkedList to take adventage of all the collection methods included in the Stardard Library.

*Written by Borja Arias Drake*
