import XCTest
import Foundation

class Tests: XCTestCase {
  
  func testSplayTree() {
    
    //Validated against - Splay Tree Visualization
    //https://www.cs.usfca.edu/~galles/visualization/SplayTree.html
    
    let values = [50, 20, 30, 60, 10, 80, 40]
    
    let tree = SplayTree<Int>(values)
    
    let printTraversals: () -> () = {
      
      print("\n")
      print(tree.traversePreorder())
      print(tree.traverseInorder())
      print(tree.traversePostorder())
      print("\n")
    }
    
    printTraversals()
    XCTAssertEqual([40, 10, 30, 20, 80, 50, 60], tree.traversePreorder())
    XCTAssertEqual([10, 20, 30, 40, 50, 60, 80], tree.traverseInorder())
    XCTAssertEqual([20, 30, 10, 60, 50, 80, 40], tree.traversePostorder())
    
    XCTAssertFalse(tree.find(70))
    //printTraversals()
    XCTAssertEqual([40, 10, 30, 20, 80, 50, 60], tree.traversePreorder())
    XCTAssertEqual([10, 20, 30, 40, 50, 60, 80], tree.traverseInorder())
    XCTAssertEqual([20, 30, 10, 60, 50, 80, 40], tree.traversePostorder())
    
    XCTAssertTrue(tree.find(60))
    //printTraversals()
    XCTAssertEqual([60, 40, 10, 30, 20, 50, 80], tree.traversePreorder())
    XCTAssertEqual([10, 20, 30, 40, 50, 60, 80], tree.traverseInorder())
    XCTAssertEqual([20, 30, 10, 50, 40, 80, 60], tree.traversePostorder())
    
    XCTAssertTrue(tree.find(30))
    //printTraversals()
    XCTAssertEqual([30, 10, 20, 60, 40, 50, 80], tree.traversePreorder())
    XCTAssertEqual([10, 20, 30, 40, 50, 60, 80], tree.traverseInorder())
    XCTAssertEqual([20, 10, 50, 40, 80, 60, 30], tree.traversePostorder())
    
    XCTAssertTrue(tree.remove(40))
    //printTraversals()
    XCTAssertEqual([30, 10, 20, 60, 50, 80], tree.traversePreorder())
    XCTAssertEqual([10, 20, 30, 50, 60, 80], tree.traverseInorder())
    XCTAssertEqual([20, 10, 50, 80, 60, 30], tree.traversePostorder())
    
    XCTAssertTrue(tree.remove(10))
    XCTAssertTrue(tree.remove(20))
    XCTAssertTrue(tree.remove(30))
    XCTAssertTrue(tree.remove(50))
    XCTAssertTrue(tree.remove(60))
    XCTAssertTrue(tree.remove(80))
    //printTraversals()
    XCTAssertEqual([], tree.traversePreorder())
    XCTAssertEqual([], tree.traverseInorder())
    XCTAssertEqual([], tree.traversePostorder())
  }
}
