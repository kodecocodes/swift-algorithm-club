//
//  AVLTreeTestsTests.swift
//  AVLTreeTestsTests
//
//  Created by Barbara Rodeker on 2/19/16.
//  Copyright © 2016 Swift Algorithm Club. All rights reserved.
//

import XCTest

class AVLTreeTests: XCTestCase {

  var tree: AVLTree<Int, String>?

  override func setUp() {
    super.setUp()

    tree = AVLTree()
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testAVLTreeBalancedAutoPopulate() {
    self.tree?.autopopulateWithNodes(10)

    do {
      try self.tree?.inOrderCheckBalanced(self.tree?.root)
    } catch _ {
      XCTFail("Tree is not balanced after autopopulate")
    }
  }

  func testAVLTreeBalancedInsert() {
    self.tree?.autopopulateWithNodes(5)

    for i in 6...10 {
      self.tree?.insert(i)
      do {
        try self.tree?.inOrderCheckBalanced(self.tree?.root)
      } catch _ {
        XCTFail("Tree is not balanced after inserting " + String(i))
      }
    }
  }

  func testAVLTreeBalancedDelete() {
    self.tree?.autopopulateWithNodes(5)

    for i in 1...6 {
      self.tree?.delete(i)
      do {
        try self.tree?.inOrderCheckBalanced(self.tree?.root)
      } catch _ {
        XCTFail("Tree is not balanced after deleting " + String(i))
      }
    }
  }

  func testEmptyInitialization() {
    let tree = AVLTree<Int, String>()

    XCTAssertEqual(tree.size, 0)
    XCTAssertNil(tree.root)
  }

  func testSingleInsertionPerformance() {
    self.measure {
      self.tree?.insert(5, "E")
    }
  }

  func testMultipleInsertionsPerformance() {
    self.measure {
      self.tree?.autopopulateWithNodes(50)
    }
  }

  func testSearchExistentOnSmallTreePerformance() {
    self.measure {
      self.tree?.search(2)
    }
  }

  func testSearchExistentElementOnLargeTreePerformance() {
    self.measure {
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
    XCTAssertEqual(min?.payload, treeNode.payload)
  }

  func testDeleteExistentKey() {
    self.tree?.delete(1)
    XCTAssertNil(self.tree?.search(1), "Key should not exist anymore")
  }

  func testDeleteNotExistentKey() {
    self.tree?.delete(1056)
    XCTAssertNil(self.tree?.search(1056), "Key should not exist")
  }

  func testInsertSize() {
    let tree = AVLTree<Int, String>()
    for i in 0...5 {
      tree.insert(i, "")
      XCTAssertEqual(tree.size, i + 1, "Insert didn't update size correctly!")
    }
  }

  func testDelete() {
    let permutations = [
      [5, 1, 4, 2, 3],
      [2, 3, 1, 5, 4],
      [4, 5, 3, 2, 1],
      [3, 2, 5, 4, 1],
    ]

    for p in permutations {
      let tree = AVLTree<Int, String>()

      tree.insert(1, "five")
      tree.insert(2, "four")
      tree.insert(3, "three")
      tree.insert(4, "two")
      tree.insert(5, "one")

      var count = tree.size
      for i in p {
        tree.delete(i)
        count -= 1
        XCTAssertEqual(tree.size, count, "Delete didn't update size correctly!")
      }
    }
  }
}

extension AVLTree where Key : SignedInteger {
  func autopopulateWithNodes(_ count: Int) {
    var k: Key = 1
    for _ in 0...count {
      self.insert(k)
      k = k + 1
    }
  }
}

enum AVLTreeError: Error {
  case notBalanced
}

extension AVLTree where Key : SignedInteger {
  func height(_ node: Node?) -> Int {
    if let node = node {
      let lHeight = height(node.leftChild)
      let rHeight = height(node.rightChild)

      return max(lHeight, rHeight) + 1
    }
    return 0
  }

  func inOrderCheckBalanced(_ node: Node?) throws {
    if let node = node {
      guard abs(height(node.leftChild) - height(node.rightChild)) <= 1 else {
        throw AVLTreeError.notBalanced
      }
      try inOrderCheckBalanced(node.leftChild)
      try inOrderCheckBalanced(node.rightChild)
    }
  }
}
