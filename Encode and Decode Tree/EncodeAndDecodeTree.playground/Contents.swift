//: Playground - noun: a place where people can play

func printTree(_ root: BinaryNode<String>?) {
    guard let root = root else {
        return
    }

    let leftVal = root.left == nil ? "nil" : root.left!.val
    let rightVal = root.right == nil ? "nil" : root.right!.val

    print("val: \(root.val) left: \(leftVal) right: \(rightVal)")

    printTree(root.left)
    printTree(root.right)
}

let coder = BinaryNodeCoder<String>()

let node1 = BinaryNode("a")
let node2 = BinaryNode("b")
let node3 = BinaryNode("c")
let node4 = BinaryNode("d")
let node5 = BinaryNode("e")

node1.left = node2
node1.right = node3
node3.left = node4
node3.right = node5

let encodeStr = try coder.encode(node1)
print(encodeStr)
// "a b # # c d # # e # #"


let root: BinaryNode<String> = coder.decode(from: encodeStr)!
print("Tree:")
printTree(root)
/*
 Tree:
 val: a left: b right: c
 val: b left: nil right: nil
 val: c left: d right: e
 val: d left: nil right: nil
 val: e left: nil right: nil
 */

