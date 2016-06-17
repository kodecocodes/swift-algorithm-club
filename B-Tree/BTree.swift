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
 B-Tree
	
 A B-Tree is a self-balancing search tree, in which nodes can have more than two children.
 */

// MARK: - BTreeNode class

class BTreeNode<Key: Comparable, Value> {
  unowned var ownerTree: BTree<Key, Value>
  
  private var keys = [Key]()
  var values = [Value]()
  var children: [BTreeNode]?
  
  var isLeaf: Bool {
    return children == nil
  }
  
  var numberOfKeys: Int {
    return keys.count
  }
  
  init(ownerTree: BTree<Key, Value>) {
    self.ownerTree = ownerTree
  }
  
  convenience init(ownerTree: BTree<Key, Value>, keys: [Key],
                   values: [Value], children: [BTreeNode]? = nil) {
    self.init(ownerTree: ownerTree)
    self.keys += keys
    self.values += values
    self.children = children
  }
}

// MARK: BTreeNode extesnion: Searching

extension BTreeNode {
 func valueForKey(key: Key) -> Value? {
    var index = keys.startIndex
    
    while index.successor() < keys.endIndex && keys[index] < key {
      index = index.successor()
    }
    
    if key == keys[index] {
      return values[index]
    } else if key < keys[index] {
      return children?[index].valueForKey(key)
    } else {
      return children?[index.successor()].valueForKey(key)
    }
  }
}

// MARK: BTreeNode extension: Travelsals

extension BTreeNode {
  func traverseKeysInOrder(@noescape process: Key -> Void) {
    for i in 0..<numberOfKeys {
      children?[i].traverseKeysInOrder(process)
      process(keys[i])
    }
    
    children?.last?.traverseKeysInOrder(process)
  }
}

// MARK: BTreeNode extension: Insertion

extension BTreeNode {
  func insertValue(value: Value, forKey key: Key) {
    var index = keys.startIndex
    
    while index < keys.endIndex && keys[index] < key {
      index = index.successor()
    }
    
    if index < keys.endIndex && keys[index] == key {
      values[index] = value
      return
    }
    
    if isLeaf {
      keys.insert(key, atIndex: index)
      values.insert(value, atIndex: index)
      ownerTree.numberOfKeys += 1
    } else {
      children![index].insertValue(value, forKey: key)
      if children![index].numberOfKeys > ownerTree.order * 2 {
        splitChild(children![index], atIndex: index)
      }
    }
  }
  
  private func splitChild(child: BTreeNode, atIndex index: Int) {
    let middleIndex = child.numberOfKeys / 2
    keys.insert(child.keys[middleIndex], atIndex: index)
    values.insert(child.values[middleIndex], atIndex: index)
    child.keys.removeAtIndex(middleIndex)
    child.values.removeAtIndex(middleIndex)
    
    let rightSibling = BTreeNode(
      ownerTree: ownerTree,
      keys: Array(child.keys[middleIndex..<child.keys.endIndex]),
      values: Array(child.values[middleIndex..<child.values.endIndex])
    )
    child.keys.removeRange(middleIndex..<child.keys.endIndex)
    child.values.removeRange(middleIndex..<child.values.endIndex)
    
    children!.insert(rightSibling, atIndex: index.successor())
    
    if child.children != nil {
      rightSibling.children = Array(
        child.children![middleIndex.successor()..<child.children!.endIndex]
      )
      child.children!.removeRange(middleIndex.successor()..<child.children!.endIndex)
    }
  }
}

// MARK: BTreeNode extension: Removal

private enum BTreeNodePosition {
  case Left
  case Right
}

extension BTreeNode {
  private var inorderPredecessor: BTreeNode {
    if isLeaf {
      return self
    } else {
      return children!.last!.inorderPredecessor
    }
  }
  
