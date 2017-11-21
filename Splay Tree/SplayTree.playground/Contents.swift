//: Playground - Splay Tree Implementation

// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

let splayTree = SplayTree(value: 1)
splayTree.insert(value: 2)
splayTree.insert(value: 10)
splayTree.insert(value: 6)

splayTree.remove(value: 10)
splayTree.remove(value: 6)

splayTree.insert(value: 55)
splayTree.insert(value: 559)
splayTree.remove(value: 2)
splayTree.remove(value: 1)
splayTree.remove(value: 55)
splayTree.remove(value: 559)

splayTree.insert(value: 1843000)
splayTree.insert(value: 1238)
splayTree.insert(value: -1)
splayTree.insert(value: 87)

splayTree.minimum()
splayTree.maximum()




