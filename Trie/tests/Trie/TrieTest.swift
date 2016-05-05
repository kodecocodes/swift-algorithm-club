import XCTest
@testable import Trie

class TrieTests: XCTestCase {
  var trie : Trie!

  override func setUp() {
    super.setUp()
    trie = Trie()
  }

  func testInsert() {

    var T: Trie = Trie()
    var result = T.insert("Test").inserted
    XCTAssertEqual(result, true)
  }
}

extension CalculatorTests {
    static var allTests : [(String, CalculatorTests -> () throws -> Void)] {
        return [
            ("Testing Insert...", testInsert)
        ]
    }
}
