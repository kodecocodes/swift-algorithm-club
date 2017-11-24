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

Your encoding and decoding methods will reside in the `BinaryNodeEncoder` and `BinaryNodeDecoder` classes:

```swift
class BinaryNodeCoder {
 
  // transforms nodes into string representation
  func encode<T>(_ node: BinaryNode<T>) throws -> String where T: Encodable {
    
  }
  
  // transforms string into `BinaryNode` representation
  func decode<T>(from string: String) 
    throws -> BinaryNode<T> where T: Decodable {
  
  }
}
```

## Encoding

As mentioned before, there are different ways to do encoding. For no particular reason, you'll opt for the following rules:

1. The result of the encoding will be a `String` object.
2. You'll encode using *pre-order* traversal.

Here's an example of this operation in code:

```swift
fileprivate extension BinaryNode {
  
  // 1
  func preOrderTraversal(visit: (Element?) throws -> ()) rethrows {
    try visit(data)
    
    if let leftChild = leftChild {
      try leftChild.preOrderTraversal(visit: visit)
    } else {
      try visit(nil)
    }
    
    if let rightChild = rightChild {
      try rightChild.preOrderTraversal(visit: visit)
    } else {
      try visit(nil)
    }
  }
}

class BinaryNodeCoder {

  // 2
  private var separator: String { return "," }
  
  // 3
  private var nilNode: String { return "X" }
  
  // 4
  func encode<T>(_ node: BinaryNode<T>) -> String {
    var str = ""
    node.preOrderTraversal { data in
      if let data = data {
        let string = String(describing: data)
        str.append(string)
      } else {
        str.append(nilNode)
      }
      str.append(separator)
    }
    return str
  }
  
  // ...
}
```

Here's a high level overview of the above code:

2. `separator` is a way to distinguish the nodes in a string. To illustrate its importance, consider the following encoded string "banana". How did the tree structure look like before encoding? Without the `separator`, you can't tell.

3. `nilNode` is used to identify empty children. This a necesssary piece of information to retain in order to rebuild the tree later.

4. `encode` returns a `String` representation of the `BinaryNode`. For example: "ba,nana,nil" represents a tree with two nodes - "ba" and "nana" - in pre-order format.

## Decoding

Your decoding strategy is the exact opposite of your encoding strategy. You'll take an encoded string, and turn it back into your binary tree.

Your encoding strategy followed the following rules:

1. The result of the encoding will be a `String` object.
2. You'll encode using *pre-order* traversal.

The implementation also added a few important details:

* node values are separated by `,` 
* `nil` children are denoted by the `nil` string

These details will shape your `decode` operation. Here's a possible implementation:

```swift

class BinaryNodeCoder {

  // ...
  
  // 1
  func decode<T>(_ string: String) -> BinaryNode<T>? {
    let components = encoded.lazy.split(separator: separator).reversed().map(String.init)
    return decode(from: components)
  }
  
  // 2
  private func decode(from array: inout [String]) -> BinaryNode<String>? {
    guard !array.isEmpty else { return nil }
    let value = array.removeLast()
    guard value != "\(nilNode)" else { return nil }
    
    let node = AVLNode<String>(value: value)
    node.leftChild = decode(from: &array)
    node.rightChild = decode(from: &array)
    return node
  }
}
```

Here's a high level overview of the above code:

1. Takes a `String`, and uses `split` to partition the contents of `string` into an array based on the `separator` defined in the encoding step. The result is first `reversed`, and then mapped to a `String`. The `reverse` step is an optimization for the next function, allowing us to use `array.removeLast()` instead of `array.removeFirst()`.

2. Using an array as a stack, you recursively decode each node. The array keeps track of sequence of nodes and progress.

Here's an example output of a tree undergoing the encoding and decoding process:

```
Original Tree

  ┌──8423
 ┌──8391
 │ └──nil
┌──7838
│ │ ┌──4936
│ └──3924
│  └──2506
830
│ ┌──701
└──202
 └──169

Encoded tree: 830,202,169,X,X,701,X,X,7838,3924,2506,X,X,4936,X,X,8391,X,8423,X,X,

Decoded tree

  ┌──8423
 ┌──8391
 │ └──nil
┌──7838
│ │ ┌──4936
│ └──3924
│  └──2506
830
│ ┌──701
└──202
 └──169
 ```

Notice the original tree and decoded tree are identical. 

## Further Reading & References

- [LeetCode](https://leetcode.com/problems/serialize-and-deserialize-binary-tree/description/)

*Written for the Swift Algorithm Club by Kai Chen & Kelvin Lau*



