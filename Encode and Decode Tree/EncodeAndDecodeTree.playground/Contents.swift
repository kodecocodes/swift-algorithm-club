//: Playground - noun: a place where people can play


func printTree(_ root: TreeNode?) {
    guard let root = root else {
        return
    }

    var pointer = root

    let leftVal = root.left == nil ? "nil" : root.left!.val
    let rightVal = root.right == nil ? "nil" : root.right!.val

    print("val: \(root.val) left: \(leftVal) right: \(rightVal)")

    printTree(root.left)
    printTree(root.right)
}

let s = EncodeAndDecodeTree()

let node1 = TreeNode("a")
let node2 = TreeNode("b")
let node3 = TreeNode("c")
let node4 = TreeNode("d")
let node5 = TreeNode("e")

node1.left = node2
node1.right = node3
node3.left = node4
node3.right = node5

let encodeStr = s.encode(node1)
print(encodeStr)
// "a b # # c d # # e # #"


let root = s.decode(encodeStr)
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

