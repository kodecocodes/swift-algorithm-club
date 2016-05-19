//: Playground - noun: a place where people can play

import Foundation

let treeX = AVLTree<Int, String>()

treeX.insert(5, "five")
print(treeX)

treeX.insert(4, "four")
print(treeX)

treeX.insert(3, "three")
print(treeX)

treeX.insert(2, "two")
print(treeX)

treeX.insert(1, "one")
print(treeX)
print(treeX.debugDescription)

let node = treeX.search(2)   // "two"

treeX.delete(5)
treeX.delete(2)
treeX.delete(1)
treeX.delete(4)
treeX.delete(3)



var tree = AVLTree<Int, Int>()

tree.insert(7)
tree.insert(12)
tree.insert(3)
tree.insert(5)
tree.insert(2)
tree.insert(6)
tree.insert(1)
tree.insert(13)
tree.insert(8)
tree.insert(10)
tree.insert(9)
tree.insert(15)
tree.insert(11)
tree.insert(14)
tree.insert(4)

tree.delete(14)
tree.delete(13)
tree.delete(12)

tree.root?.isBST(minValue: 0, maxValue: 20)

var aTree = AVLTree<Int, String>()


aTree.insert(7)
aTree.insert(12)
aTree.insert(3)
aTree.insert(5)
aTree.insert(2)
aTree.insert(6)

aTree.insert(1)
aTree.insert(13)
aTree.insert(8)
aTree.insert(10)

aTree.insert(9)

aTree.insert(15)
aTree.insert(11)
aTree.insert(14)

aTree.insert(4)

//
//
aTree.delete(14)
aTree.delete(13)
aTree.delete(12)

aTree.root?.isBST(minValue: 0, maxValue: 20)

aTree.delete(4)
aTree.delete(3)
aTree.delete(5)
aTree.delete(10)
aTree.delete(11)
aTree.delete(8)
aTree.delete(15)
aTree.delete(9)
aTree.delete(6)
aTree.delete(1)
aTree.delete(2)
aTree.delete(7)
aTree.insert(8, "eight")
aTree.insert(4, "four")
aTree.insert(12, "twelve")
aTree.insert(2, "two")
aTree.insert(6, "six")
aTree.insert(10, "ten")
aTree.insert(14, "fourteen")
aTree.insert(1, "one")
aTree.insert(3, "three")
aTree.insert(5, "five")
aTree.insert(7, "seven")
aTree.insert(9, "nine")
aTree.insert(11, "element")
aTree.insert(13, "thirteen")
aTree.insert(15, "fifteen")

aTree.root?.keys
let payloads: [String] = (aTree.root?.payloads.flatMap{ x in
	if let s = x {
		return s
	}
	return ""
	})!

aTree.delete(14)
aTree.delete(13)
aTree.delete(12)

aTree.search(4)?.display()

let bTree = AVLTree<UInt32, Int>()

for i in 0..<1000 {
	let x = arc4random_uniform(100)
	let y = Int(x)
	bTree.insert(x, y)
}

for i in 0..<100 {
	let x = arc4random_uniform(100)
	bTree.delete(x)
}

