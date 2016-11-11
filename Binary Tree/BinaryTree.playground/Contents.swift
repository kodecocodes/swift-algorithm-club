// leaf nodes
let node5 = BinaryTree.Node(.Empty, "5", .Empty)
let nodeA = BinaryTree.Node(.Empty, "a", .Empty)
let node10 = BinaryTree.Node(.Empty, "10", .Empty)
let node4 = BinaryTree.Node(.Empty, "4", .Empty)
let node3 = BinaryTree.Node(.Empty, "3", .Empty)
let nodeB = BinaryTree.Node(.Empty, "b", .Empty)

// intermediate nodes on the left
let aMinus10 = BinaryTree.Node(nodeA, "-", node10)
let timesLeft = BinaryTree.Node(node5, "*", aMinus10)

// intermediate nodes on the right
let minus4 = BinaryTree.Node(.Empty, "-", node4)
let divide3andB = BinaryTree.Node(node3, "/", nodeB)
let timesRight = BinaryTree.Node(minus4, "*", divide3andB)

// root node
let tree = BinaryTree.Node(timesLeft, "+", timesRight)

print(tree)
tree.count  // 12

tree.traverseInOrder { s in print(s) }
//tree.traversePreOrder { s in print(s) }
//tree.traversePostOrder { s in print(s) }
