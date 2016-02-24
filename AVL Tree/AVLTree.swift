// The MIT License (MIT)

// Copyright (c) 2016 Mike Taghavi (mitghi[at]me.com)

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

public class TreeNode<Key: Comparable, Payload> {
  public typealias Node = TreeNode<Key, Payload>

  public var payload: Payload?

  private var key: Key
  private var leftChild: Node?
  private var rightChild: Node?
  weak private var parent: Node?
  private var balance = 0
  
  public init(key: Key, payload: Payload?, leftChild: Node?, rightChild: Node?, parent: Node?) {
    self.key = key
    self.payload = payload
    self.leftChild = leftChild
    self.leftChild?.parent = self
    self.rightChild = rightChild
    self.rightChild?.parent = self
    self.parent = parent
  }

  public convenience init(key: Key, payload: Payload?) {
    self.init(key: key, payload: payload, leftChild: nil, rightChild: nil, parent: nil)
  }

  public convenience init(key: Key) {
    self.init(key: key, payload: nil)
  }
  
  public var isRoot: Bool {
    return parent == nil
  }
  
  public var isLeaf: Bool {
    return rightChild == nil && leftChild == nil
  }
  
  public var isLeftChild: Bool {
    return parent?.leftChild === self
  }
  
  public var isRightChild: Bool {
    return parent?.rightChild === self
  }
  
  public var hasLeftChild: Bool {
    return leftChild != nil
  }
  
  public var hasRightChild: Bool {
    return rightChild != nil
  }

  public var hasAnyChild: Bool {
    return leftChild != nil || rightChild != nil
  }
  
  public var hasBothChildren: Bool {
    return leftChild != nil && rightChild != nil
  }
}

// MARK: - The AVL tree

public class AVLTree<Key: Comparable, Payload> {
  public typealias Node = TreeNode<Key, Payload>

  private(set) public var root: Node?
  private(set) public var size = 0
  
  public init() { }
}

// MARK: - Searching

extension TreeNode {
  public func minimum() -> TreeNode? {
    var curr: TreeNode? = self
    while curr != nil && curr!.hasLeftChild {
      curr = curr!.leftChild
    }
    return curr
  }
  
  public func successor() -> Node? {
    if let right = rightChild {
      return right.minimum()
    } else if let parent = parent {
      if isLeftChild {
        return parent
      } else {
        parent.rightChild = nil
        let result = parent.successor()
        parent.rightChild = self
        return result
      }
    }
    return nil
  }
}

extension AVLTree {
  subscript(key: Key) -> Payload? {
    get { return search(key) }
    set { insert(key, newValue) }
  }

  public func search(input: Key) -> Payload? {
    if let result = search(input, root) {
      return result.payload
    } else {
      return nil
    }
  }

  private func search(key: Key, _ node: Node?) -> Node? {
    if let node = node {
      if key == node.key {
        return node
      } else if key < node.key {
        return search(key, node.leftChild)
      } else {
        return search(key, node.rightChild)
      }
    }
    return nil
  }
}

// MARK: - Inserting new items

extension AVLTree {
  public func insert(key: Key, _ payload: Payload? = nil) {
    if let root = root {
      insert(key, payload, root)
    } else {
      root = Node(key: key, payload: payload)
    }
    size += 1
  }

  private func insert(input: Key, _ payload: Payload?, _ node: Node) {
    if input < node.key {
      if let child = node.leftChild {
        insert(input, payload, child)
      } else {
        let child = Node(key: input, payload: payload, leftChild: nil, rightChild: nil, parent: node)
        node.leftChild = child
        updateBalance(child)
      }
    } else {
      if let child = node.rightChild {
        insert(input, payload, child)
      } else {
        let child = Node(key: input, payload: payload, leftChild: nil, rightChild: nil, parent: node)
        node.rightChild = child
        updateBalance(child)
      }
    }
  }
}

// MARK: - Deleting items

extension TreeNode {
  private func spliceout(){
    if isLeaf {
      if isLeftChild {
        parent!.leftChild = nil
      } else if isRightChild {
        parent!.rightChild = nil
      }
    } else if hasAnyChild {
      if hasLeftChild {
        parent!.leftChild = leftChild!
      } else {
        parent!.rightChild = rightChild!
      }
      leftChild!.parent = parent!
    } else {
      if isLeftChild {
        parent!.leftChild = rightChild!
      } else {
        parent!.rightChild = rightChild!
      }
      rightChild!.parent = parent!
    }
  }

  private func replace(key: Key, _ payload: Payload?, _ leftChild: Node?, _ rightChild: Node?) {
    self.key = key
    self.payload = payload
    self.leftChild = leftChild
    self.rightChild = rightChild
    
    if hasLeftChild {
      self.leftChild!.parent! = self
    }
    if hasRightChild {
      self.rightChild!.parent! = self
    }
  }
}

extension AVLTree {
  public func delete(key: Key) {
    if size == 1 {
      root = nil
      size -= 1
    } else if let node = search(key, root) {
      delete(node)
      size -= 1
    }
  }

