/*
  A fixed-size sequence of n bits. Bits have indices 0 to n-1.
*/
public struct BitSet {
  /* How many bits this object can hold. */
  private(set) public var size: Int

  /*
    We store the bits in a list of unsigned 64-bit integers.
    The first entry is the LSB (least significant bit).
  */
  private let N = 64
  public typealias Word = UInt64
  private(set) public var array: [Word]

  /* Creates a bit set that can hold `size` bits. All bits are initially 0. */
  public init(size: Int) {
    precondition(size > 0)
    self.size = size

    // Round up the count to the next multiple of 64.
    let n = (size + (N-1)) / N
    array = .init(count: n, repeatedValue: 0)
  }

  /* Converts a bit index into an array index and a mask inside the word. */
  private func indexOf(i: Int) -> (Int, Word) {
    precondition(i >= 0)
    precondition(i < size)
    let o = i / N
    let m = Word(i - o*N)
    return (o, 1 << m)
  }

  /*
    If the size is not a multiple of N, then we have to clear out the bits
    that we're not using, or the bitwise operations between two differently
    sized BitSets will go wrong.
  */
  private mutating func clearUnusedBits() {
    let diff = array.count*N - size
    if diff > 0 {
      // First, set the highest bit that's still valid.
      var mask = 1 << Word(63 - diff)
      // Subtract 1 to turn it into a mask, and add the high bit back in.
      mask = mask | (mask - 1)
      // Finally, turn all the higher bits off.
      array[array.count - 1] &= mask
    }
  }

  /* So you can write bitset[99] = ... */
  public subscript(i: Int) -> Bool {
    get { return isSet(i) }
    set { if newValue { set(i) } else { clear(i) } }
  }

  /* Sets the bit at the specific index to 1. */
  public mutating func set(i: Int) {
    let (j, m) = indexOf(i)
    array[j] |= m
  }

  /* Sets all the bits to 1. */
  public mutating func setAll() {
    let mask = ~Word()
    for i in 0..<array.count {
      array[i] = mask
    }
    clearUnusedBits()
  }

  /* Sets the bit at the specific index to 0. */
  public mutating func clear(i: Int) {
    let (j, m) = indexOf(i)
    array[j] &= ~m
  }

  /* Sets all the bits to 0. */
  public mutating func clearAll() {
    for i in 0..<array.count {
      array[i] = 0
    }
  }

  /* Changes 0 into 1 and 1 into 0. Returns the new value of the bit. */
  public mutating func flip(i: Int) -> Bool {
    let (j, m) = indexOf(i)
    array[j] ^= m
    return (array[j] & m) != 0
  }

  /* Determines whether the bit at the specific index is 1 (true) or 0 (false). */
  public func isSet(i: Int) -> Bool {
    let (j, m) = indexOf(i)
    return (array[j] & m) != 0
  }

  /*
    Returns the number of bits that are 1. Time complexity is O(s) where s is
    the number of 1-bits.
  */
  public var cardinality: Int {
    var count = 0
    for var x in array {
      while x != 0 {
        let y = x & ~(x - 1)  // find lowest 1-bit
        x = x ^ y             // and erase it
        ++count
      }
    }
    return count
  }

  /* Checks if all the bits are set. */
  public func all1() -> Bool {
    let mask = ~Word()
    for x in array {
      if x != mask { return false }
    }
    return true
  }

  /* Checks if any of the bits are set. */
  public func any1() -> Bool {
    for x in array {
      if x != 0 { return true }
    }
    return false
  }

  /* Checks if none of the bits are set. */
  public func all0() -> Bool {
    for x in array {
      if x != 0 { return false }
    }
    return true
  }
}

// MARK: - Equality

extension BitSet: Equatable {
}

public func ==(lhs: BitSet, rhs: BitSet) -> Bool {
  return lhs.array == rhs.array
}

// MARK: - Hashing

extension BitSet: Hashable {
  /* Based on the hashing code from Java's BitSet. */
  public var hashValue: Int {
    var h = Word(1234)
    for i in array.count.stride(to: 0, by: -1) {
      h ^= array[i - 1] &* Word(i)
    }
    return Int((h >> 32) ^ h)
  }
}

// MARK: - Bitwise operations

extension BitSet: BitwiseOperationsType {
  public static var allZeros: BitSet {
    return BitSet(size: 64)
  }
}

/*
  Note: If lhs and rhs have different sizes, then we consider the higher-order
  bits to be 0.
*/
public func &(var lhs: BitSet, rhs: BitSet) -> BitSet {
  let n = min(lhs.array.count, rhs.array.count)
  for i in n..<lhs.array.count {
    lhs.array[i] = 0
  }
  for i in 0..<n {
    lhs.array[i] &= rhs.array[i]
  }
  return lhs
}

/*
  Note: If lhs is smaller than rhs, then we drop the higher-order bits because
  BitSet cannot resize. It's OK if rhs has fewer bits than lhs.
*/
public func |(var lhs: BitSet, rhs: BitSet) -> BitSet {
  let n = min(lhs.array.count, rhs.array.count)
  for i in 0..<n {
    lhs.array[i] |= rhs.array[i]
  }
  lhs.clearUnusedBits()
  return lhs
}

/*
  Note: If lhs is smaller than rhs, then we drop the higher-order bits because
  BitSet cannot resize. It's OK if rhs has fewer bits than lhs.
*/
public func ^(var lhs: BitSet, rhs: BitSet) -> BitSet {
  let n = min(lhs.array.count, rhs.array.count)
  for i in 0..<n {
    lhs.array[i] ^= rhs.array[i]
  }
  lhs.clearUnusedBits()
  return lhs
}

prefix public func ~(var rhs: BitSet) -> BitSet {
  for i in 0..<rhs.array.count {
    rhs.array[i] = ~rhs.array[i]
  }
  rhs.clearUnusedBits()
  return rhs
}

// MARK: - Debugging

extension UInt64 {
  /* Writes the bits in little-endian order, LSB first. */
  public func bitsToString() -> String {
    var s = ""
    var n = self
    for _ in 1...64 {
      s += ((n & 1 == 1) ? "1" : "0")
      n >>= 1
    }
    return s
  }
}

extension BitSet: CustomStringConvertible {
  public var description: String {
    var s = ""
    for x in array {
      s += x.bitsToString() + " "
    }
    return s
  }
}
