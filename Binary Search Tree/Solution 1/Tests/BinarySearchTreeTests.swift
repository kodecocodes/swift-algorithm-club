import Foundation
import XCTest

class BinarySearchTreeTest: XCTestCase {
  func testRootNode() {
    let tree = BinarySearchTree(value: 8)
    XCTAssertEqual(tree.count, 1)
    XCTAssertEqual(tree.minimum().value, 8)
    XCTAssertEqual(tree.maximum().value, 8)
    XCTAssertEqual(tree.height(), 0)
    XCTAssertEqual(tree.depth(), 0)
    XCTAssertEqual(tree.toArray(), [8])
  }

  func testCreateFromArray() {
    let tree = BinarySearchTree(array: [8, 5, 10, 3, 12, 9, 6, 16])
    XCTAssertEqual(tree.count, 8)
    XCTAssertEqual(tree.toArray(), [3, 5, 6, 8, 9, 10, 12, 16])

    XCTAssertEqual(tree.search(9)!.value, 9)
    XCTAssertNil(tree.search(99))

    XCTAssertEqual(tree.minimum().value, 3)
    XCTAssertEqual(tree.maximum().value, 16)

    XCTAssertEqual(tree.height(), 3)
    XCTAssertEqual(tree.depth(), 0)

    let node1 = tree.search(16)
    XCTAssertNotNil(node1)
    XCTAssertEqual(node1!.height(), 0)
    XCTAssertEqual(node1!.depth(), 3)

    let node2 = tree.search(12)
    XCTAssertNotNil(node2)
    XCTAssertEqual(node2!.height(), 1)
    XCTAssertEqual(node2!.depth(), 2)

    let node3 = tree.search(10)
    XCTAssertNotNil(node3)
    XCTAssertEqual(node3!.height(), 2)
    XCTAssertEqual(node3!.depth(), 1)
  }

  func testInsert() {
    let tree = BinarySearchTree(value: 8)

    tree.insert(5)
    XCTAssertEqual(tree.count, 2)
    XCTAssertEqual(tree.height(), 1)
    XCTAssertEqual(tree.depth(), 0)

    let node1 = tree.search(5)
    XCTAssertNotNil(node1)
    XCTAssertEqual(node1!.height(), 0)
    XCTAssertEqual(node1!.depth(), 1)

    tree.insert(10)
    XCTAssertEqual(tree.count, 3)
    XCTAssertEqual(tree.height(), 1)
    XCTAssertEqual(tree.depth(), 0)

    let node2 = tree.search(10)
    XCTAssertNotNil(node2)
    XCTAssertEqual(node2!.height(), 0)
    XCTAssertEqual(node2!.depth(), 1)

    tree.insert(3)
    XCTAssertEqual(tree.count, 4)
    XCTAssertEqual(tree.height(), 2)
    XCTAssertEqual(tree.depth(), 0)

    let node3 = tree.search(3)
    XCTAssertNotNil(node3)
    XCTAssertEqual(node3!.height(), 0)
    XCTAssertEqual(node3!.depth(), 2)
    XCTAssertEqual(node1!.height(), 1)
    XCTAssertEqual(node1!.depth(), 1)

    XCTAssertEqual(tree.minimum().value, 3)
    XCTAssertEqual(tree.maximum().value, 10)
    XCTAssertEqual(tree.toArray(), [3, 5, 8, 10])
  }

  func testInsertDuplicates() {
    let tree = BinarySearchTree(array: [8, 5, 10])
    tree.insert(8)
    tree.insert(5)
    tree.insert(10)
    XCTAssertEqual(tree.count, 6)
    XCTAssertEqual(tree.toArray(), [5, 5, 8, 8, 10, 10])
  }

  func testTraversing() {
    let tree = BinarySearchTree(array: [8, 5, 10, 3, 12, 9, 6, 16])

    var inOrder = [Int]()
    tree.traverseInOrder { inOrder.append($0) }
    XCTAssertEqual(inOrder, [3, 5, 6, 8, 9, 10, 12, 16])

    var preOrder = [Int]()
    tree.traversePreOrder { preOrder.append($0) }
    XCTAssertEqual(preOrder, [8, 5, 3, 6, 10, 9, 12, 16])

    var postOrder = [Int]()
    tree.traversePostOrder { postOrder.append($0) }
    XCTAssertEqual(postOrder, [3, 6, 5, 9, 16, 12, 10, 8])
  }

