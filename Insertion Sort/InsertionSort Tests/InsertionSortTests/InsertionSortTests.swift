import XCTest
@testable import InsertionSort

class InsertionSortTests: XCTestCase {
  func testInsertionSort() {
    checkSortAlgorithm(insertionSort)
  }
}
