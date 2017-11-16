# Encode and Decode Binary Tree

> **Note**: The prerequisite for this article is an understanding of how [binary trees](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Binary%20Tree) work.

Trees are complex structures. Unlike linear collections such as arrays or linked lists, trees are *non-linear* and each element in a tree has positional information such as the *parent-child* relationship between nodes. When you want to send a tree structure to your backend, you need to send the data of each node, and a way to represent the parent-child relationship for each node.

Your strategy in how you choose to represent this information is called your **encoding** strategy. The opposite of that - changing your encoded data back to its original form - is your **decoding** strategy. 

There are many ways to encode a tree and decode a tree. The important thing to keep in mind is that encoding and decoding strategies are closely related. The way you choose to encode a tree directly affects how you might decode a tree. 

Encoding and decoding are synonyms to *serializing* and *deserializing* trees. 

As a reference, the following code represents the typical `Node` type of a binary tree:

```swift
class BinaryNode<Element: Comparable> {
  var data: Element
  var leftChild: BinaryNode?
  var rightChild: BinaryNode?

  // ... (rest of the implementation)
}
```

## Encoding

As mentioned before, there are different ways to do encoding. For no particular reason, you'll opt for the following rules:

1. The result of the encoding will be a `String` object.
2. You'll encode using *pre-order* traversal.

Here's an example of this operation in code:

```swift
extension BinaryNode {
  var encodedString: String {
    var str = ""
    preOrderTraversal { str.append($0) }
    return str
  }
  
  func preOrderTraversal(visit: (T) -> ()) {
    visit(data)
    leftChild?.preOrderTraversal(visit: visit)
    rightChild?.preOrderTraversal(visit: visit)
  }
}
```