  func removeKey(key: Key) {
    var index = keys.startIndex
    
    while index.successor() < keys.endIndex && keys[index] < key {
      index = index.successor()
    }
    
    if keys[index] == key {
      if isLeaf {
        keys.removeAtIndex(index)
        values.removeAtIndex(index)
        ownerTree.numberOfKeys -= 1
      } else {
        let predecessor = children![index].inorderPredecessor
        keys[index] = predecessor.keys.last!
        values[index] = predecessor.values.last!
        children![index].removeKey(keys[index])
        if children![index].numberOfKeys < ownerTree.order {
          fixChildWithLessNodesThanOrder(children![index], atIndex: index)
        }
      }
    } else if key < keys[index] {
      // We should go to left child...
      
      if let leftChild = children?[index] {
        leftChild.removeKey(key)
        if leftChild.numberOfKeys < ownerTree.order {
          fixChildWithLessNodesThanOrder(leftChild, atIndex: index)
        }
      } else {
        print("The key:\(key) is not in the tree.")
      }
    } else {
      // We should go to right child...
      
      if let rightChild = children?[index.successor()] {
        rightChild.removeKey(key)
        if rightChild.numberOfKeys < ownerTree.order {
          fixChildWithLessNodesThanOrder(rightChild, atIndex: index.successor())
        }
      } else {
        print("The key:\(key) is not in the tree")
      }
    }
  }
  
  private func fixChildWithLessNodesThanOrder(child: BTreeNode, atIndex index: Int) {
    
    if index.predecessor() >= 0 &&
       children![index.predecessor()].numberOfKeys > ownerTree.order {
      
      moveKeyAtIndex(index.predecessor(), toNode: child,
                     fromNode: children![index.predecessor()], atPosition: .Left)
      
    } else if index.successor() < children!.count &&
              children![index.successor()].numberOfKeys > ownerTree.order {
      
      moveKeyAtIndex(index, toNode: child,
                     fromNode: children![index.successor()], atPosition: .Right)
      
    } else if index.predecessor() >= 0 {
      mergeChild(child, withIndex: index, toNodeAtPosition: .Left)
    } else {
      mergeChild(child, withIndex: index, toNodeAtPosition: .Right)
    }
  }
  
  private func moveKeyAtIndex(keyIndex: Int, toNode targetNode: BTreeNode,
                             fromNode: BTreeNode, atPosition position: BTreeNodePosition) {
    switch position {
    case .Left:
      targetNode.keys.insert(keys[keyIndex], atIndex: targetNode.keys.startIndex)
      targetNode.values.insert(values[keyIndex], atIndex: targetNode.values.startIndex)
      keys[keyIndex] = fromNode.keys.last!
      values[keyIndex] = fromNode.values.last!
      fromNode.keys.removeLast()
      fromNode.values.removeLast()
      if !targetNode.isLeaf {
        targetNode.children!.insert(fromNode.children!.last!,
                                    atIndex: targetNode.children!.startIndex)
        fromNode.children!.removeLast()
      }
      
    case .Right:
      targetNode.keys.insert(keys[keyIndex], atIndex: targetNode.keys.endIndex)
      targetNode.values.insert(values[keyIndex], atIndex: targetNode.values.endIndex)
      keys[keyIndex] = fromNode.keys.first!
      values[keyIndex] = fromNode.values.first!
      fromNode.keys.removeFirst()
      fromNode.values.removeFirst()
      if !targetNode.isLeaf {
        targetNode.children!.insert(fromNode.children!.first!,
                                    atIndex: targetNode.children!.endIndex)
        fromNode.children!.removeFirst()
      }
    }
  }
  
  private func mergeChild(child: BTreeNode, withIndex index: Int, toNodeAtPosition position: BTreeNodePosition) {
    switch position {
    case .Left:
      // We can merge to the left sibling
      
      children![index.predecessor()].keys = children![index.predecessor()].keys +
        [keys[index.predecessor()]] + child.keys
      
      children![index.predecessor()].values = children![index.predecessor()].values +
        [values[index.predecessor()]] + child.values
      
      keys.removeAtIndex(index.predecessor())
      values.removeAtIndex(index.predecessor())
      
      if !child.isLeaf {
        children![index.predecessor()].children =
          children![index.predecessor()].children! + child.children!
      }
      
    case .Right:
      // We should merge to the right sibling
      
      children![index.successor()].keys = child.keys + [keys[index]] +
        children![index.successor()].keys
      
      children![index.successor()].values = child.values + [values[index]] +
        children![index.successor()].values
      
      keys.removeAtIndex(index)
      values.removeAtIndex(index)
      
      if !child.isLeaf {
        children![index.successor()].children =
          child.children! + children![index.successor()].children!
      }
    }
    children!.removeAtIndex(index)
  }
}

