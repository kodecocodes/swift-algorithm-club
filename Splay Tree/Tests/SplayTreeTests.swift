import XCTest

class SplayTreeTests: XCTestCase {
  var tree: SplayTree<Int>!
  
  override func setUp() {
    super.setUp()
    tree = SplayTree<Int>(value: 1)
  }
  
  func testElements() {
    print(tree)
    let tree1 = tree.insert(value: 10)
    print(tree1!)
    let tree2 = tree1!.insert(value: 2)
    print(tree2!)
  }

}
