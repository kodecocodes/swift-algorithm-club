//: Playground - noun: a place where people can play

public class BloomFilter<T> {
  fileprivate var array: [Bool]
  private var hashFunctions: [(T) -> Int]

  public init(size: Int = 1024, hashFunctions: [(T) -> Int]) {
    self.array = [Bool](repeating: false, count: size)
    self.hashFunctions = hashFunctions
  }

  private func computeHashes(_ value: T) -> [Int] {
    return hashFunctions.map() { hashFunc in abs(hashFunc(value) % array.count) }
  }

  public func insert(_ element: T) {
    for hashValue in computeHashes(element) {
      array[hashValue] = true
    }
  }

  public func insert(_ values: [T]) {
    for value in values {
      insert(value)
    }
  }

  public func query(_ value: T) -> Bool {
    let hashValues = computeHashes(value)

    // Map hashes to indices in the Bloom Filter
    let results = hashValues.map() { hashValue in array[hashValue] }

    // All values must be 'true' for the query to return true

    // This does NOT imply that the value is in the Bloom filter,
    // only that it may be. If the query returns false, however,
    // you can be certain that the value was not added.

    let exists = results.reduce(true, { $0 && $1 })
    return exists
  }

  public func isEmpty() -> Bool {
    // As soon as the reduction hits a 'true' value, the && condition will fail.
    return array.reduce(true) { prev, next in prev && !next }
  }
}



/* Two hash functions, adapted from http://www.cse.yorku.ca/~oz/hash.html */

func djb2(x: String) -> Int {
  var hash = 5381
  for char in x.characters {
    hash = ((hash << 5) &+ hash) &+ char.hashValue
  }
  return Int(hash)
}

func sdbm(x: String) -> Int {
  var hash = 0
  for char in x.characters {
    hash = char.hashValue &+ (hash << 6) &+ (hash << 16) &- hash
  }
  return Int(hash)
}



/* A simple test */

let bloom = BloomFilter<String>(size: 17, hashFunctions: [djb2, sdbm])

bloom.insert("Hello world!")
print(bloom.array)

bloom.query("Hello world!")    // true
bloom.query("Hello WORLD")     // false

bloom.insert("Bloom Filterz")
print(bloom.array)

bloom.query("Bloom Filterz")   // true
bloom.query("Hello WORLD")     // true
