//: Playground - noun: a place where people can play

// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

public struct RingBuffer<T> {
  fileprivate var array: [T?]
  fileprivate var readIndex = 0
  fileprivate var writeIndex = 0

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

  fileprivate var availableSpaceForReading: Int {
    return writeIndex - readIndex
  }

  public var isEmpty: Bool {
    return availableSpaceForReading == 0
  }

  fileprivate var availableSpaceForWriting: Int {
    return array.count - availableSpaceForReading
  }

  public var isFull: Bool {
    return availableSpaceForWriting == 0
  }
}

extension RingBuffer: Sequence {
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

var buffer = RingBuffer<Int>(count: 5)
buffer.array          // [nil, nil, nil, nil, nil]
buffer.readIndex      // 0
buffer.writeIndex     // 0
buffer.availableSpaceForReading // 0
buffer.availableSpaceForWriting // 5

buffer.write(123)
buffer.write(456)
buffer.write(789)
buffer.write(666)

buffer.array          // [{Some 123}, {Some 456}, {Some 789}, {Some 666}, nil]
buffer.readIndex      // 0
buffer.writeIndex     // 4
buffer.availableSpaceForReading // 4
buffer.availableSpaceForWriting // 1

buffer.read()         // 123
buffer.readIndex      // 1
buffer.availableSpaceForReading // 3
buffer.availableSpaceForWriting // 2

buffer.read()         // 456
buffer.read()         // 789
buffer.readIndex      // 3
buffer.availableSpaceForReading // 1
buffer.availableSpaceForWriting // 4

buffer.write(333)
buffer.write(555)
buffer.array          // [{Some 555}, {Some 456}, {Some 789}, {Some 666}, {Some 333}]
buffer.availableSpaceForReading // 3
buffer.availableSpaceForWriting // 2
buffer.writeIndex     // 6

buffer.read()         // 666
buffer.read()         // 333
buffer.read()         // 555
buffer.read()         // nil
buffer.availableSpaceForReading // 0
buffer.availableSpaceForWriting // 5
buffer.readIndex      // 6
