import XCTest
@testable import SelectionSort

class SelectionSortTests: XCTestCase {
  func testSelectionSort() {
    checkSortAlgorithm(selectionSort)
  }
}
