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
    array = [T?](count: count, repeatedValue: nil)
  }

  /* Returns false if out of space. */
  public mutating func write(element: T) -> Bool {
    if !isFull {
      array[writeIndex % array.count] = element
      writeIndex += 1
      return true
    } else {
      return false
    }
  }

  /* Returns nil if the buffer is empty. */
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
