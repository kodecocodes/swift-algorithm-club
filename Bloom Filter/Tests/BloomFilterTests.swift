import XCTest

/* Two hash functions, adapted from
 http://www.cse.yorku.ca/~oz/hash.html */

func djb2(_ x: String) -> Int {
  var hash = 5381

  for char in x {
    hash = ((hash << 5) &+ hash) &+ char.hashValue
  }

  return Int(hash)
}

func sdbm(_ x: String) -> Int {
  var hash = 0

  for char in x {
    hash = char.hashValue &+ (hash << 6) &+ (hash << 16) &- hash
  }

  return Int(hash)
}

class BloomFilterTests: XCTestCase {
    func testSwift4(){
        // last checked with Xcode 9.0b4
        #if swift(>=4.0)
            print("Hello, Swift 4!")
        #endif
    }
  func testSingleHashFunction() {
    let bloom = BloomFilter<String>(hashFunctions: [djb2])

    bloom.insert("Hello world!")

    let result_good = bloom.query("Hello world!")
    let result_bad = bloom.query("Hello world")

    XCTAssertTrue(result_good)
    XCTAssertFalse(result_bad)
  }

  func testEmptyFilter() {
    let bloom = BloomFilter<String>(hashFunctions: [djb2])

    let empty = bloom.isEmpty()

    XCTAssertTrue(empty)
  }

  func testMultipleHashFunctions() {
    let bloom = BloomFilter<String>(hashFunctions: [djb2, sdbm])

    bloom.insert("Hello world!")

    let result_good = bloom.query("Hello world!")
    let result_bad = bloom.query("Hello world")

    XCTAssertTrue(result_good)
    XCTAssertFalse(result_bad)
  }

  func testFalsePositive() {
    let bloom = BloomFilter<String>(size: 5, hashFunctions: [djb2, sdbm])

    bloom.insert(["hello", "elloh", "llohe", "lohel", "ohell"])

    print("Inserted")

    let query = bloom.query("This wasn't inserted!")

    // This is true even though we did not insert the value in the Bloom filter;
    // the Bloom filter is capable of producing false positives but NOT
    // false negatives.

    XCTAssertTrue(query)
  }
}