  func testInsertSorted() {
    let tree = BinarySearchTree(array: [8, 5, 10, 3, 12, 9, 6, 16].sort(<))
    XCTAssertEqual(tree.count, 8)
    XCTAssertEqual(tree.toArray(), [3, 5, 6, 8, 9, 10, 12, 16])

    XCTAssertEqual(tree.minimum().value, 3)
    XCTAssertEqual(tree.maximum().value, 16)

    XCTAssertEqual(tree.height(), 7)
    XCTAssertEqual(tree.depth(), 0)

    let node1 = tree.search(16)
    XCTAssertNotNil(node1)
    XCTAssertEqual(node1!.height(), 0)
    XCTAssertEqual(node1!.depth(), 7)
  }

  func testRemoveLeaf() {
    let tree = BinarySearchTree(array: [8, 5, 10, 4])

    let node10 = tree.search(10)!
    XCTAssertNil(node10.left)
    XCTAssertNil(node10.right)
    XCTAssertTrue(tree.right === node10)

    let node5 = tree.search(5)!
    XCTAssertTrue(tree.left === node5)

    let node4 = tree.search(4)!
    XCTAssertTrue(node5.left === node4)
    XCTAssertNil(node5.right)

    let replacement1 = node4.remove()
    XCTAssertNil(node5.left)
    XCTAssertNil(replacement1)

    let replacement2 = node5.remove()
    XCTAssertNil(tree.left)
    XCTAssertNil(replacement2)

    let replacement3 = node10.remove()
    XCTAssertNil(tree.right)
    XCTAssertNil(replacement3)

    XCTAssertEqual(tree.count, 1)
    XCTAssertEqual(tree.toArray(), [8])
  }

  func testRemoveOneChildLeft() {
    let tree = BinarySearchTree(array: [8, 5, 10, 4, 9])

    let node4 = tree.search(4)!
    let node5 = tree.search(5)!
    XCTAssertTrue(node5.left === node4)
    XCTAssertTrue(node5 === node4.parent)

    node5.remove()
    XCTAssertTrue(tree.left === node4)
    XCTAssertTrue(tree === node4.parent)
    XCTAssertNil(node4.left)
    XCTAssertNil(node4.right)
    XCTAssertEqual(tree.count, 4)
    XCTAssertEqual(tree.toArray(), [4, 8, 9, 10])

    let node9 = tree.search(9)!
    let node10 = tree.search(10)!
    XCTAssertTrue(node10.left === node9)
    XCTAssertTrue(node10 === node9.parent)

    node10.remove()
    XCTAssertTrue(tree.right === node9)
    XCTAssertTrue(tree === node9.parent)
    XCTAssertNil(node9.left)
    XCTAssertNil(node9.right)
    XCTAssertEqual(tree.count, 3)
    XCTAssertEqual(tree.toArray(), [4, 8, 9])
  }

  func testRemoveOneChildRight() {
    let tree = BinarySearchTree(array: [8, 5, 10, 6, 11])

    let node6 = tree.search(6)!
    let node5 = tree.search(5)!
    XCTAssertTrue(node5.right === node6)
    XCTAssertTrue(node5 === node6.parent)

    node5.remove()
    XCTAssertTrue(tree.left === node6)
    XCTAssertTrue(tree === node6.parent)
    XCTAssertNil(node6.left)
    XCTAssertNil(node6.right)
    XCTAssertEqual(tree.count, 4)
    XCTAssertEqual(tree.toArray(), [6, 8, 10, 11])

    let node11 = tree.search(11)!
    let node10 = tree.search(10)!
    XCTAssertTrue(node10.right === node11)
    XCTAssertTrue(node10 === node11.parent)

    node10.remove()
    XCTAssertTrue(tree.right === node11)
    XCTAssertTrue(tree === node11.parent)
    XCTAssertNil(node11.left)
    XCTAssertNil(node11.right)
    XCTAssertEqual(tree.count, 3)
    XCTAssertEqual(tree.toArray(), [6, 8, 11])
  }

