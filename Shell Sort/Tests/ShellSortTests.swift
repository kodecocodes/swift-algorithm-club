import XCTest

class ShellSortTests: XCTestCase {
  func testSwift4() {
    // last checked with Xcode 9.0b4
    #if swift(>=4.0)
      print("Hello, Swift 4!")
    #endif
  }
  
  func testShellSort() {
    checkSortAlgorithm { (a: [Int]) -> [Int] in
      var b = a
      shellSort(&b)
      return b
    }
  }
}
