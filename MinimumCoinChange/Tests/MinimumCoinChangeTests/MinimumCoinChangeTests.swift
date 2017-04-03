import XCTest
@testable import MinimumCoinChange

class MinimumCoinChangeTests: XCTestCase {
    func testExample() {
        var mcc = MinimumCoinChange(coinSet: [1, 2, 5, 10, 20, 25])

        for i in 0..<100 {
            let greedy = mcc.changeGreedy(i)
            let dynamic = mcc.changeDynamic(i)

            if greedy.count != dynamic.count {
                print("\(i): greedy = \(greedy) dynamic = \(dynamic)")
            }
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
