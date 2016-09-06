// The MIT License (MIT)

// Copyright (c) 2016 Viktor Szilárd Simkó (aqviktor[at]gmail.com)

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

/*
 *  B-Tree
 *
 *  A B-Tree is a self-balancing search tree, in which nodes can have more than two children.
 */

// MARK: - BTreeNode class

class BTreeNode<Key: Comparable, Value> {
  /**
   * The tree that owns the node.
   */
  unowned var owner: BTree<Key, Value>
  
  fileprivate var keys = [Key]()
  fileprivate var values = [Value]()
  var children: [BTreeNode]?
  
  var isLeaf: Bool {
    return children == nil
  }
  
  var numberOfKeys: Int {
    return keys.count
  }
  
  init(owner: BTree<Key, Value>) {
    self.owner = owner
  }
  
  convenience init(owner: BTree<Key, Value>, keys: [Key],
                   values: [Value], children: [BTreeNode]? = nil) {
    self.init(owner: owner)
    self.keys += keys
    self.values += values
    self.children = children
  }
}

// MARK: BTreeNode extesnion: Searching

extension BTreeNode {
  
  /**
   *  Returns the value for a given `key`, returns nil if the `key` is not found.
   *  
   *  - Parameters:
   *    - key: the key of the value to be returned
   */
  func value(for key: Key) -> Value? {
    var index = keys.startIndex
    
    while (index + 1) < keys.endIndex && keys[index] < key {
      index = (index + 1)
    }
    
    if key == keys[index] {
      return values[index]
    } else if key < keys[index] {
      return children?[index].value(for: key)
    } else {
      return children?[(index + 1)].value(for: key)
    }
  }
}

// MARK: BTreeNode extension: Travelsals

extension BTreeNode {
  
  /**
   *  Traverses the keys in order, executes `process` for every key.
   * 
   *  - Parameters:
   *    - process: the closure to be executed for every key
   */
  func traverseKeysInOrder(_ process: (Key) -> Void) {
    for i in 0..<numberOfKeys {
      children?[i].traverseKeysInOrder(process)
      process(keys[i])
    }
    
    children?.last?.traverseKeysInOrder(process)
  }
}

// MARK: BTreeNode extension: Insertion

extension BTreeNode {
  
  /**
   *  Inserts `value` for `key` to the node, or to one if its descendants.
   *  
   *  - Parameters:
   *    - value: the value to be inserted for `key`
   *    - key: the key for the `value`
   */
  func insert(_ value: Value, for key: Key) {
    var index = keys.startIndex
    
    while index < keys.endIndex && keys[index] < key {
      index = (index + 1)
    }
    
    if index < keys.endIndex && keys[index] == key {
      values[index] = value
      return
    }
    
    if isLeaf {
      keys.insert(key, at: index)
      values.insert(value, at: index)
      owner.numberOfKeys += 1
    } else {
      children![index].insert(value, for: key)
      if children![index].numberOfKeys > owner.order * 2 {
        split(child: children![index], atIndex: index)
      }
    }
  }
  
  /**
   *  Splits `child` at `index`.
   *  The key-value pair at `index` gets moved up to the parent node,
   *  or if there is not an parent node, then a new parent node is created.
   *  
   *  - Parameters:
   *    - child: the child to be split
   *    - index: the index of the key, which will be moved up to the parent
   */
  private func split(child: BTreeNode, atIndex index: Int) {
    let middleIndex = child.numberOfKeys / 2
    keys.insert(child.keys[middleIndex], at: index)
    values.insert(child.values[middleIndex], at: index)
    child.keys.remove(at: middleIndex)
    child.values.remove(at: middleIndex)
    
    let rightSibling = BTreeNode(
      owner: owner,
      keys: Array(child.keys[child.keys.indices.suffix(from: middleIndex)]),
      values: Array(child.values[child.values.indices.suffix(from: middleIndex)])
    )
    child.keys.removeSubrange(child.keys.indices.suffix(from: middleIndex))
    child.values.removeSubrange(child.values.indices.suffix(from: middleIndex))
    
    children!.insert(rightSibling, at: (index + 1))
    
    if child.children != nil {
      rightSibling.children = Array(
        child.children![child.children!.indices.suffix(from: (middleIndex + 1))]
      )
      child.children!.removeSubrange(child.children!.indices.suffix(from: (middleIndex + 1)))
    }
  }
}

