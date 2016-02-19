import XCTest

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

  func testMinimumGivenAListOfOrderedElements() {
    let array = [ 3, 4, 6, 8, 9 ]

    let result = minimum(array)

    XCTAssertEqual(result, 3)
  }

  func testMinimumGivenAListOfReverseOrderedElements() {
    let array = [ 9, 8, 6, 4, 3 ]

    let result = minimum(array)

    XCTAssertEqual(result, 3)
  }

  func testMinimumGivenAnEmptyList() {
    let array = [Int]()

    let result = minimum(array)

    XCTAssertNil(result)
  }

  func testMinimumMatchesSwiftLibraryGivenARandomList() {
    for _ in 0...10 {
      for n in 1...100 {
        let array = createRandomList(n)

        let result = minimum(array)

        XCTAssertEqual(result, array.minElement())
      }
    }
  }
}
