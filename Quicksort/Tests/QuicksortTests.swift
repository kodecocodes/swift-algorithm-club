import XCTest

class QuicksortTests: XCTestCase {
  func testQuicksort() {
    checkSortAlgorithm(quicksort)
  }

  fileprivate typealias QuicksortFunction = (inout [Int], _ low: Int, _ high: Int) -> Void

  fileprivate func checkQuicksort(_ function: QuicksortFunction) {
    checkSortAlgorithm { (a: [Int]) -> [Int] in
      var b = a
      function(&b, 0, b.count - 1)
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
