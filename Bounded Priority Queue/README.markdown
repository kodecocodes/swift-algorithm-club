# Bounded Priority queue

A bounded priority queue is similar to a regular [priority queue](../Priority Queue/), except that there is a fixed upper bound on the number of elements that can be stored. When a new element is added to the queue while the queue is at capacity, the element with the highest priority value is ejected from the queue.

## Example

Suppose we have a bounded-priority-queue with maximum size 5 that has the following values and priorities:

```
Value:    [ A,   B,    C,    D,   E   ]
Priority: [ 0.1, 0.25, 1.33, 3.2, 4.6 ]
```

Here, we consider the object with the lowest priority value to be the most important (so this is a *min-priority* queue). The larger the priority value, the less we care about the object. So `A` is more important than `B`, `B` is more important than `C`, and so on.

Now we want to insert the element `F` with priority `0.4` into this bounded priority queue. Because the queue has maximum size 5, this will insert the element `F` but then evict the lowest-priority element (`E`), yielding the updated queue:

```
Value:    [ A,   B,    F,   C,    D   ]
Priority: [ 0.1, 0.25, 0.4, 1.33, 3.2 ]
```

`F` is inserted between `B` and `C` because of its priority value. It's less important than `B` but more important than `C`.

Suppose that we wish to insert the element `G` with priority 4.0 into this BPQ. Because `G`'s priority value is greater than the maximum-priority element in the queue, upon inserting `G` it will immediately be evicted. In other words, inserting an element into a BPQ with priority greater than the maximum-priority element of the BPQ has no effect.

## Implementation

While a [heap](../Heap/) may be a really simple implementation for a priority queue, a sorted [linked list](../Linked List/) allows for **O(k)** insertion and **O(1)** deletion, where **k** is the bounding number of elements.

Here's how you could implement it in Swift:

```swift
public class BoundedPriorityQueue<T: Comparable> {
  private typealias Node = LinkedListNode<T>

  private(set) public var count = 0
  private var head: Node?
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
  public func enqueue(value: T) {
    let newNode = Node(value: value)

    if head == nil  {
      head = newNode
      count = 1
      return
    }

    var node = head
    if count == maxElements && newNode.value > node!.value {
      return
    }
    
    while (node!.next != nil) && (newNode.value < node!.value) {
      node = node!.next
    }
    
    if newNode.value < node!.value {
      newNode.next = node!.next
      newNode.previous = node
      
      if newNode.next != nil {     /* TAIL */
        newNode.next!.previous = newNode
      }
      node!.next = newNode
    } else {
      newNode.previous = node!.previous
      newNode.next = node
      if node!.previous == nil {   /* HEAD */
        head = newNode
      } else {
        node!.previous!.next = newNode
      }
      node!.previous = newNode
    }

    if count == maxElements {
      dequeue()
    }
    count += 1
  }
```

We first check if the queue already has the maximum number of elements. If so, and the new priority value is greater than the `head` element's priority value, then there is no room for this new element and we return without inserting it.

If the new value is acceptable, then we search through the list to find the proper insertion location and update the `next` and `previous` pointers.

Lastly, if the queue has now reached the maximum number of elements, then we `dequeue()` the one with the largest priority value.

By keeping the most important element at the front of the list, it makes dequeueing very easy:

```swift
  public func dequeue() -> T? {
    if count == 0 {
      return nil
    }

    let retVal = head!.value
    
    if count == 1 {
      head = nil
    } else {
      head = head!.next
      head!.previous = nil
    }

    count -= 1
    return retVal
  }
```

This simply removes the `head` element from the list and returns it.

*Written for Swift Algorithm Club by John Gill and Matthijs Hollemans*
