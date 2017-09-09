import XCTest
@testable import MinimumCoinChange

class MinimumCoinChangeTests: XCTestCase {
  func testSwift4() {
    // last checked with Xcode 9.0b4
    #if swift(>=4.0)
      print("Hello, Swift 4!")
    #endif
  }
  
  func testExample() {
    let mcc = MinimumCoinChange(coinSet: [1, 2, 5, 10, 20, 25])
    print("Coin set: \(mcc.sortedCoinSet)")
    
    do {
      for i in 0..<100 {
        let greedy = try mcc.changeGreedy(i)
        let dynamic = try mcc.changeDynamic(i)
        
        XCTAssertEqual(greedy.reduce(0, +), dynamic.reduce(0, +), "Greedy and Dynamic return two different changes")
        
        if greedy.count != dynamic.count {
          print("\(i): greedy = \(greedy) dynamic = \(dynamic)")
        }
      }
    } catch {
      XCTFail("Test Failed: impossible to change with the given coin set")
    }
  }
  
  static var allTests = [
    ("testExample", testExample),
    ]
}
