//: Playground - noun: a place where people can play

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

  /*
  // Slow version that looks at every element in the array.
  private func findInsertionPoint(newElement: T) -> Int {
    for i in 0..<array.count {
      if newElement <= array[i] {
        return i
      }
    }
    return array.count
  }
  */

  // Fast version that uses a binary search.
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



var a = OrderedArray<Int>(array: [5, 1, 3, 9, 7, -1])
a              // [-1, 1, 3, 5, 7, 9]

a.insert(4)    // inserted at index 3
a              // [-1, 1, 3, 4, 5, 7, 9]

a.insert(-2)   // inserted at index 0
a.insert(10)   // inserted at index 8
a              // [-2, -1, 1, 3, 4, 5, 7, 9, 10]