  private func delete(node: Node) {
    if node.isLeaf {
      if node.isLeftChild {
        node.parent!.leftChild = nil
      } else if node.isRightChild {
        node.parent!.rightChild = nil
      }
    } else if node.hasBothChildren {
      let successor = node.successor()!
      successor.spliceout()
      node.key = successor.key
      node.payload = successor.payload

      if node.hasAnyChild {
        if node.hasBothChildren {
          node.balance = max(node.leftChild!.balance, node.rightChild!.balance) + 1
        } else if node.hasRightChild {
          node.balance = node.rightChild!.balance + 1
        } else if node.hasLeftChild {
          node.balance = node.leftChild!.balance + 1
        }
      }
    } else if node.hasLeftChild {
      if node.isLeftChild {
        node.leftChild!.parent = node.parent
        node.parent!.leftChild = node.leftChild
        node.balance = node.leftChild!.balance + 1
      } else if node.isRightChild {
        node.leftChild!.parent = node.parent
        node.parent!.rightChild = node.rightChild
        node.balance = node.rightChild!.balance + 1
      } else {
        node.replace(node.leftChild!.key, node.leftChild!.payload, node.leftChild!.leftChild, node.leftChild!.rightChild)
      }
    } else if node.hasRightChild{
      if node.isRightChild{
        node.rightChild!.parent = node.parent
        node.parent!.rightChild = node.rightChild
        node.balance = node.rightChild!.balance + 1
      } else if node.isLeftChild{
        node.rightChild!.parent = node.parent
        node.parent!.leftChild = node.leftChild
        node.balance = node.leftChild!.balance + 1
      } else {
        node.replace(node.rightChild!.key, node.rightChild!.payload, node.rightChild!.leftChild, node.rightChild!.rightChild)
      }
    }
  }
}

// MARK: - Balancing the tree

extension AVLTree {
  private func updateBalance(node: Node) {
    if node.balance > 1 || node.balance < -1 {
      rebalance(node)

    } else if let parent = node.parent {
      if node.isLeftChild {
        parent.balance += 1
      } else if node.isRightChild {
        parent.balance -= 1
      }
      if parent.balance != 0 {
        updateBalance(parent)
      }
    }
  }
 
  private func rebalance(node: Node) {
    if node.balance < 0 {
      if let child = node.rightChild where child.balance > 0 {
        rotateRight(child)
        rotateLeft(node)
      } else {
        rotateLeft(node)
      }
    } else if node.balance > 0 {
      if let child = node.leftChild where child.balance < 0 {
        rotateLeft(child)
        rotateRight(node)
      } else {
        rotateRight(node)
      }
    }
  }

  private func rotateRight(node: Node) {
    let newRoot = node.leftChild!
    node.leftChild = newRoot.rightChild
 
    if let child = newRoot.rightChild {
      child.parent = node
    }

    newRoot.parent = node.parent
    
    if node.isRoot {
      root = newRoot
    } else if node.isRightChild {
      node.parent!.rightChild = newRoot
    } else if node.isLeftChild {
      node.parent!.leftChild = newRoot
    }

    newRoot.rightChild = node
    node.parent = newRoot
    node.balance = node.balance + 1 - min(newRoot.balance, 0)
    newRoot.balance = newRoot.balance + 1 - max(node.balance, 0)
  }
  
  private func rotateLeft(node: Node) {
    let newRoot = node.rightChild!
    node.rightChild = newRoot.leftChild
    
    if let child = newRoot.leftChild {
      child.parent = node
    }
    
    newRoot.parent = node.parent
    
    if node.isRoot {
      root = newRoot
    } else if node.isLeftChild {
      node.parent!.leftChild = newRoot
    } else if node.isRightChild {
      node.parent!.rightChild = newRoot
    }

    newRoot.leftChild = node
    node.parent = newRoot
    node.balance = node.balance + 1 - min(newRoot.balance, 0)
    newRoot.balance = newRoot.balance + 1 - max(node.balance, 0)
  }
}

// MARK: - Debugging

extension TreeNode: CustomDebugStringConvertible {
  public var debugDescription: String {
    var s = "key: \(key), payload: \(payload), balance: \(balance)"
    if let parent = parent {
      s += ", parent: \(parent.key)"
    }
    if let left = leftChild {
      s += ", left = [" + left.debugDescription + "]"
    }
    if let right = rightChild {
      s += ", right = [" + right.debugDescription + "]"
    }
    return s
  }
}

extension AVLTree: CustomDebugStringConvertible {
  public var debugDescription: String {
    if let root = root {
      return root.debugDescription
    } else {
      return "[]"
    }
  }
}

extension TreeNode: CustomStringConvertible {
  public var description: String {
    var s = ""
    if let left = leftChild {
      s += "(\(left.description)) <- "
    }
    s += "\(key)"
    if let right = rightChild {
      s += " -> (\(right.description))"
    }
    return s
  }
}

extension AVLTree: CustomStringConvertible {
  public var description: String {
    if let root = root {
      return root.description
    } else {
      return "[]"
    }
  }
}
