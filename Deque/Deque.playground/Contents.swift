//: Playground - noun: a place where people can play

public struct Deque<T> {
  private var array = [T]()

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var count: Int {
    return array.count
  }

  public mutating func enqueue(_ element: T) {
    array.append(element)
  }

  public mutating func enqueueFront(_ element: T) {
    array.insert(element, at: 0)
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

var deque = Deque<Int>()
deque.enqueue(1)
deque.enqueue(2)
deque.enqueue(3)
deque.enqueue(4)

deque.dequeue()       // 1
deque.dequeueBack()   // 4

deque.enqueueFront(5)
deque.dequeue()       // 5
