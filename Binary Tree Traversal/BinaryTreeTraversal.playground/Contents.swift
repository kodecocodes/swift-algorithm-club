//: Playground - noun: a place where people can play

/*
Tree:
 
       1
      / \
     2   3
    / \   \
   4   5   6
  /
 7
 
 */


let node1 = TreeNode(val: 1)
let node2 = TreeNode(val: 2)
let node3 = TreeNode(val: 3)
let node4 = TreeNode(val: 4)
let node5 = TreeNode(val: 5)
let node6 = TreeNode(val: 6)
let node7 = TreeNode(val: 7)

node1.left = node2
node1.right = node3
node2.left = node4
node2.right = node5
node3.right = node6
node4.left = node7

let inorder = BTInorder<Int>()
print("Inorder:")
inorder.traverse(node1) // 7 4 2 5 1 3 6

let preorder = BTPreorder<Int>()
print("Preorder:")
preorder.traverse(node1) // 1 2 4 7 5 3 6

let postorder = BTPostorder<Int>()
print("Postorder:")
postorder.traverse(node1) // 7 4 5 2 6 3 1


