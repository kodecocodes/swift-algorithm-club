//
//  AVLTreeTestsTests.swift
//  AVLTreeTestsTests
//
//  Created by Barbara Rodeker on 2/19/16.
//  Copyright © 2016 Swift Algorithm Club. All rights reserved.
//

import XCTest
@testable import testAVL

class AVLTreeTests: XCTestCase {
  
  var tree : AVLTree<Int, String>?
  
  override func setUp() {
    super.setUp()
    
    tree = AVLTree()
    tree?.insert(1, "A")
    tree?.insert(2, "B")
    tree?.insert(3, "C")
    tree?.insert(4, "D")
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testEmptyInitialization() {
    let tree = AVLTree<Int,String>()
    
    XCTAssertEqual(tree.size, 0)
    XCTAssertNil(tree.root)
  }
  
  func testNotEmptyInitialization() {
    XCTAssertNotNil(self.tree?.root)
    XCTAssertNotEqual(self.tree!.size, 0)
  }
  
  func testInsertDuplicated() {
    self.tree?.insert(1, "A")
    XCTAssertEqual(self.tree?.size, 5, "Duplicated elements should be allowed")
  }
  
  func testSingleInsertionPerformance() {
    self.measureBlock {
      self.tree?.insert(5, "E")
    }
  }
  
  func testMultipleInsertionsPerformance() {
    self.measureBlock {
      self.tree?.autopopulateWithNodes(50)
    }
  }
  
  func testSearchExistentOnSmallTreePerformance() {
    self.measureBlock {
      self.tree?.search(2)
    }
  }
  
  func testSearchExistentElementOnLargeTreePerformance() {
    self.measureBlock {
      self.tree?.autopopulateWithNodes(500)
      self.tree?.search(400)
    }
  }
    
    func testMinimumOnPopulatedTree() {
        self.tree?.autopopulateWithNodes(500)
        let min = self.tree?.root?.minimum()
        XCTAssertNotNil(min, "Minimum function not working")
    }
    
    func testMinimumOnSingleTreeNode() {
        let treeNode = TreeNode(key: 1, payload: "A")
        let min = treeNode.minimum()
        
        XCTAssertNotNil(min, "Minimum on single node should be returned")
        XCTAssertEqual(min?.payload,treeNode.payload)
    }
    
    func testSuccessorOfRoot() {
        self.tree?.autopopulateWithNodes(10)
        let successor = self.tree?.root?.successor()
        XCTAssertNotNil(successor, "Succesor of root, non-empty tree, not found")
    }
    
    func testSuccessorOfMinimum() {
        self.tree?.autopopulateWithNodes(10)
        
        let minimum = self.tree?.root?.minimum()
        XCTAssertNotNil(minimum, "Minimum should exist here")
        
        let successor = minimum!.successor()
        XCTAssertNotNil(successor, "Succesor of minimum, non-empty tree, not found")
    }
    
    func testSuccessorSingleNode() {
        let singleNode = TreeNode(key: 1, payload: "A")
        let successor = singleNode.successor()
        XCTAssertNil(successor, "Empty node should not have succesor")
    }
    
    func testDeleteExistentKey() {
        self.tree?.delete(1)
        XCTAssertNil(self.tree?.search(1), "Key should not exist anymore")
    }

    func testDeleteNOTExistentKey() {
        self.tree?.delete(1056)
        XCTAssertNil(self.tree?.search(1056), "Key should not exist")
    }

}

extension AVLTree where Key : SignedIntegerType {
  func autopopulateWithNodes(count : Int) {
    var k : Key = 1
    for _ in 0...count {
      self.insert(k++)
    }
  }
}
