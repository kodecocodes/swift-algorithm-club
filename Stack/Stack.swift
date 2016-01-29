/*
  Last-in first-out stack (LIFO)

  Push and pop are O(1) operations.
*/
public struct Stack<T>: ArrayLiteralConvertible {
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
    if isEmpty {
      return nil
    } else {
      return array.removeLast()
    }
  }

  public func peek() -> T? {
    return array.last
  }
	
  // MARK: - ArrayLiteralConvertible
  public init(arrayLiteral elements: T...) {
	array = elements
  }
}
