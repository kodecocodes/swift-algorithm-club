import XCTest

class QuicksortTests: XCTestCase {
  func testQuicksort() {
    checkSortAlgorithm(quicksort)
  }

  private typealias QuicksortFunction = (inout [Int], low: Int, high: Int) -> Void

  private func checkQuicksort(function: QuicksortFunction) {
    checkSortAlgorithm { (a: [Int]) -> [Int] in
      var b = a
      function(&b, low: 0, high: b.count - 1)
      return b
    }
  }

  func testQuicksortLomuto() {
    checkQuicksort(quicksortLomuto)
  }

  func testQuicksortHoare() {
    checkQuicksort(quicksortHoare)
  }

  func testQuicksortRandom() {
    checkQuicksort(quicksortRandom)
  }

  func testQuicksortDutchFlag() {
    checkQuicksort(quicksortDutchFlag)
  }
}
