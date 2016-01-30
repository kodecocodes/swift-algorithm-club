# Queue

A queue is a list where you can only insert new items at the back and remove items from the front. This ensures that the first item you enqueue is also the first item you dequeue. First come, first serve!

Why would you need this? Well, in many algorithms you want to add objects to a temporary list at some point and then pull them off this list again at a later time. Often the order in which you add and remove these objects matters.

A queue gives you a FIFO or first-in, first-out order. The element you inserted first is also the first one to come out again. It's only fair! (A very similar data structure, the [stack](../Stack/), is LIFO or last-in first-out.)

For example, let's enqueue a number:

```swift
queue.enqueue(10)
```

The queue is now `[ 10 ]`. Add the next number to the queue:

```swift
queue.enqueue(3)
```

The queue is now `[ 10, 3 ]`. Add one more number:

```swift
queue.enqueue(57)
```

The queue is now `[ 10, 3, 57 ]`. Let's dequeue to pull the first element off the front of the queue:

```swift
queue.dequeue()
```

This returns `10` because that was the first number we inserted. The queue is now `[ 3, 57 ]`. Everyone moved up by one place.

```swift
queue.dequeue()
```

This returns `3`, the next dequeue returns `57`, and so on. If the queue is empty, dequeuing returns `nil` or in some implementations it gives an error message.

> **Note:** A queue is not always the best choice. If the order in which the items are added and removed from the list isn't important, you might as well use a [stack](../Stack/) instead of a queue. Stacks are simpler and faster.

Here is a very simplistic implementation of a queue in Swift. It's just a wrapper around an array that lets you enqueue, dequeue, and peek at the front-most item:

```swift
public struct Queue<T> {
  var array = [T]()
  
  public var isEmpty: Bool {
    return array.isEmpty
  }
  
  public var count: Int {
    return array.count
  }
  
  public mutating func enqueue(element: T) {
    array.append(element)
  }
  
  public mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }
  
  public func peek() -> T? {
    return array.first
  }
}
```

This queue works just fine but it is not optimal.

Enqueuing is an **O(1)** operation because adding to the end of an array always takes the same amount of time, regardless of the size of the array. So that's great.

However, to dequeue we remove the element from the beginning of the array. This is an **O(n)** operation because it requires all remaining array elements to be shifted in memory.

More efficient implementations would use a linked list, a [circular buffer](../Ring Buffer/), or a [heap](../Heap/). (I might add an example of this later.)

Variations on this theme are [deque](../Deque/), a double-ended queue where you can enqueue and dequeue at both ends, and [priority queue](../Priority Queue/), a sorted queue where the "most important" item is always at the front.

*Written by Matthijs Hollemans*
