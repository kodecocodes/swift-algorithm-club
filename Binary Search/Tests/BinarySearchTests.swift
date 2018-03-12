import XCTest

class BinarySearchTest: XCTestCase {
  let searchList = Array(stride(from: 1, through: 500, by: 1))

  func testEmptyCollection() {
    let collection = EmptyCollection<Int>()
    XCTAssertNil(collection.binarySearchIterative(key: 123))
    XCTAssertNil(collection.binarySearchRecursive(key: 123))
  }

  func testBinarySearch() {
    for i in 1...100 {
      let array = Array(stride(from: 1, through: i, by: 1))
      let randomIndex = Int(arc4random_uniform(UInt32(i)))
      let testValue = array[randomIndex]
      
      if let index = array.binarySearchIterative(key: testValue) {
        XCTAssertEqual(index, randomIndex)
        XCTAssertEqual(array[index], testValue)
      } else {
        XCTFail()
      }
      if let index = array.binarySearchRecursive(key: testValue) {
        XCTAssertEqual(index, randomIndex)
        XCTAssertEqual(array[index], testValue)
      } else {
        XCTFail()
      }
    }
  }

  func testLowerBound() {
    if let index = searchList.binarySearchIterative(key: 1) {
      XCTAssertEqual(index, searchList.startIndex)
      XCTAssertEqual(searchList[index], 1)
    } else {
      XCTFail()
    }
    if let index = searchList.binarySearchRecursive(key: 1) {
      XCTAssertEqual(index, searchList.startIndex)
      XCTAssertEqual(searchList[index], 1)
    } else {
      XCTFail()
    }
  }

  func testUpperBound() {
    if let index = searchList.binarySearchIterative(key: 500) {
      XCTAssertEqual(index, searchList.index(before: searchList.endIndex))
      XCTAssertEqual(searchList[index], 500)
    } else {
      XCTFail()
    }
    if let index = searchList.binarySearchRecursive(key: 500) {
      XCTAssertEqual(index, searchList.index(before: searchList.endIndex))
      XCTAssertEqual(searchList[index], 500)
    } else {
      XCTFail()
    }
  }

  func testOutOfLowerBound() {
    XCTAssertNil(searchList.binarySearchIterative(key: 0))
    XCTAssertNil(searchList.binarySearchRecursive(key: 0))
  }

  func testOutOfUpperBound() {
    XCTAssertNil(searchList.binarySearchIterative(key: 501))
    XCTAssertNil(searchList.binarySearchRecursive(key: 501))
  }
}
