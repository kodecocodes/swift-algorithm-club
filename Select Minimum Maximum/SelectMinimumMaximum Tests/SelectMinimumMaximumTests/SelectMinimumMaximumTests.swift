import XCTest
@testable import SelectMinimumMaximum

class SelectMinimumMaximumTests: XCTestCase {

  func testMinimumAndMaximumGivenAListContainingOneElement() {
    let array = [ 8 ]

    let result = minimumMaximum(array)

    XCTAssertEqual(result.minimum, 8)
    XCTAssertEqual(result.maximum, 8)
  }

  func testMinimumAndMaximumGivenAListContainingMultipleElementsWithTheSameValue() {
    let array = [ 8, 16, 8, 8 ]

    let result = minimumMaximum(array)

    XCTAssertEqual(result.minimum, 8)
    XCTAssertEqual(result.maximum, 16)
  }

  func testMimimumAndMaximumGivenAListContainingAnEvenNumberOfElements() {
    let array = [ 3, 4, 6, 8 ]

    let result = minimumMaximum(array)

    XCTAssertEqual(result.minimum, 3)
    XCTAssertEqual(result.maximum, 8)
  }

  func testMimimumAndMaximumGivenAListContainingAnOddNumberOfElements() {
    let array = [ 8, 3, 9, 4, 6 ]

    let result = minimumMaximum(array)

    XCTAssertEqual(result.minimum, 3)
    XCTAssertEqual(result.maximum, 9)
  }

  func testMimimumAndMaximumGivenAListOfOrderedElements() {
    let array = [ 3, 4, 6, 8, 9 ]

    let result = minimumMaximum(array)

    XCTAssertEqual(result.minimum, 3)
    XCTAssertEqual(result.maximum, 9)
  }

  func testMimimumAndMaximumGivenAListOfReverseOrderedElements() {
    let array = [ 9, 8, 6, 4, 3 ]

    let result = minimumMaximum(array)

    XCTAssertEqual(result.minimum, 3)
    XCTAssertEqual(result.maximum, 9)
  }
}
