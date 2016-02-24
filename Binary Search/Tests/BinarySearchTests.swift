import Foundation
import XCTest

class BinarySearchTest: XCTestCase {
  var searchList = [Int]()

  override func setUp() {
    super.setUp()
    for number in 1...500 {
      searchList.append(number)
    }
  }

  func testEmptyArray() {
    let array = [Int]()
    let index = binarySearch(array, key: 123)
    XCTAssertNil(index)
  }

  func testBinarySearch() {
    for i in 1...100 {
      var array = [Int]()
      for number in 1...i {
        array.append(number)
      }
      let randomIndex = Int(arc4random_uniform(UInt32(i)))
      let testValue = array[randomIndex]

      let index = binarySearch(array, key: testValue)
      XCTAssertNotNil(index)
      XCTAssertEqual(index!, randomIndex)
      XCTAssertEqual(array[index!], testValue)
    }
  }

  func testLowerBound() {
    let index = binarySearch(searchList, key: 1)
    XCTAssertNotNil(index)
    XCTAssertEqual(index!, 0)
    XCTAssertEqual(searchList[index!], 1)
  }

  func testUpperBound() {
    let index = binarySearch(searchList, key: 500)
    XCTAssertNotNil(index)
    XCTAssertEqual(index!, 499)
    XCTAssertEqual(searchList[index!], 500)
  }

  func testOutOfLowerBound() {
    let index = binarySearch(searchList, key: 0)
    XCTAssertNil(index)
  }

  func testOutOfUpperBound() {
    let index = binarySearch(searchList, key: 501)
    XCTAssertNil(index)
  }
}