// MARK: BTreeNode extension: Conversion

extension BTreeNode {
  func inorderArrayFromKeys() -> [Key] {
    var array = [Key] ()
    
    for i in 0..<numberOfKeys {
      if let returnedArray = children?[i].inorderArrayFromKeys() {
        array += returnedArray
      }
      array += [keys[i]]
    }
    
    if let returnedArray = children?.last?.inorderArrayFromKeys() {
      array += returnedArray
    }
    
    return array
  }
}

// MARK: BTreeNode extension: Description

extension BTreeNode: CustomStringConvertible {
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
   The order of the B-Tree
   
   The number of keys in every node should be in the [order, 2*order] range,
   except the root node which is allowed to contain less keys than the value of order.
   */
  public let order: Int
  
  /// The root node of the tree
  var rootNode: BTreeNode<Key, Value>!
  
  private(set) public var numberOfKeys = 0
  
  /**
   Designated initializer for the tree
   
   - parameters:
   - order: The order of the tree.
   */
  public init?(order: Int) {
    guard order > 0 else {
      print("Order has to be greater than 0.")
      return nil
    }
    self.order = order
    rootNode = BTreeNode<Key, Value>(ownerTree: self)
  }
}

// MARK: BTree extension: Travelsals

extension BTree {
  public func traverseKeysInOrder(@noescape process: Key -> Void) {
    rootNode.traverseKeysInOrder(process)
  }
}

// MARK: BTree extension: Subscript

extension BTree {
  public subscript (key: Key) -> Value? {
    return valueForKey(key)
  }
}

// MARK: BTree extension: Value for Key

extension BTree {
  public func valueForKey(key: Key) -> Value? {
    guard rootNode.numberOfKeys > 0 else {
      return nil
    }
    
    return rootNode.valueForKey(key)
  }
}

// MARK: BTree extension: Insertion

extension BTree {
  public func insertValue(value: Value, forKey key: Key) {
    rootNode.insertValue(value, forKey: key)
    
    if rootNode.numberOfKeys > order * 2 {
      splitRoot()
    }
  }
  
  private func splitRoot() {
    let middleIndexOfOldRoot = rootNode.numberOfKeys / 2
    
    let newRoot = BTreeNode<Key, Value>(
      ownerTree: self,
      keys: [rootNode.keys[middleIndexOfOldRoot]],
      values: [rootNode.values[middleIndexOfOldRoot]],
      children: [rootNode]
    )
    rootNode.keys.removeAtIndex(middleIndexOfOldRoot)
    rootNode.values.removeAtIndex(middleIndexOfOldRoot)
    
    let newRightChild = BTreeNode<Key, Value>(
      ownerTree: self,
      keys: Array(rootNode.keys[middleIndexOfOldRoot..<rootNode.keys.endIndex]),
      values: Array(rootNode.values[middleIndexOfOldRoot..<rootNode.values.endIndex])
    )
    rootNode.keys.removeRange(middleIndexOfOldRoot..<rootNode.keys.endIndex)
    rootNode.values.removeRange(middleIndexOfOldRoot..<rootNode.values.endIndex)
    
    if rootNode.children != nil {
      newRightChild.children = Array(
        rootNode.children![middleIndexOfOldRoot.successor()..<rootNode.children!.endIndex]
      )
      rootNode.children!.removeRange(
        middleIndexOfOldRoot.successor()..<rootNode.children!.endIndex
      )
    }
    
    newRoot.children!.append(newRightChild)
    rootNode = newRoot
  }
}

// MARK: BTree extension: Removal

extension BTree {
  public func removeKey(key: Key) {
    guard rootNode.numberOfKeys > 0 else {
      return
    }
    
    rootNode.removeKey(key)
    
    if rootNode.numberOfKeys == 0 && !rootNode.isLeaf {
      rootNode = rootNode.children!.first!
    }
  }
}

// MARK: BTree extension: Conversion

extension BTree {
  public func inorderArrayFromKeys() -> [Key] {
    return rootNode.inorderArrayFromKeys()
  }
}

// MARK: BTree extension: Decription

extension BTree: CustomStringConvertible {
  // Returns a String containing the preorder representation of the nodes
  public var description: String {
    return rootNode.description
  }
}
