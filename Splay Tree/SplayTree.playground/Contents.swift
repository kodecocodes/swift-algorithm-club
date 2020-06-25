//: Playground - Splay Tree Implementation

// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

var tree = SplayTree<Int>(value: 0)
tree.insert(value: 2)
tree.insert(value: 3)
tree.insert(value: 4)
tree.insert(value: 7)
_ = tree.search(value: 2)
tree.remove(value: 2)
