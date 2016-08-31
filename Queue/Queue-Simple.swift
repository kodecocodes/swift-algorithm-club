/*
  First-in first-out queue (FIFO)

  New elements are added to the end of the queue. Dequeuing pulls elements from
  the front of the queue.

  Enqueuing is an O(1) operation, dequeuing is O(n). Note: If the queue had been
  implemented with a linked list, then both would be O(1).
*/
public struct Queue<T> {
  fileprivate var array = [T]()

  public var count: Int {
    return array.count
  }

  public var isEmpty: Bool {
    return array.isEmpty
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

  public func peek() -> T? {
    return array.first
  }
}
