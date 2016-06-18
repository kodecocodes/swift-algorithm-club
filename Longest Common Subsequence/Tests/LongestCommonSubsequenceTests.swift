import Foundation
import XCTest

class LongestCommonSubsequenceTests: XCTestCase {

    func testLCSwithSelfIsSelf() {
        let a = "ABCDE"

        XCTAssertEqual(a, a.longestCommonSubsequence(a))
    }

    func testLCSWithEmptyStringIsEmptyString() {
        let a = "ABCDE"

        XCTAssertEqual("", a.longestCommonSubsequence(""))
    }

    func testLCSIsEmptyWhenNoCharMatches() {
        let a = "ABCDE"
        let b = "WXYZ"

        XCTAssertEqual("", a.longestCommonSubsequence(b))
    }

    func testLCSIsNotCommutative() {
        let a = "ABCDEF"
        let b = "XAWDMVBEKD"

        XCTAssertEqual("ADE", a.longestCommonSubsequence(b))
        XCTAssertEqual("ABD", b.longestCommonSubsequence(a))
    }
}
