/*
  An unordered array with a maximum size.

  Performance is always O(1).
*/
struct FixedSizeArray<T> {
  private var maxSize: Int
  private var defaultValue: T
  private var array: [T]
  private (set) var count = 0

  init(maxSize: Int, defaultValue: T) {
    self.maxSize = maxSize
    self.defaultValue = defaultValue
    self.array = [T](count: maxSize, repeatedValue: defaultValue)
  }

  subscript(index: Int) -> T {
    assert(index >= 0)
    assert(index < count)
    return array[index]
  }

  mutating func append(newElement: T) {
    assert(count < maxSize)
    array[count] = newElement
    count += 1
  }

  mutating func removeAtIndex(index: Int) -> T {
    assert(index >= 0)
    assert(index < count)
    count -= 1
    let result = array[index]
    array[index] = array[count]
    array[count] = defaultValue
    return result
  }

  mutating func removeAll() {
    for i in 0..<count {
      array[i] = defaultValue
    }
    count = 0
  }
}
