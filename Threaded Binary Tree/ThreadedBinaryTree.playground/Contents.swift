//: Playground - noun: a place where people can play

// Simple little debug function to make testing output pretty
func check(_ tree: ThreadedBinaryTree<Int>?) {
  if let tree = tree {
    print("\(tree.count) Total Nodes:")
    print(tree)
    print("Debug Info:")
    print(tree.debugDescription)
    print("In-Order Traversal:")
    let myArray = tree.toArray()
    for node in myArray {
      print(node)
    }
    if tree.isBST(minValue: Int.min, maxValue: Int.max) {
      print("This is a VALID binary search tree.")
    } else {
      print("This is an INVALID binary search tree.")
    }
    if tree.isThreaded() {
      print("This is a VALID threaded binary tree.")
    } else {
      print("This is an INVALID threaded binary tree.")
    }
    } else {
      print("This tree is nil.")
    }
}

print("\nTree with Single Node")
let emptyTree = ThreadedBinaryTree<Int>(value: 1)
check(emptyTree)

print("\nFull Balanced Binary Tree with 7 Nodes")
let fullTree = ThreadedBinaryTree<Int>(value: 4)
fullTree.insert(2)
fullTree.insert(1)
fullTree.insert(6)
fullTree.insert(5)
fullTree.insert(3)
fullTree.insert(7)
check(fullTree)

print("\n\nBase Binary Tree with 5 Nodes")
let tree = ThreadedBinaryTree<Int>(array: [9, 5, 12, 2, 7])
check(tree)

print("\nInsert 10")
tree.insert(10)
check(tree)

print("\nInsert 4")
tree.insert(4)
check(tree)

print("\nInsert 15")
tree.insert(15)
check(tree)

print("\nRemove 13 (Not in the Tree)")
tree.remove(13)
check(tree)

print("\nRemove 7")
tree.remove(7)
check(tree)

print("\nRemove 5")
tree.remove(5)
check(tree)

print("\nRemove 9 (root)")
let newRoot = tree.remove(9)
check(newRoot)

print("\nRemove 12")
newRoot?.remove(12)
check(newRoot)

print("\n\nDone with Tests!\n")
