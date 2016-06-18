//: Playground - noun: a place where people can play

let tree = AVLTree<Int, String>()

tree.insert(5, "five")
print(tree)

tree.insert(4, "four")
print(tree)

tree.insert(3, "three")
print(tree)

tree.insert(2, "two")
print(tree)

tree.insert(1, "one")
print(tree)
print(tree.debugDescription)

let node = tree.search(2)   // "two"

tree.delete(5)
tree.delete(2)
tree.delete(1)
tree.delete(4)
tree.delete(3)
