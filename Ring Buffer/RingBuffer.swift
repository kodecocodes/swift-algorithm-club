/*
  Fixed-length ring buffer

  In this implementation, the read and write pointers always increment and
  never wrap around. On a 64-bit platform that should not get you into trouble
  any time soon.

  Not thread-safe, so don't read and write from different threads at the same
  time! To make this thread-safe for one reader and one writer, it should be
  enough to change read/writeIndex += 1 to OSAtomicIncrement64(), but I haven't
  tested this...
*/
public struct RingBuffer<T> {
  private var array: [T?]
  private var readIndex = 0
  private var writeIndex = 0

  public init(count: Int) {
    array = [T?](repeating: nil, count: count)
  }

  /* Returns false if out of space. */
  @discardableResult
  public mutating func write(_ element: T) -> Bool {
    guard !isFull else { return false }
    defer {
        writeIndex += 1
    }
    array[wrapped: writeIndex] = element
    return true
  }

  /* Returns nil if the buffer is empty. */
  public mutating func read() -> T? {
    guard !isEmpty else { return nil }
    defer {
        array[wrapped: readIndex] = nil
        readIndex += 1
    }
    return array[wrapped: readIndex]
  }

  private var availableSpaceForReading: Int {
    return writeIndex - readIndex
  }

  public var isEmpty: Bool {
    return availableSpaceForReading == 0
  }

  private var availableSpaceForWriting: Int {
    return array.count - availableSpaceForReading
  }

  public var isFull: Bool {
    return availableSpaceForWriting == 0
  }
}

public extension RingBuffer: Sequence {
  public func makeIterator() -> AnyIterator<T> {
    var index = readIndex
    return AnyIterator {
        guard index < self.writeIndex else { return nil }
        defer {
            index += 1
        }
        return self.array[wrapped: index]
    }
  }
}

private extension Array {
  subscript (wrapped index: Int) -> Element {
    get {
      return self[index % count]
    }
    set {
      self[index % count] = newValue
    }
  }
}
