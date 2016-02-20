//
//  AVLTreeTestsTests.swift
//  AVLTreeTestsTests
//
//  Created by Barbara Rodeker on 2/19/16.
//  Copyright © 2016 Swift Algorithm Club. All rights reserved.
//

import XCTest

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
}

extension AVLTree where Key : SignedIntegerType {
  func autopopulateWithNodes(count : Int) {
    var k : Key = 1
    for _ in 0...count {
      self.insert(k++)
    }
  }
}
