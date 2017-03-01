//: Playground - noun: a place where people can play

import Foundation

let bTree = BTree<Int, Int>(order: 1)!

bTree.insert(1, for: 1)
bTree.insert(2, for: 2)
bTree.insert(3, for: 3)
bTree.insert(4, for: 4)

bTree.value(for: 3)
bTree[3]

bTree.remove(2)

bTree.traverseKeysInOrder {
  key in
  print(key)
}

bTree.numberOfKeys

bTree.order

bTree.inorderArrayFromKeys
