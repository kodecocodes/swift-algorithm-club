/*
  First-in first-out queue (FIFO)

  New elements are added to the end of the queue. Dequeuing pulls elements from
  the front of the queue.

  Enqueuing and dequeuing are O(1) operations.
*/
public struct Queue<T> {
  fileprivate var array = [T?]()
  fileprivate var head = 0

  public var isEmpty: Bool {
    return count == 0
  }

  public var count: Int {
    return array.count - head
  }

  public mutating func enqueue(_ element: T) {
    array.append(element)
  }

  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    let percentage = Double(head)/Double(array.count)
    if array.count > 50 && percentage > 0.25 {
      array.removeFirst(head)
      head = 0
    }

    return element
  }

  public func peek() -> T? {
    if isEmpty {
      return nil
    } else {
      return array[head]
    }
  }
}
