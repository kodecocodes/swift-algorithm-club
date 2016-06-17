//
//  BTreeNodeTests.swift
//  BTree
//
//  Created by Viktor Szilárd Simkó on 13/06/16.
//  Copyright © 2016 Viktor Szilárd Simkó. All rights reserved.
//

import XCTest

class BTreeNodeTests: XCTestCase {
  
  let ownerTree = BTree<Int, Int>(order: 2)!
  var root: BTreeNode<Int, Int>!
  var leftChild: BTreeNode<Int, Int>!
  var rightChild: BTreeNode<Int, Int>!
  
  override func setUp() {
    super.setUp()
    
    root = BTreeNode(ownerTree: ownerTree)
    leftChild = BTreeNode(ownerTree: ownerTree)
    rightChild = BTreeNode(ownerTree: ownerTree)
    
    root.insertValue(1, forKey: 1)
    root.children = [leftChild, rightChild]
  }
  
  func testIsLeafRoot() {
    XCTAssertFalse(root.isLeaf)
  }
  
  func testIsLeafLeaf() {
    XCTAssertTrue(leftChild.isLeaf)
    XCTAssertTrue(rightChild.isLeaf)
  }
  
  func testOwner() {
    XCTAssert(root.ownerTree === ownerTree)
    XCTAssert(leftChild.ownerTree === ownerTree)
    XCTAssert(rightChild.ownerTree === ownerTree)
  }
  
  func testNumberOfKeys() {
    XCTAssertEqual(root.numberOfKeys, 1)
    XCTAssertEqual(leftChild.numberOfKeys, 0)
    XCTAssertEqual(rightChild.numberOfKeys, 0)
  }
  
  func testChildren() {
    XCTAssertEqual(root.children!.count, 2)
  }
}

