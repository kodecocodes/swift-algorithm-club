//: Playground - noun: a place where people can play

let tree = AVLTree<Int, String>()

tree.insert(key: 5, payload: "five")
print(tree)

tree.insert(key: 4, payload: "four")
print(tree)

tree.insert(key: 3, payload: "three")
print(tree)

tree.insert(key: 2, payload: "two")
print(tree)

tree.insert(key: 1, payload: "one")
print(tree)
print(tree.debugDescription)

let node = tree.search(input: 2)   // "two"

tree.delete(key: 5)
tree.delete(key: 2)
tree.delete(key: 1)
tree.delete(key: 4)
tree.delete(key: 3)
