import XCTest

class SplayTreeTests: XCTestCase {
   
    var tree1: SplayTree<Int>!
    var tree2: SplayTree<Int>!
    
    override func setUp() {
        super.setUp()
        tree1 = SplayTree<Int>(value: 1)
        
        tree2 = SplayTree<Int>(value: 1)
        tree2.insert(value: 10)
        tree2.insert(value: 20)
        tree2.insert(value: 3)
        tree2.insert(value: 6)
        tree2.insert(value: 100)
        tree2.insert(value: 44)
    }
    
    func testInsertion() {
        tree1.insert(value: 10)
        assert(tree1.value == 10)
        
        tree2.insert(value: 2)
        assert(tree2.root?.value == 2)
    }
    
    func testSearchNonExisting() {
        let t = tree2.search(value: 5)
        assert(t?.value == 10)
    }

    func testSearchExisting() {
        let t = tree2.search(value: 6)
        assert(t?.value == 6)
    }
    
    func testDeleteExistingOnlyLeftChild() {
        tree2.remove(value: 3)
        assert(tree2.value == 6)
    }

    func testDeleteExistingOnly2Children() {
        tree2.remove(value: 6)
        assert(tree2.value == 20)
    }
    
    func testDeleteRoot() {
        tree2.remove(value: 44)
        assert(tree2.value == 100)
    }
    
    func testMinimum() {
        let v = tree2.minimum()
        assert(v?.value == 1)
    }

    func testMaximum() {
        let v = tree2.maximum()
        assert(v?.value == 100)
    }
    
    func testInsertionRemovals() {
        let splayTree = SplayTree(value: 1)
        splayTree.insert(value: 2)
        splayTree.insert(value: 10)
        splayTree.insert(value: 6)
        
        splayTree.remove(value: 10)
        splayTree.remove(value: 6)
        
        assert(splayTree.value == 2)
    }
    
}