// MARK: BTreeNode extension: Removal

/**
 *  An enumeration to indicate a node's position according to another node.
 *  
 *  Possible values:
 *    - left
 *    - right
 */
private enum BTreeNodePosition {
  case left
  case right
}

extension BTreeNode {
  private var inorderPredecessor: BTreeNode {
    if isLeaf {
      return self
    } else {
      return children!.last!.inorderPredecessor
    }
  }
  
  /**
   *  Removes `key` and the value associated with it from the node
   *  or one of its descendants.
   *  
   *  - Parameters:
   *    - key: the key to be removed
   */
  func remove(_ key: Key) {
    var index = keys.startIndex
    
    while (index + 1) < keys.endIndex && keys[index] < key {
      index = (index + 1)
    }
    
    if keys[index] == key {
      if isLeaf {
        keys.remove(at: index)
        values.remove(at: index)
        owner.numberOfKeys -= 1
      } else {
        let predecessor = children![index].inorderPredecessor
        keys[index] = predecessor.keys.last!
        values[index] = predecessor.values.last!
        children![index].remove(keys[index])
        if children![index].numberOfKeys < owner.order {
          fix(childWithTooFewKeys: children![index], atIndex: index)
        }
      }
    } else if key < keys[index] {
      // We should go to left child...
      
      if let leftChild = children?[index] {
        leftChild.remove(key)
        if leftChild.numberOfKeys < owner.order {
          fix(childWithTooFewKeys: leftChild, atIndex: index)
        }
      } else {
        print("The key:\(key) is not in the tree.")
      }
    } else {
      // We should go to right child...
      
      if let rightChild = children?[(index + 1)] {
        rightChild.remove(key)
        if rightChild.numberOfKeys < owner.order {
          fix(childWithTooFewKeys: rightChild, atIndex: (index + 1))
        }
      } else {
        print("The key:\(key) is not in the tree")
      }
    }
  }
  
  /**
   *  Fixes `childWithTooFewKeys` by either moving a key to it from 
   *  one of its neighbouring nodes, or by merging.
   *
   *  - Precondition:
   *    `childWithTooFewKeys` must have less keys than the order of the tree.
   *
   *  - Parameters:
   *    - child: the child to be fixed
   *    - index: the index of the child to be fixed in the current node
   */
  private func fix(childWithTooFewKeys child: BTreeNode, atIndex index: Int) {
    
    if (index - 1) >= 0 && children![(index - 1)].numberOfKeys > owner.order {
      move(keyAtIndex: (index - 1), to: child, from: children![(index - 1)], at: .left)
    } else if (index + 1) < children!.count && children![(index + 1)].numberOfKeys > owner.order {
      move(keyAtIndex: index, to: child, from: children![(index + 1)], at: .right)
    } else if (index - 1) >= 0 {
      merge(child: child, atIndex: index, to: .left)
    } else {
      merge(child: child, atIndex: index, to: .right)
    }
  }
  
