/*
  Deque (pronounced "deck"), a double-ended queue

  All enqueuing and dequeuing operations are O(1).
*/
public struct Deque<T> {
  private var array: [T?]
  private var head: Int
  private var capacity: Int

  public init(_ capacity: Int = 10) {
    self.capacity = max(capacity, 1)
    array = .init(count: capacity, repeatedValue: nil)
    head = capacity
  }

  public var isEmpty: Bool {
    return count == 0
  }

  public var count: Int {
    return array.count - head
  }

  public mutating func enqueue(_ element: T) {
    array.append(element)
  }

  public mutating func enqueueFront(_ element: T) {
    if head == 0 {
      capacity *= 2
      let emptySpace = [T?](count: capacity, repeatedValue: nil)
      array.insertContentsOf(emptySpace, at: 0)
      head = capacity
    }

    head -= 1
    array[head] = element
  }

  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    if capacity > 10 && head >= capacity*2 {
      let amountToRemove = capacity + capacity/2
      array.removeFirst(amountToRemove)
      head -= amountToRemove
      capacity /= 2
    }
    return element
  }

  public mutating func dequeueBack() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeLast()
    }
  }

  public func peekFront() -> T? {
    if isEmpty {
      return nil
    } else {
      return array[head]
    }
  }

  public func peekBack() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.last!
    }
  }
}
