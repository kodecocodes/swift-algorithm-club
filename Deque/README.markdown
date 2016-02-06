# Deque

A double-ended queue. For some reason this is pronounced as "deck".

A regular [queue](../Queue/) adds new elements to the back and dequeues from the front. The deque also allows enqueuing at the front and dequeuing from the back, and peeking at both ends.

Here is a very basic implementation of a deque in Swift:

```swift
public struct Deque<T> {
  private var array = [T]()
  
  public var isEmpty: Bool {
    return array.isEmpty
  }
  
  public var count: Int {
    return array.count
  }
  
  public mutating func enqueue(element: T) {
    array.append(element)
  }
  
  public mutating func enqueueFront(element: T) {
    array.insert(element, atIndex: 0)
  }
  
  public mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }
  
  public mutating func dequeueBack() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeLast()
    }
  }
  
  public func peekFront() -> T? {
    return array.first
  }
  
  public func peekBack() -> T? {
    return array.last
  }
}
```

This uses an array internally. Enqueuing and dequeuing is simply a matter of adding and removing items from the front or back of the array.

An example of how to use it in a playground:

```swift
var deque = Deque<Int>()
deque.enqueue(1)
deque.enqueue(2)
deque.enqueue(3)
deque.enqueue(4)

deque.dequeue()       // 1
deque.dequeueBack()   // 4

deque.enqueueFront(5)
deque.dequeue()       // 5
```

This particular implementation of `Deque` is simple but not very efficient. Several operations are **O(n)**, notably `enqueueFront()` and `dequeue()`. I've included it only to show the principle of what a deque does.
  
A more efficient implementation would use a [doubly linked list](../Linked List/), a [circular buffer](../Ring Buffer/), or two [stacks](../Stack/) facing opposite directions.

*Written for Swift Algorithm Club by Matthijs Hollemans*
