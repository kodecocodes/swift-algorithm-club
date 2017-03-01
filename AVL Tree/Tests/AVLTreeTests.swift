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
      self.tree?.insert(key: i)
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
      self.tree?.delete(key: i)
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
      self.tree?.insert(key: 5, payload: "E")
    }
  }

  func testMultipleInsertionsPerformance() {
    self.measure {
      self.tree?.autopopulateWithNodes(50)
    }
  }

  func testSearchExistentOnSmallTreePerformance() {
    self.measure {
      print(self.tree?.search(input: 2))
    }
  }

  func testSearchExistentElementOnLargeTreePerformance() {
    self.measure {
      self.tree?.autopopulateWithNodes(500)
      print(self.tree?.search(input: 400))
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
    self.tree?.delete(key: 1)
    XCTAssertNil(self.tree?.search(input: 1), "Key should not exist anymore")
  }

  func testDeleteNotExistentKey() {
    self.tree?.delete(key: 1056)
    XCTAssertNil(self.tree?.search(input: 1056), "Key should not exist")
  }

  func testInsertSize() {
    let tree = AVLTree<Int, String>()
    for i in 0...5 {
      tree.insert(key: i, payload: "")
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

      tree.insert(key: 1, payload: "five")
      tree.insert(key: 2, payload: "four")
      tree.insert(key: 3, payload: "three")
      tree.insert(key: 4, payload: "two")
      tree.insert(key: 5, payload: "one")

      var count = tree.size
      for i in p {
        tree.delete(key: i)
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
      self.insert(key: k)
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
