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

  var payload: Payload?

  fileprivate var key: Key
  internal var leftChild: Node?
  internal var rightChild: Node?
  fileprivate var height: Int
  weak fileprivate var parent: Node?

  public init(key: Key, payload: Payload?, leftChild: Node?, rightChild: Node?, parent: Node?, height: Int) {
    self.key = key
    self.payload = payload
    self.leftChild = leftChild
    self.rightChild = rightChild
    self.parent = parent
    self.height = height

    self.leftChild?.parent = self
    self.rightChild?.parent = self
  }

  public convenience init(key: Key, payload: Payload?) {
    self.init(key: key, payload: payload, leftChild: nil, rightChild: nil, parent: nil, height: 1)
  }

  public convenience init(key: Key) {
    self.init(key: key, payload: nil)
  }

  var isRoot: Bool {
    return parent == nil
  }

  var isLeaf: Bool {
    return rightChild == nil && leftChild == nil
  }

  var isLeftChild: Bool {
    return parent?.leftChild === self
  }

  var isRightChild: Bool {
    return parent?.rightChild === self
  }

  var hasLeftChild: Bool {
    return leftChild != nil
  }

  var hasRightChild: Bool {
    return rightChild != nil
  }

  var hasAnyChild: Bool {
    return leftChild != nil || rightChild != nil
  }

  var hasBothChildren: Bool {
    return leftChild != nil && rightChild != nil
  }
}

// MARK: - The AVL tree

open class AVLTree<Key: Comparable, Payload> {
  public typealias Node = TreeNode<Key, Payload>

  fileprivate(set) var root: Node?
  fileprivate(set) var size = 0

  public init() { }
}

// MARK: - Searching

extension TreeNode {
  public func minimum() -> TreeNode? {
    if let leftChild = self.leftChild {
      return leftChild.minimum()
    }
    return self
  }

  public func maximum() -> TreeNode? {
    if let rightChild = self.rightChild {
      return rightChild.maximum()
    }
    return self
  }
}

extension AVLTree {
  subscript(key: Key) -> Payload? {
    get { return search(input: key) }
    set { insert(key: key, payload: newValue) }
  }

  public func search(input: Key) -> Payload? {
    if let result = search(key: input, node: root) {
      return result.payload
    } else {
      return nil
    }
  }

  fileprivate func search(key: Key, node: Node?) -> Node? {
    if let node = node {
      if key == node.key {
        return node
      } else if key < node.key {
        return search(key: key, node: node.leftChild)
      } else {
        return search(key: key, node: node.rightChild)
      }
    }
    return nil
  }
}

// MARK: - Inserting new items

extension AVLTree {
  public func insert(key: Key, payload: Payload? = nil) {
    if let root = root {
      insert(input: key, payload: payload, node: root)
    } else {
      root = Node(key: key, payload: payload)
    }
    size += 1
  }

  private func insert(input: Key, payload: Payload?, node: Node) {
    if input < node.key {
      if let child = node.leftChild {
        insert(input: input, payload: payload, node: child)
      } else {
        let child = Node(key: input, payload: payload, leftChild: nil, rightChild: nil, parent: node, height: 1)
        node.leftChild = child
        balance(node: child)
      }
    } else {
      if let child = node.rightChild {
        insert(input: input, payload: payload, node: child)
      } else {
        let child = Node(key: input, payload: payload, leftChild: nil, rightChild: nil, parent: node, height: 1)
        node.rightChild = child
        balance(node: child)
      }
    }
  }
}

// MARK: - Balancing tree

extension AVLTree {
  fileprivate func updateHeightUpwards(node: Node?) {
    if let node = node {
      let lHeight = node.leftChild?.height ?? 0
      let rHeight = node.rightChild?.height ?? 0
      node.height = max(lHeight, rHeight) + 1
      updateHeightUpwards(node: node.parent)
    }
  }

  fileprivate func lrDifference(node: Node?) -> Int {
    let lHeight = node?.leftChild?.height ?? 0
    let rHeight = node?.rightChild?.height ?? 0
    return lHeight - rHeight
  }