  /**
   *  Moves the key at the specified `index` from `node` to
   *  the `targetNode` at `position`
   *  
   *  - Parameters:
   *    - index: the index of the key to be moved in `node`
   *    - targetNode: the node to move the key into
   *    - node: the node to move the key from
   *    - position: the position of the from node relative to the targetNode
   */
  private func move(keyAtIndex index: Int, to targetNode: BTreeNode,
                                  from node: BTreeNode, at position: BTreeNodePosition) {
    switch position {
    case .left:
      targetNode.keys.insert(keys[index], at: targetNode.keys.startIndex)
      targetNode.values.insert(values[index], at: targetNode.values.startIndex)
      keys[index] = node.keys.last!
      values[index] = node.values.last!
      node.keys.removeLast()
      node.values.removeLast()
      if !targetNode.isLeaf {
        targetNode.children!.insert(node.children!.last!,
                                    at: targetNode.children!.startIndex)
        node.children!.removeLast()
      }
      
    case .right:
      targetNode.keys.insert(keys[index], at: targetNode.keys.endIndex)
      targetNode.values.insert(values[index], at: targetNode.values.endIndex)
      keys[index] = node.keys.first!
      values[index] = node.values.first!
      node.keys.removeFirst()
      node.values.removeFirst()
      if !targetNode.isLeaf {
        targetNode.children!.insert(node.children!.first!,
                                    at: targetNode.children!.endIndex)
        node.children!.removeFirst()
      }
    }
  }
  
  /**
   *  Merges `child` at `position` to the node at the `position`.
   *  
   *  - Parameters:
   *    - child: the child to be merged
   *    - index: the index of the child in the current node
   *    - position: the position of the node to merge into
   */
  private func merge(child: BTreeNode, atIndex index: Int, to position: BTreeNodePosition) {
    switch position {
    case .left:
      // We can merge to the left sibling
      
      children![(index - 1)].keys = children![(index - 1)].keys +
        [keys[(index - 1)]] + child.keys
      
      children![(index - 1)].values = children![(index - 1)].values +
        [values[(index - 1)]] + child.values
      
      keys.remove(at: (index - 1))
      values.remove(at: (index - 1))
      
      if !child.isLeaf {
        children![(index - 1)].children =
          children![(index - 1)].children! + child.children!
      }
      
    case .right:
      // We should merge to the right sibling
      
      children![(index + 1)].keys = child.keys + [keys[index]] +
        children![(index + 1)].keys
      
      children![(index + 1)].values = child.values + [values[index]] +
        children![(index + 1)].values
      
      keys.remove(at: index)
      values.remove(at: index)
      
      if !child.isLeaf {
        children![(index + 1)].children =
          child.children! + children![(index + 1)].children!
      }
    }
    children!.remove(at: index)
  }
}

// MARK: BTreeNode extension: Conversion

extension BTreeNode {
  /**
   *  Returns an array which contains the keys from the current node
   *  and its descendants in order.
   */
  var inorderArrayFromKeys: [Key] {
    var array = [Key] ()
    
    for i in 0..<numberOfKeys {
      if let returnedArray = children?[i].inorderArrayFromKeys {
        array += returnedArray
      }
      array += [keys[i]]
    }
    
    if let returnedArray = children?.last?.inorderArrayFromKeys {
      array += returnedArray
    }
    
    return array
  }
}

// MARK: BTreeNode extension: Description

extension BTreeNode: CustomStringConvertible {
  /**
   *  Returns a String containing the preorder representation of the nodes.
   */
  var description: String {
    var str = "\(keys)"
    
    if !isLeaf {
      for child in children! {
        str += child.description
      }
    }
    
    return str
  }
}

// MARK: - BTree class

public class BTree<Key: Comparable, Value> {
  /**
   *  The order of the B-Tree
   *
   *  The number of keys in every node should be in the [order, 2*order] range,
   *  except the root node which is allowed to contain less keys than the value of order.
   */
  public let order: Int
  
  /**
   *  The root node of the tree
   */
  var rootNode: BTreeNode<Key, Value>!
  
  fileprivate(set) public var numberOfKeys = 0
  
  /**
   *  Designated initializer for the tree
   *
   *  - Parameters:
   *    - order: The order of the tree.
   */
  public init?(order: Int) {
    guard order > 0 else {
      print("Order has to be greater than 0.")
      return nil
    }
    self.order = order
    rootNode = BTreeNode<Key, Value>(owner: self)
  }
}

// MARK: BTree extension: Travelsals

