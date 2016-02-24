import XCTest

class MinimumMaximumPairsTests: XCTestCase {

  func testMinimumAndMaximumGivenAListContainingOneElement() {
    let array = [ 8 ]

    let result = minimumMaximum(array)!

    XCTAssertEqual(result.minimum, 8)
    XCTAssertEqual(result.maximum, 8)
  }

  func testMinimumAndMaximumGivenAListContainingMultipleElementsWithTheSameValue() {
    let array = [ 8, 16, 8, 8 ]

    let result = minimumMaximum(array)!

    XCTAssertEqual(result.minimum, 8)
    XCTAssertEqual(result.maximum, 16)
  }

  func testMimimumAndMaximumGivenAListContainingAnEvenNumberOfElements() {
    let array = [ 3, 4, 6, 8 ]

    let result = minimumMaximum(array)!

    XCTAssertEqual(result.minimum, 3)
    XCTAssertEqual(result.maximum, 8)
  }

  func testMimimumAndMaximumGivenAListContainingAnOddNumberOfElements() {
    let array = [ 8, 3, 9, 4, 6 ]

    let result = minimumMaximum(array)!

    XCTAssertEqual(result.minimum, 3)
    XCTAssertEqual(result.maximum, 9)
  }

  func testMimimumAndMaximumGivenAListOfOrderedElements() {
    let array = [ 3, 4, 6, 8, 9 ]

    let result = minimumMaximum(array)!

    XCTAssertEqual(result.minimum, 3)
    XCTAssertEqual(result.maximum, 9)
  }

  func testMimimumAndMaximumGivenAListOfReverseOrderedElements() {
    let array = [ 9, 8, 6, 4, 3 ]

    let result = minimumMaximum(array)!

    XCTAssertEqual(result.minimum, 3)
    XCTAssertEqual(result.maximum, 9)
  }

  func testMinimumAndMaximumGivenAnEmptyList() {
    let array = [Int]()

    let result = minimumMaximum(array)

    XCTAssertNil(result)
  }

  func testMinimumAndMaximumMatchSwiftLibraryGivenARandomList() {
    for _ in 0...10 {
      for n in 1...100 {
        let array = createRandomList(n)

        let result = minimumMaximum(array)!

        XCTAssertEqual(result.minimum, array.minElement())
        XCTAssertEqual(result.maximum, array.maxElement())
      }
    }
  }
}
