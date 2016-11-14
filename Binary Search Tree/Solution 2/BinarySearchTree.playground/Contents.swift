

// Test 1:

var tree1 = BinarySearchTree(7)
tree1.insert(5)
tree1.insert(2)
tree1.p_remove(2)
if let node2 = tree1.search(2) {
    let p = node2.parent
}
tree1.insert(5)
tree1.p_remove(5)

// Test 2:

var tree = BinarySearchTree(array: [8, 5, 10, 9, 1])
tree.insert(7)
tree.insert(4)
tree.insert(12)
tree.insert(11)
tree.insert(12)

// The code belloe will print: 1 4 5 7 8 9 10 11 12
tree.traverseInOrder { value in
    print(value)
}
//tree.traversePreOrder { value in
//    print(value)
//}
////tree.traversePostOrder { value in
////    print(value)
////}
//

if let node5 = tree.search(5) {
    node5.left?.value
    node5.parent?.value
    node5.right?.value
    node5.count
    node5.height
    let node10 = tree.search(10)
    if node5.right == node10 {
        print("node5.right is node10")
    }
    let node7 = tree.search(7)
    if node5.right == node7 {
        print("node5.right is node7")
    }
    node5.remove(1)
    
}

tree.remove(8)
tree             // The tree is still the old tree
tree = tree.remove(5)!
tree.remove(100) // because no 100 in the tree, so no element removed
