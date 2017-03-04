import XCTest

class SplayTreeTests: XCTestCase {
   
    var tree: SplayTree<Int>!
    var tree1: SplayTree<Int>!
    
    override func setUp() {
        super.setUp()
        tree = SplayTree<Int>(value: 1)
        tree1 = tree.insert(value: 10)?.insert(value: 20)?.insert(value: 3)?.insert(value: 6)?.insert(value: 100)?.insert(value: 44)
    }
    
    func testInsertion() {
        let tree1 = tree.insert(value: 10)
        assert(tree1?.root?.value == 10)
        
        let tree2 = tree1!.insert(value: 2)
        assert(tree2?.root?.value == 2)
    }
    
    
    func testSearchNonExisting() {
        print(tree1)
        let tree2 = tree1.search(value: 5)
        assert(tree2?.root?.value == 10)
        
    }
    
    
}
