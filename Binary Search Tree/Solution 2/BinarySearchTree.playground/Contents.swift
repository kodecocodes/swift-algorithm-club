//: Playground - noun: a place where people can play

// Each time you insert something, you get back a completely new tree.
var tree = BinarySearchTree.Leaf(7)
tree = tree.insert(2)
tree = tree.insert(5)
tree = tree.insert(10)
tree = tree.insert(9)
tree = tree.insert(1)
print(tree)

tree.search(10)
tree.search(1)
tree.search(11)
