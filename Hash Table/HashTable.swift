/*
  Hash table

  Allows you to store and retrieve objects by a "key".

  The key must be Hashable, which means it can be converted into a fairly
  unique Int that represents the key as a number. The more unique the hash
  value, the better.

  The hashed version of the key is used to calculate an index into the array
  of "buckets". The capacity of the hash table is how many of these buckets
  it has. Ideally, the number of buckets is the same as the maximum number of
  items you'll be storing in the HashTable, and each hash value maps to its
  own bucket. In practice that is hard to achieve.

  When there is more than one hash value that maps to the same bucket index
  -- a "collision" -- they are chained together, using an array. (Note that
  more clever ways exist for dealing with the chaining issue.)

  While there are free buckets, inserting/retrieving/removing are O(1).
  But when the buckets are full and the chains are long, using the hash table
  becomes an O(n) operation.

  Counting the size of the hash table is O(1) because we're caching the count.

  The order of the elements in the hash table is undefined.

  This implementation has a fixed capacity; it does not resize when the table
  gets too full. (To do that, you'd allocate a larger array of buckets and then
  insert each of the elements into that new array; this is necessary because
  the hash values will now map to different bucket indexes.)
*/
public struct HashTable<Key: Hashable, Value> {
  private typealias Element = (key: Key, value: Value)
  private typealias Bucket = [Element]

  private var buckets: [Bucket]
  private(set) var count = 0

  public init(capacity: Int) {
    assert(capacity > 0)
    buckets = .init(count: capacity, repeatedValue: [])
  }

  public var isEmpty: Bool {
    return count == 0
  }

  private func indexForKey(key: Key) -> Int {
    return abs(key.hashValue) % buckets.count
  }
}

// MARK: - Basic operations

extension HashTable {
  public subscript(key: Key) -> Value? {
    get {
      return valueForKey(key)
    }
    set {
      if let value = newValue {
        updateValue(value, forKey: key)
      } else {
        removeValueForKey(key)
      }
    }
  }

  public func valueForKey(key: Key) -> Value? {
    let index = indexForKey(key)

    for element in buckets[index] {
      if element.key == key {
        return element.value
      }
    }
    return nil  // key not in hash table
  }

  public mutating func updateValue(value: Value, forKey key: Key) -> Value? {
    let index = indexForKey(key)

    // Do we already have this key in the bucket?
    for (i, element) in buckets[index].enumerate() {
      if element.key == key {
        let oldValue = element.value
        buckets[index][i].value = value
        return oldValue
      }
    }

    // This key isn't in the bucket yet; add it to the chain.
    buckets[index].append((key: key, value: value))
    count += 1
    return nil
  }

  public mutating func removeValueForKey(key: Key) -> Value? {
    let index = indexForKey(key)

    // Find the element in the bucket's chain and remove it.
    for (i, element) in buckets[index].enumerate() {
      if element.key == key {
        buckets[index].removeAtIndex(i)
        count -= 1
        return element.value
      }
    }
    return nil  // key not in hash table
  }

  public mutating func removeAll() {
    buckets = .init(count: buckets.count, repeatedValue: [])
    count = 0
  }
}

// MARK: - Helper methods for inspecting the hash table

extension HashTable {
  public var keys: [Key] {
    var a = [Key]()
    for bucket in buckets {
      for element in bucket {
        a.append(element.key)
      }
    }
    return a
  }

  public var values: [Value] {
    var a = [Value]()
    for bucket in buckets {
      for element in bucket {
        a.append(element.value)
      }
    }
    return a
  }
}

// MARK: - For debugging

extension HashTable: CustomStringConvertible {
  public var description: String {
    return buckets.flatMap { b in b.map { e in "\(e.key) = \(e.value)" } }.joinWithSeparator(", ")
  }
}

extension HashTable: CustomDebugStringConvertible {
  public var debugDescription: String {
    var s = ""
    for (i, bucket) in buckets.enumerate() {
      s += "bucket \(i): " + bucket.map { e in "\(e.key) = \(e.value)" }.joinWithSeparator(", ") + "\n"
    }
    return s
  }
}
