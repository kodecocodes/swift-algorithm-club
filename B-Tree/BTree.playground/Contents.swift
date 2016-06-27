//: Playground - noun: a place where people can play

import Foundation

let bTree = BTree<Int, Int>(order: 1)!

bTree.insertValue(1, forKey: 1)
bTree.insertValue(2, forKey: 2)
bTree.insertValue(3, forKey: 3)
bTree.insertValue(4, forKey: 4)

bTree.valueForKey(3)
bTree[3]

bTree.removeKey(2)

bTree.traverseKeysInOrder {
  key in
  print(key)
}

bTree.numberOfKeys

bTree.order

bTree.inorderArrayFromKeys()