  func testRemoveTwoChildrenSimple() {
    let tree = BinarySearchTree(array: [8, 5, 10, 4, 6, 9, 11])

    let node4 = tree.search(4)!
    let node5 = tree.search(5)!
    let node6 = tree.search(6)!
    XCTAssertTrue(node5.left === node4)
    XCTAssertTrue(node5.right === node6)
    XCTAssertTrue(node5 === node4.parent)
    XCTAssertTrue(node5 === node6.parent)

    let replacement1 = node5.remove()
    XCTAssertTrue(replacement1 === node6)
    XCTAssertTrue(tree.left === node6)
    XCTAssertTrue(tree === node6.parent)
    XCTAssertTrue(node6.left === node4)
    XCTAssertTrue(node6 === node4.parent)
    XCTAssertNil(node5.left)
    XCTAssertNil(node5.right)
    XCTAssertNil(node5.parent)
    XCTAssertNil(node4.left)
    XCTAssertNil(node4.right)
    XCTAssertNotNil(node4.parent)
    XCTAssertEqual(tree.count, 6)
    XCTAssertEqual(tree.toArray(), [4, 6, 8, 9, 10, 11])

    let node9 = tree.search(9)!
    let node10 = tree.search(10)!
    let node11 = tree.search(11)!
    XCTAssertTrue(node10.left === node9)
    XCTAssertTrue(node10.right === node11)
    XCTAssertTrue(node10 === node9.parent)
    XCTAssertTrue(node10 === node11.parent)

    let replacement2 = node10.remove()
    XCTAssertTrue(replacement2 === node11)
    XCTAssertTrue(tree.right === node11)
    XCTAssertTrue(tree === node11.parent)
    XCTAssertTrue(node11.left === node9)
    XCTAssertTrue(node11 === node9.parent)
    XCTAssertNil(node10.left)
    XCTAssertNil(node10.right)
    XCTAssertNil(node10.parent)
    XCTAssertNil(node9.left)
    XCTAssertNil(node9.right)
    XCTAssertNotNil(node9.parent)
    XCTAssertEqual(tree.count, 5)
    XCTAssertEqual(tree.toArray(), [4, 6, 8, 9, 11])
  }

  func testRemoveTwoChildrenComplex() {
    let tree = BinarySearchTree(array: [8, 5, 10, 4, 9, 20, 11, 15, 13])

    let node9 = tree.search(9)!
    let node10 = tree.search(10)!
    let node11 = tree.search(11)!
    let node15 = tree.search(15)!
    let node20 = tree.search(20)!
    XCTAssertTrue(node10.left === node9)
    XCTAssertTrue(node10 === node9.parent)
    XCTAssertTrue(node10.right === node20)
    XCTAssertTrue(node10 === node20.parent)
    XCTAssertTrue(node20.left === node11)
    XCTAssertTrue(node20 === node11.parent)
    XCTAssertTrue(node11.right === node15)
    XCTAssertTrue(node11 === node15.parent)

    let replacement = node10.remove()
    XCTAssertTrue(replacement === node11)
    XCTAssertTrue(tree.right === node11)
    XCTAssertTrue(tree === node11.parent)
    XCTAssertTrue(node11.left === node9)
    XCTAssertTrue(node11 === node9.parent)
    XCTAssertTrue(node11.right === node20)
    XCTAssertTrue(node11 === node20.parent)
    XCTAssertTrue(node20.left === node15)
    XCTAssertTrue(node20 === node15.parent)
    XCTAssertNil(node20.right)
    XCTAssertNil(node10.left)
    XCTAssertNil(node10.right)
    XCTAssertNil(node10.parent)
    XCTAssertEqual(tree.count, 8)
    XCTAssertEqual(tree.toArray(), [4, 5, 8, 9, 11, 13, 15, 20])
  }

  func testRemoveRoot() {
    let tree = BinarySearchTree(array: [8, 5, 10, 4, 9, 20, 11, 15, 13])

    let node9 = tree.search(9)!

    let newRoot = tree.remove()
    XCTAssertTrue(newRoot === node9)
    XCTAssertEqual(newRoot!.value, 9)
    XCTAssertEqual(newRoot!.count, 8)
    XCTAssertEqual(newRoot!.toArray(), [4, 5, 9, 10, 11, 13, 15, 20])

    // The old root is a subtree of a single element.
    XCTAssertEqual(tree.value, 8)
    XCTAssertEqual(tree.count, 1)
    XCTAssertEqual(tree.toArray(), [8])
  }

  func testPredecessor() {
    let tree = BinarySearchTree(array: [3, 1, 2, 5, 4])
    let node = tree.search(5)

    XCTAssertEqual(node!.value, 5)
    XCTAssertEqual(node!.predecessor()!.value, 4)
    XCTAssertEqual(node!.predecessor()!.predecessor()!.value, 3)
    XCTAssertEqual(node!.predecessor()!.predecessor()!.predecessor()!.value, 2)
    XCTAssertEqual(node!.predecessor()!.predecessor()!.predecessor()!.predecessor()!.value, 1)
    XCTAssertNil(node!.predecessor()!.predecessor()!.predecessor()!.predecessor()!.predecessor())
  }

  func testSuccessor() {
    let tree = BinarySearchTree(array: [3, 1, 2, 5, 4])
    let node = tree.search(1)

    XCTAssertEqual(node!.value, 1)
    XCTAssertEqual(node!.successor()!.value, 2)
    XCTAssertEqual(node!.successor()!.successor()!.value, 3)
    XCTAssertEqual(node!.successor()!.successor()!.successor()!.value, 4)
    XCTAssertEqual(node!.successor()!.successor()!.successor()!.successor()!.value, 5)
    XCTAssertNil(node!.successor()!.successor()!.successor()!.successor()!.successor())
  }
}
