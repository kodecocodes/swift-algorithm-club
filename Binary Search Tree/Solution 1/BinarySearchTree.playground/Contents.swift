//: Playground - noun: a place where people can play

let tree = BinarySearchTree<Int>(value: 7)
tree.insert(2)
tree.insert(5)
tree.insert(10)
tree.insert(9)
tree.insert(1)

tree
tree.debugDescription

let tree2 = BinarySearchTree<Int>(array: [7, 2, 5, 10, 9, 1])

tree.search(5)
tree.search(2)
tree.search(7)
tree.search(6)

tree.traverseInOrder { value in print(value) }

tree.toArray()

tree.minimum()
tree.maximum()

if let node2 = tree.search(2) {
  node2.remove()
  node2
  print(tree)
}

tree.height()
tree.predecessor()
tree.successor()

if let node10 = tree.search(10) {
  node10.depth()        // 1
  node10.height()       // 1
  node10.predecessor()
  node10.successor()    // nil
}

if let node9 = tree.search(9) {
  node9.depth()        // 2
  node9.height()       // 0
  node9.predecessor()
  node9.successor()
}

if let node1 = tree.search(1) {
  // This makes it an invalid binary search tree because 100 is greater
  // than the root, 7, and so must be in the right branch not in the left.
  tree.isBST(minValue: Int.min, maxValue: Int.max)  // true
  node1.insert(100)
  tree.search(100)                                  // nil
  tree.isBST(minValue: Int.min, maxValue: Int.max)  // false
}
