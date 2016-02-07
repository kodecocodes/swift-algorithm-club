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

let minim = tree.root?.minimum()!  // node 1
var succ = minim!.successor()!     // node 2
succ = succ.successor()!           // node 3
succ = succ.successor()!           // node 4
succ = succ.successor()!           // node 5
succ.successor()                   // nil

tree.delete(2)
