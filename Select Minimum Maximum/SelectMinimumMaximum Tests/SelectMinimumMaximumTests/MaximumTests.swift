import XCTest
@testable import SelectMinimumMaximum

class MaximumTests: XCTestCase {

  func testMaximumGivenAListContainingOneElement() {
    let array = [ 99 ]

    let result = maximum(array)

    XCTAssertEqual(result, 99)
  }

  func testMaximumGivenAListContainingMultipleElementsWithTheSameValue() {
    let array = [ 3, 16, 3, 16 ]

    let result = maximum(array)

    XCTAssertEqual(result, 16)
  }

  func testMimimumGivenAListOfOrderedElements() {
    let array = [ 3, 4, 6, 8, 9 ]

    let result = maximum(array)

    XCTAssertEqual(result, 9)
  }

  func testMimimumGivenAListOfReverseOrderedElements() {
    let array = [ 9, 8, 6, 4, 3 ]

    let result = maximum(array)
    
    XCTAssertEqual(result, 9)
  }
}