extension BTree {
  /**
   *  Traverses the keys in order, executes `process` for every key.
   *
   *  - Parameters:
   *    - process: the closure to be executed for every key
   */
  public func traverseKeysInOrder(_ process: (Key) -> Void) {
    rootNode.traverseKeysInOrder(process)
  }
}

// MARK: BTree extension: Subscript

extension BTree {
  /**
   *  Returns the value for a given `key`, returns nil if the `key` is not found.
   *
   *  - Parameters:
   *    - key: the key of the value to be returned
   */
  public subscript (key: Key) -> Value? {
    return value(for: key)
  }
}

// MARK: BTree extension: Value for Key

extension BTree {
  /**
   *  Returns the value for a given `key`, returns nil if the `key` is not found.
   *
   *  - Parameters:
   *    - key: the key of the value to be returned
   */
  public func value(for key: Key) -> Value? {
    guard rootNode.numberOfKeys > 0 else {
      return nil
    }
    
    return rootNode.value(for: key)
  }
}

// MARK: BTree extension: Insertion

extension BTree {
  /**
   *  Inserts the `value` for the `key` into the tree.
   *
   *  - Parameters:
   *    - value: the value to be inserted for `key`
   *    - key: the key for the `value`
   */
  public func insert(_ value: Value, for key: Key) {
    rootNode.insert(value, for: key)
    
    if rootNode.numberOfKeys > order * 2 {
      splitRoot()
    }
  }
  
  /**
   *  Splits the root node of the tree.
   *  
   *  - Precondition:
   *    The root node of the tree contains `order` * 2 keys.
   */
  private func splitRoot() {
    let middleIndexOfOldRoot = rootNode.numberOfKeys / 2
    
    let newRoot = BTreeNode<Key, Value>(
      owner: self,
      keys: [rootNode.keys[middleIndexOfOldRoot]],
      values: [rootNode.values[middleIndexOfOldRoot]],
      children: [rootNode]
    )
    rootNode.keys.remove(at: middleIndexOfOldRoot)
    rootNode.values.remove(at: middleIndexOfOldRoot)
    
    let newRightChild = BTreeNode<Key, Value>(
      owner: self,
      keys: Array(rootNode.keys[rootNode.keys.indices.suffix(from: middleIndexOfOldRoot)]),
      values: Array(rootNode.values[rootNode.values.indices.suffix(from: middleIndexOfOldRoot)])
    )
    rootNode.keys.removeSubrange(rootNode.keys.indices.suffix(from: middleIndexOfOldRoot))
    rootNode.values.removeSubrange(rootNode.values.indices.suffix(from: middleIndexOfOldRoot))
    
    if rootNode.children != nil {
      newRightChild.children = Array(
        rootNode.children![rootNode.children!.indices.suffix(from: (middleIndexOfOldRoot + 1))]
      )
      rootNode.children!.removeSubrange(
        rootNode.children!.indices.suffix(from: (middleIndexOfOldRoot + 1))
      )
    }
    
    newRoot.children!.append(newRightChild)
    rootNode = newRoot
  }
}

// MARK: BTree extension: Removal

extension BTree {
  /**
   *  Removes `key` and the value associated with it from the tree.
   *  
   *  - Parameters:
   *    - key: the key to remove
   */
  public func remove(_ key: Key) {
    guard rootNode.numberOfKeys > 0 else {
      return
    }
    
    rootNode.remove(key)
    
    if rootNode.numberOfKeys == 0 && !rootNode.isLeaf {
      rootNode = rootNode.children!.first!
    }
  }
}

// MARK: BTree extension: Conversion

extension BTree {
  /**
   *  The keys of the tree in order.
   */
  public var inorderArrayFromKeys: [Key] {
    return rootNode.inorderArrayFromKeys
  }
}

// MARK: BTree extension: Decription

extension BTree: CustomStringConvertible {
  /** 
   *  Returns a String containing the preorder representation of the nodes.
   */
  public var description: String {
    return rootNode.description
  }
}
