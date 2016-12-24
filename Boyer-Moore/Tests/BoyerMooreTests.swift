import Foundation
import XCTest

class BoyerMooreTest: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func assert(pattern: String, doesNotExistsIn string: String) {
        let index = string.indexOf(pattern: pattern)
        XCTAssertNil(index)
    }

    func assert(pattern: String, existsIn string: String) {
        let index = string.indexOf(pattern: pattern)
        XCTAssertNotNil(index)

        let startIndex = index!
        let endIndex = string.index(index!, offsetBy: pattern.characters.count)
        let match = string.substring(with: startIndex..<endIndex)
        XCTAssertEqual(match, pattern)
    }
    
    func testSearchTheSameString() {
        let string = "ABCDEF"
        let pattern = "ABCDEF"
        assert(pattern: pattern, existsIn: string)
    }
    
    func testSearchAPreffix() {
        let string = "ABCDEFGHIJK"
        let pattern = "ABCDEF"
        assert(pattern: pattern, existsIn: string)
    }
    
    func testSearchASuffix() {
        let string = "ABCDEFGHIJK"
        let pattern = "HIJK"
        assert(pattern: pattern, existsIn: string)
    }
    
    func testSearchAStringFromTheMiddle() {
        let string = "ABCDEFGHIJK"
        let pattern = "EFG"
        assert(pattern: pattern, existsIn: string)
    }
    
    
    func testSearchInvalidPattern() {
        let string = "ABCDEFGHIJK"
        let pattern = "AEF"
        assert(pattern: pattern, doesNotExistsIn: string)
    }
    
    func testSearchPatternWithDuplicatedCharacter() {
        let string = "Goal: Write a string search algorithm in pure Swift without importing Foundation or using NSString's rangeOfString() method."
        let pattern = "NSS"
        assert(pattern: pattern, existsIn: string)
    }

    func testSearchInvalidPatternWithDuplicatedCharacter() {
        let string = "Goal: Write a string search algorithm in pure Swift without importing Foundation or using NSString's rangeOfString() method."
        let pattern = "nss"
        assert(pattern: pattern, doesNotExistsIn: string)
    }
    
}
