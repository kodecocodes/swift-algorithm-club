import XCTest

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

  func testMaximumGivenAListOfOrderedElements() {
    let array = [ 3, 4, 6, 8, 9 ]

    let result = maximum(array)

    XCTAssertEqual(result, 9)
  }

  func testMaximumGivenAListOfReverseOrderedElements() {
    let array = [ 9, 8, 6, 4, 3 ]

    let result = maximum(array)

    XCTAssertEqual(result, 9)
  }

  func testMaximumGivenAnEmptyList() {
    let array = [Int]()

    let result = maximum(array)

    XCTAssertNil(result)
  }

  func testMaximumMatchesSwiftLibraryGivenARandomList() {
    for _ in 0...10 {
      for n in 1...100 {
        let array = createRandomList(n)

        let result = maximum(array)

        XCTAssertEqual(result, array.maxElement())
      }
    }
  }
}