  fileprivate func balance(node: Node?) {
    guard let node = node else {
      return
    }

    updateHeightUpwards(node: node.leftChild)
    updateHeightUpwards(node: node.rightChild)

    var nodes = [Node?](repeating: nil, count: 3)
    var subtrees = [Node?](repeating: nil, count: 4)
    let nodeParent = node.parent

    let lrFactor = lrDifference(node: node)
    if lrFactor > 1 {
      // left-left or left-right
      if lrDifference(node: node.leftChild) > 0 {
        // left-left
        nodes[0] = node
        nodes[2] = node.leftChild
        nodes[1] = nodes[2]?.leftChild

        subtrees[0] = nodes[1]?.leftChild
        subtrees[1] = nodes[1]?.rightChild
        subtrees[2] = nodes[2]?.rightChild
        subtrees[3] = nodes[0]?.rightChild
      } else {
        // left-right
        nodes[0] = node
        nodes[1] = node.leftChild
        nodes[2] = nodes[1]?.rightChild

        subtrees[0] = nodes[1]?.leftChild
        subtrees[1] = nodes[2]?.leftChild
        subtrees[2] = nodes[2]?.rightChild
        subtrees[3] = nodes[0]?.rightChild
      }
    } else if lrFactor < -1 {
      // right-left or right-right
      if lrDifference(node: node.rightChild) < 0 {
        // right-right
        nodes[1] = node
        nodes[2] = node.rightChild
        nodes[0] = nodes[2]?.rightChild

        subtrees[0] = nodes[1]?.leftChild
        subtrees[1] = nodes[2]?.leftChild
        subtrees[2] = nodes[0]?.leftChild
        subtrees[3] = nodes[0]?.rightChild
      } else {
        // right-left
        nodes[1] = node
        nodes[0] = node.rightChild
        nodes[2] = nodes[0]?.leftChild

        subtrees[0] = nodes[1]?.leftChild
        subtrees[1] = nodes[2]?.leftChild
        subtrees[2] = nodes[2]?.rightChild
        subtrees[3] = nodes[0]?.rightChild
      }
    } else {
      // Don't need to balance 'node', go for parent
      balance(node: node.parent)
      return
    }

    // nodes[2] is always the head

    if node.isRoot {
      root = nodes[2]
      root?.parent = nil
    } else if node.isLeftChild {
      nodeParent?.leftChild = nodes[2]
      nodes[2]?.parent = nodeParent
    } else if node.isRightChild {
      nodeParent?.rightChild = nodes[2]
      nodes[2]?.parent = nodeParent
    }

    nodes[2]?.leftChild = nodes[1]
    nodes[1]?.parent = nodes[2]
    nodes[2]?.rightChild = nodes[0]
    nodes[0]?.parent = nodes[2]

    nodes[1]?.leftChild = subtrees[0]
    subtrees[0]?.parent = nodes[1]
    nodes[1]?.rightChild = subtrees[1]
    subtrees[1]?.parent = nodes[1]

    nodes[0]?.leftChild = subtrees[2]
    subtrees[2]?.parent = nodes[0]
    nodes[0]?.rightChild = subtrees[3]
    subtrees[3]?.parent = nodes[0]

    updateHeightUpwards(node: nodes[1])    // Update height from left
    updateHeightUpwards(node: nodes[0])    // Update height from right

    balance(node: nodes[2]?.parent)
  }
}

// MARK: - Displaying tree

extension AVLTree {
  fileprivate func display(node: Node?, level: Int) {
    if let node = node {
      display(node: node.rightChild, level: level + 1)
      print("")
      if node.isRoot {
        print("Root -> ", terminator: "")
      }
      for _ in 0..<level {
        print("        ", terminator:  "")
      }
      print("(\(node.key):\(node.height))", terminator: "")
      display(node: node.leftChild, level: level + 1)
    }
  }

  public func display(node: Node) {
    display(node: node, level: 0)
    print("")
  }
}

// MARK: - Delete node

extension AVLTree {
  public func delete(key: Key) {
    if size == 1 {
      root = nil
      size -= 1
    } else if let node = search(key: key, node: root) {
      delete(node: node)
      size -= 1
    }
  }

  private func delete(node: Node) {
    if node.isLeaf {
      // Just remove and balance up
      if let parent = node.parent {
        guard node.isLeftChild || node.isRightChild else {
          // just in case
          fatalError("Error: tree is invalid.")
        }

        if node.isLeftChild {
          parent.leftChild = nil
        } else if node.isRightChild {
          parent.rightChild = nil
        }

        balance(node: parent)
      } else {
        // at root
        root = nil
      }
    } else {
      // Handle stem cases
      if let replacement = node.leftChild?.maximum() , replacement !== node {
        node.key = replacement.key
        node.payload = replacement.payload
        delete(node: replacement)
      } else if let replacement = node.rightChild?.minimum() , replacement !== node {
        node.key = replacement.key
        node.payload = replacement.payload
        delete(node: replacement)
      }
    }
  }
}


// MARK: - Debugging

extension TreeNode: CustomDebugStringConvertible {
  public var debugDescription: String {
    var s = "key: \(key), payload: \(payload), height: \(height)"
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
