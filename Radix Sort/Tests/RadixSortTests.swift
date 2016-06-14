import XCTest

class RadixSortTests: XCTestCase {

  func testSortingSimpleList() {
    var list = [6, 9, 3, 8]

    radixSort(&list)

    XCTAssertEqual(list, [3, 6, 8, 9])
  }
}
