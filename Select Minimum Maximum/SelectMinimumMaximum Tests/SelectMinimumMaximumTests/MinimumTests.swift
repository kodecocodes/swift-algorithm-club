import XCTest
@testable import SelectMinimumMaximum

class MinimumTests: XCTestCase {

  func testMinimumGivenAListContainingOneElement() {
    let array = [ 54 ]

    let result = minimum(array)

    XCTAssertEqual(result, 54)
  }

  func testMinimumGivenAListContainingMultipleElementsWithTheSameValue() {
    let array = [ 2, 16, 2, 16 ]

    let result = minimum(array)

    XCTAssertEqual(result, 2)
  }

  func testMimimumGivenAListOfOrderedElements() {
    let array = [ 3, 4, 6, 8, 9 ]

    let result = minimum(array)

    XCTAssertEqual(result, 3)
  }

  func testMimimumGivenAListOfReverseOrderedElements() {
    let array = [ 9, 8, 6, 4, 3 ]

    let result = minimum(array)

    XCTAssertEqual(result, 3)
  }
}
