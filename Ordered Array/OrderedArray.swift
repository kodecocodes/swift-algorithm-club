/*
  An ordered array. When you add a new item to this array, it is inserted in
  sorted position.
*/
public struct OrderedArray<T: Comparable> {
  private var array = [T]()

  public init(array: [T]) {
    self.array = array.sort()
  }

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var count: Int {
    return array.count
  }

  public subscript(index: Int) -> T {
    return array[index]
  }

  public mutating func removeAtIndex(index: Int) -> T {
    return array.removeAtIndex(index)
  }

  public mutating func removeAll() {
    array.removeAll()
  }

  public mutating func insert(newElement: T) -> Int {
    let i = findInsertionPoint(newElement)
    array.insert(newElement, atIndex: i)
    return i
  }

  private func findInsertionPoint(newElement: T) -> Int {
    var range = 0..<array.count
    while range.startIndex < range.endIndex {
      let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
      if array[midIndex] == newElement {
        return midIndex
      } else if array[midIndex] < newElement {
        range.startIndex = midIndex + 1
      } else {
        range.endIndex = midIndex
      }
    }
    return range.startIndex
  }
}

extension OrderedArray: CustomStringConvertible {
  public var description: String {
    return array.description
  }
}
