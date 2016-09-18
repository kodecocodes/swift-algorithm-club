# Bounded Priority queue

A bounded priority queue is similar to a regular [priority queue](../Priority Queue/), except that there is a fixed upper bound on the number of elements that can be stored. When a new element is added to the queue while the queue is at capacity, the element with the highest priority value is ejected from the queue.

## Example

Suppose we have a bounded-priority-queue with maximum size 5 that has the following values and priorities:

```
Value:    [ A,   B,   C,    D,    E   ]
Priority: [ 4.6, 3.2, 1.33, 0.25, 0.1 ]
```

Here, we consider the object with the highest priority value to be the most important (so this is a *max-priority* queue). The larger the priority value, the more we care about the object. So `A` is more important than `B`, `B` is more important than `C`, and so on.

Now we want to insert the element `F` with priority `0.4` into this bounded priority queue. Because the queue has maximum size 5, this will insert the element `F` but then evict the lowest-priority element (`E`), yielding the updated queue:

```
Value:    [ A,   B,   C,    F,   D    ]
Priority: [ 4.6, 3.2, 1.33, 0.4, 0.25 ]
```

`F` is inserted between `C` and `D` because of its priority value. It's less important than `C` but more important than `D`.

Suppose that we wish to insert the element `G` with priority 0.1 into this BPQ. Because `G`'s priority value is less than the minimum-priority element in the queue, upon inserting `G` it will immediately be evicted. In other words, inserting an element into a BPQ with priority less than the minimum-priority element of the BPQ has no effect.

## Implementation

While a [heap](../Heap/) may be a really simple implementation for a priority queue, a sorted [linked list](../Linked List/) allows for **O(k)** insertion and **O(1)** deletion, where **k** is the bounding number of elements.

Here's how you could implement it in Swift:

```swift
public class BoundedPriorityQueue<T: Comparable> {
  private typealias Node = LinkedListNode<T>

  private(set) public var count = 0
  fileprivate var head: Node?
  private var tail: Node?
  private var maxElements: Int

  public init(maxElements: Int) {
    self.maxElements = maxElements
  }

  public var isEmpty: Bool {
    return count == 0
  }

  public func peek() -> T? {
    return head?.value
  }
```

The `BoundedPriorityQueue` class contains a doubly linked list of `LinkedListNode` objects. Nothing special here yet. The fun stuff happens in the `enqueue()` method:

```swift
public func enqueue(_ value: T) {
  if let node = insert(value, after: findInsertionPoint(value)) {
    // If the newly inserted node is the last one in the list, then update
    // the tail pointer.
    if node.next == nil {
      tail = node
    }

    // If the queue is full, then remove an element from the back.
    count += 1
    if count > maxElements {
      removeLeastImportantElement()
    }
  }
}

private func insert(_ value: T, after: Node?) -> Node? {
  if let previous = after {

    // If the queue is full and we have to insert at the end of the list,
    // then there's no reason to insert the new value.
    if count == maxElements && previous.next == nil {
      print("Queue is full and priority of new object is too small")
      return nil
    }

    // Put the new node in between previous and previous.next (if exists).
    let node = Node(value: value)
    node.next = previous.next
    previous.next?.previous = node
    previous.next = node
    node.previous = previous
    return node

  } else if let first = head {
    // Have to insert at the head, so shift the existing head up once place.
    head = Node(value: value)
    head!.next = first
    first.previous = head
    return head

  } else {
    // This is the very first item in the queue.
    head = Node(value: value)
    return head
  }
}

/* Find the node after which to insert the new value. If this returns nil,
   the new value should be inserted at the head of the list. */
private func findInsertionPoint(_ value: T) -> Node? {
  var node = head
  var prev: Node? = nil

  while let current = node where value < current.value {
    prev = node
    node = current.next
  }
  return prev
}

private func removeLeastImportantElement() {
  if let last = tail {
    tail = last.previous
    tail?.next = nil
    count -= 1
  }

  // Note: Instead of using a tail pointer, we could just scan from the new
  // node until the end. Then nodes also don't need a previous pointer. But
  // this is much slower on large lists.
}
```

We first check if the queue already has the maximum number of elements. If so, and the new priority value is less than the `tail` element's priority value, then there is no room for this new element and we return without inserting it.

If the new value is acceptable, then we search through the list to find the proper insertion location and update the `next` and `previous` pointers.

Lastly, if the queue has now reached the maximum number of elements, then we `dequeue()` the one with the largest priority value.

By keeping the most important element at the front of the list, it makes dequeueing very easy:

```swift
public func dequeue() -> T? {
  if let first = head {
    count -= 1
    if count == 0 {
      head = nil
      tail = nil
    } else {
      head = first.next
      head!.previous = nil
    }
    return first.value
  } else {
    return nil
  }
}
```

This simply removes the `head` element from the list and returns it.

*Written for Swift Algorithm Club by John Gill and Matthijs Hollemans*
