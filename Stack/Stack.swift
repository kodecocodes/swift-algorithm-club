/*
  Last-in first-out stack (LIFO)

  Push and pop are O(1) operations.
*/
public struct Stack<T> {
  private var array = [T]()

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var count: Int {
    return array.count
  }

  public mutating func push(element: T) {
    array.append(element)
  }

  public mutating func pop() -> T? {
    guard !array.isEmpty else { return nil }

    return array.removeLast()
  }

  public func peek() -> T? {
    return array.last
  }
}
