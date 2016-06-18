//: Playground - noun: a place where people can play

public struct RingBuffer<T> {
  private var array: [T?]
  private var readIndex = 0
  private var writeIndex = 0

  public init(count: Int) {
    array = [T?](count: count, repeatedValue: nil)
  }

  public mutating func write(element: T) -> Bool {
    if !isFull {
      array[writeIndex % array.count] = element
      writeIndex += 1
      return true
    } else {
      return false
    }
  }

  public mutating func read() -> T? {
    if !isEmpty {
      let element = array[readIndex % array.count]
      readIndex += 1
      return element
    } else {
      return nil
    }
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
