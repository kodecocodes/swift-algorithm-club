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
    XCTAssertEqual(bTree.valueForKey(1), nil)
  }
  
  func testInsertToEmptyTree() {
    bTree.insertValue(1, forKey: 1)
    
    XCTAssertEqual(bTree[1]!, 1)
  }
  
  func testRemoveFromEmptyTree() {
    bTree.removeKey(1)
    XCTAssertEqual(bTree.description, "[]")
  }
  
  func testInorderArrayFromEmptyTree() {
    XCTAssertEqual(bTree.inorderArrayFromKeys(), [Int]())
  }
  
  func testDescriptionOfEmptyTree() {
    XCTAssertEqual(bTree.description, "[]")
  }
  
  // MARK: - Travelsal
  
  func testInorderTravelsal() {
    for i in 1...20 {
      bTree.insertValue(i, forKey: i)
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
      bTree.insertValue(i, forKey: i)
    }
    
    XCTAssertEqual(bTree.valueForKey(20)!, 20)
  }
  
  func testSearchForMinimum() {
    for i in 1...20 {
      bTree.insertValue(i, forKey: i)
    }
    
    XCTAssertEqual(bTree.valueForKey(1)!, 1)
  }
  
  // MARK: - Insertion
  
  func testInsertion() {
    bTree.insertKeysUpTo(20)
    
    XCTAssertEqual(bTree.numberOfKeys, 20)
    
    for i in 1...20 {
      XCTAssertNotNil(bTree[i])
    }
    
    do {
      try bTree.checkBalanced()
    } catch {
      XCTFail("BTree is not balanced")
    }
  }
  
  // MARK: - Removal
  
  func testRemoveMaximum() {
    for i in 1...20 {
      bTree.insertValue(i, forKey: i)
    }
    
    bTree.removeKey(20)
    
    XCTAssertNil(bTree[20])
    
    do {
      try bTree.checkBalanced()
    } catch {
      XCTFail("BTree is not balanced")
    }
  }
  
  func testRemoveMinimum() {
    bTree.insertKeysUpTo(20)
    
    bTree.removeKey(1)
    
    XCTAssertNil(bTree[1])
    
    do {
      try bTree.checkBalanced()
    } catch {
      XCTFail("BTree is not balanced")
    }
  }
  
  func testRemoveSome() {
    bTree.insertKeysUpTo(20)
    
    bTree.removeKey(6)
    bTree.removeKey(9)
    
    XCTAssertNil(bTree[6])
    XCTAssertNil(bTree[9])
    
    do {
      try bTree.checkBalanced()
    } catch {
      XCTFail("BTree is not balanced")
    }
  }
  
  func testRemoveSomeFrom2ndOrder() {
    bTree = BTree<Int, Int>(order: 2)!
    bTree.insertKeysUpTo(20)
    
    bTree.removeKey(6)
    bTree.removeKey(9)
    
    XCTAssertNil(bTree[6])
    XCTAssertNil(bTree[9])
    
    do {
      try bTree.checkBalanced()
    } catch {
      XCTFail("BTree is not balanced")
    }
  }
  
  func testRemoveAll() {
    bTree.insertKeysUpTo(20)
    
    XCTAssertEqual(bTree.numberOfKeys, 20)
    
    for i in (1...20).reverse() {
      bTree.removeKey(i)
    }
    
    do {
      try bTree.checkBalanced()
    } catch {
      XCTFail("BTree is not balanced")
    }
    
    XCTAssertEqual(bTree.numberOfKeys, 0)
  }
  
  // MARK: - InorderArray
  
	func testInorderArray() {
    bTree.insertKeysUpTo(20)
		
		let returnedArray = bTree.inorderArrayFromKeys()
		let targetArray = Array<Int>(1...20)
		
		XCTAssertEqual(returnedArray, targetArray)
	}
}

enum BTreeError: ErrorType {
  case TooManyNodes
  case TooFewNodes
}

extension BTreeNode {
  func checkBalanced(isRoot root: Bool) throws {
    if numberOfKeys > ownerTree.order * 2 {
      throw BTreeError.TooManyNodes
    } else if !root && numberOfKeys < ownerTree.order {
      throw BTreeError.TooFewNodes
    }
    
    if !isLeaf {
      for child in children! {
        try child.checkBalanced(isRoot: false)
      }
    }
  }
}

extension BTree where Key: SignedIntegerType, Value: SignedIntegerType {
  func insertKeysUpTo(to: Int) {
    var k: Key = 1
    var v: Value = 1
    
    for _ in 1...to {
      insertValue(v, forKey: k)
      k = k + 1
      v = v + 1
    }
  }
  
  func checkBalanced() throws {
    try rootNode.checkBalanced(isRoot: true)
  }
}
