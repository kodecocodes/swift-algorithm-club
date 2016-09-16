//: Playground - noun: a place where people can play

let array = [6,78,89,4]
var tree = RBTree<Int>(withArray: array)
tree.insert(5)
tree.insert(8)
tree.insert(2)
tree.delete(6)
tree.delete(8)