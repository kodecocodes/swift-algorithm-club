/*
  Queue

  A queue is a list where you can only insert new items at the back and
  remove items from the front. This ensures that the first item you enqueue
  is also the first item you dequeue. First come, first serve!

  A queue gives you a FIFO or first-in, first-out order. The element you
  inserted first is also the first one to come out again. It's only fair!

  In this implementation, enqueuing is an O(1) operation, dequeuing is O(n).
*/

public struct Queue<T> {
  fileprivate var array = [T]()

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var count: Int {
    return array.count
  }

  public mutating func enqueue(_ element: T) {
    array.append(element)
  }

  public mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }

  public var front: T? {
    return array.first
  }
}

// Create a queue and put some elements on it already.
var queueOfNames = Queue(array: ["Carl", "Lisa", "Stephanie", "Jeff", "Wade"])

// Adds an element to the end of the queue.
queueOfNames.enqueue("Mike")

// Queue is now ["Carl", "Lisa", "Stephanie", "Jeff", "Wade", "Mike"]
print(queueOfNames.array)

// Remove and return the first element in the queue. This returns "Carl".
queueOfNames.dequeue()

// Return the first element in the queue.
// Returns "Lisa" since "Carl" was dequeued on the previous line.
queueOfNames.front

// Check to see if the queue is empty.
// Returns "false" since the queue still has elements in it.
queueOfNames.isEmpty
