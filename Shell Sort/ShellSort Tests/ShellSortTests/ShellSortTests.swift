import XCTest
@testable import ShellSort

class ShellSortTests: XCTestCase {
  func testShellSort() {
    checkSortAlgorithm { (a: [Int]) -> [Int] in
      var b = a
      shellSort(&b)
      return b
    }
  }
}
