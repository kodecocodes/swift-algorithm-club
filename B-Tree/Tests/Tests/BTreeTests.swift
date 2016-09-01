//
//  BTreeTests.swift
//  BTreeTests
//
//  Created by Viktor Szilárd Simkó on 09/06/16.
//  Copyright © 2016 Viktor Szilárd Simkó. All rights reserved.
//

import XCTest

class BTreeTests: XCTestCase {
  var bTree: BTree<Int, Int>!
  
  override func setUp() {
    super.setUp()
    bTree = BTree<Int, Int>(order: 3)!
  }
  
  // MARK: - Tests on empty tree
  
  func testOrder() {
    XCTAssertEqual(bTree.order, 3)
  }
  
  func testRootNode() {
    XCTAssertNotNil(bTree.rootNode)
  }
  
  func testNumberOfNodesOnEmptyTree() {
    XCTAssertEqual(bTree.numberOfKeys, 0)
  }
  
  func testInorderTraversalOfEmptyTree() {
    bTree.traverseKeysInOrder { i in
      XCTFail("Inorder travelsal fail.")
    }
  }
  
  func testSubscriptOnEmptyTree() {
    XCTAssertEqual(bTree[1], nil)
  }
  
  func testSearchEmptyTree() {
    XCTAssertEqual(bTree.value(for: 1), nil)
  }
  
  func testInsertToEmptyTree() {
    bTree.insert(1, for: 1)
    
    XCTAssertEqual(bTree[1]!, 1)
  }
  
  func testRemoveFromEmptyTree() {
    bTree.remove(1)
    XCTAssertEqual(bTree.description, "[]")
  }
  
  func testInorderArrayFromEmptyTree() {
    XCTAssertEqual(bTree.inorderArrayFromKeys, [Int]())
  }
  
  func testDescriptionOfEmptyTree() {
    XCTAssertEqual(bTree.description, "[]")
  }
  
  // MARK: - Travelsal
  
  func testInorderTravelsal() {
    for i in 1...20 {
      bTree.insert(i, for: i)
    }
    
    var j = 1
    
    bTree.traverseKeysInOrder { i in
      XCTAssertEqual(i, j)
      j += 1
    }
  }
  
  // MARK: - Searching
  
  func testSearchForMaximum() {
    for i in 1...20 {
      bTree.insert(i, for: i)
    }
    
    XCTAssertEqual(bTree.value(for: 20)!, 20)
  }
  
  func testSearchForMinimum() {
    for i in 1...20 {
      bTree.insert(i, for: i)
    }
    
    XCTAssertEqual(bTree.value(for: 1)!, 1)
  }
  
  // MARK: - Insertion
  
  func testInsertion() {
    bTree.insertKeysUpTo(20)
    
    XCTAssertEqual(bTree.numberOfKeys, 20)
    
    for i in 1...20 {
      XCTAssertNotNil(bTree[i])
    }
    
    do {
      try bTree.checkBalance()
    } catch {
      XCTFail("BTree is not balanced")
    }
  }
  
  // MARK: - Removal
  
  func testRemoveMaximum() {
    for i in 1...20 {
      bTree.insert(i, for: i)
    }
    
    bTree.remove(20)
    
    XCTAssertNil(bTree[20])
    
    do {
      try bTree.checkBalance()
    } catch {
      XCTFail("BTree is not balanced")
    }
  }
  
  func testRemoveMinimum() {
    bTree.insertKeysUpTo(20)
    
    bTree.remove(1)
    
    XCTAssertNil(bTree[1])
    
    do {
      try bTree.checkBalance()
    } catch {
      XCTFail("BTree is not balanced")
    }
  }
  
  func testRemoveSome() {
    bTree.insertKeysUpTo(20)
    
    bTree.remove(6)
    bTree.remove(9)
    
    XCTAssertNil(bTree[6])
    XCTAssertNil(bTree[9])
    
    do {
      try bTree.checkBalance()
    } catch {
      XCTFail("BTree is not balanced")
    }
  }
  
  func testRemoveSomeFrom2ndOrder() {
    bTree = BTree<Int, Int>(order: 2)!
    bTree.insertKeysUpTo(20)
    
    bTree.remove(6)
    bTree.remove(9)
    
    XCTAssertNil(bTree[6])
    XCTAssertNil(bTree[9])
    
    do {
      try bTree.checkBalance()
    } catch {
      XCTFail("BTree is not balanced")
    }
  }
  
  func testRemoveAll() {
    bTree.insertKeysUpTo(20)
    
    XCTAssertEqual(bTree.numberOfKeys, 20)
    
    for i in (1...20).reversed() {
      bTree.remove(i)
    }
    
    do {
      try bTree.checkBalance()
    } catch {
      XCTFail("BTree is not balanced")
    }
    
    XCTAssertEqual(bTree.numberOfKeys, 0)
  }
  
  // MARK: - InorderArray
  
	func testInorderArray() {
    bTree.insertKeysUpTo(20)
		
		let returnedArray = bTree.inorderArrayFromKeys
		let targetArray = Array<Int>(1...20)
		
		XCTAssertEqual(returnedArray, targetArray)
	}
}

enum BTreeError: Error {
  case tooManyNodes
  case tooFewNodes
}

extension BTreeNode {
  func checkBalance(isRoot root: Bool) throws {
    if numberOfKeys > owner.order * 2 {
      throw BTreeError.tooManyNodes
    } else if !root && numberOfKeys < owner.order {
      throw BTreeError.tooFewNodes
    }
    
    if !isLeaf {
      for child in children! {
        try child.checkBalance(isRoot: false)
      }
    }
  }
}

extension BTree where Key: SignedInteger, Value: SignedInteger {
  func insertKeysUpTo(_ to: Int) {
    var k: Key = 1
    var v: Value = 1
    
    for _ in 1...to {
      insert(v, for: k)
      k = k + 1
      v = v + 1
    }
  }
  
  func checkBalance() throws {
    try rootNode.checkBalance(isRoot: true)
  }
}
