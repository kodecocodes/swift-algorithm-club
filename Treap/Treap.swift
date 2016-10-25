//
//  Treap.swift
//  TreapExample
//
//  Created by Robert Thompson on 7/27/15.
//  Copyright © 2016 Robert Thompson
/* Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.*/

import Foundation

public indirect enum Treap<Key: Comparable, Element> {
  case empty
  case node(key: Key, val: Element, p: Int, left: Treap, right: Treap)
  
  public init() {
    self = .empty
  }
  
  internal func get(_ key: Key) -> Element? {
    switch self {
    case .empty:
      return nil
    case let .node(treeKey, val, _, _, _) where treeKey == key:
      return val
    case let .node(treeKey, _, _, left, _) where key < treeKey:
      return left.get(key)
    case let .node(treeKey, _, _, _, right) where key > treeKey:
      return right.get(key)
    default:
      return nil
    }
  }
  
  public func contains(_ key: Key) -> Bool {
    switch self {
    case .empty:
      return false
    case let .node(treeKey, _, _, _, _) where treeKey == key:
      return true
    case let .node(treeKey, _, _, left, _) where key < treeKey:
      return left.contains(key)
    case let .node(treeKey, _, _, _, right) where key > treeKey:
      return right.contains(key)
    default:
      return false
    }
  }
  
  public var depth: Int {
    get {
      switch self {
      case .empty:
        return 0
      case let .node(_, _, _, left, .empty):
        return 1 + left.depth
      case let .node(_, _, _, .empty, right):
        return 1 + right.depth
      case let .node(_, _, _, left, right):
        let leftDepth = left.depth
        let rightDepth = right.depth
        return 1 + leftDepth > rightDepth ? leftDepth : rightDepth
      }
      
    }
  }
  
  public var count: Int {
    get {
      return Treap.countHelper(self)
    }
  }
  
  fileprivate static func countHelper(_ treap: Treap<Key, Element>) -> Int {
    if case let .node(_, _, _, left, right) = treap {
      return countHelper(left) + 1 + countHelper(right)
    }
    
    return 0
  }
}

internal func leftRotate<Key: Comparable, Element>(_ tree: Treap<Key, Element>) -> Treap<Key, Element> {
  if case let .node(key, val, p, .node(leftKey, leftVal, leftP, leftLeft, leftRight), right) = tree {
    return .node(key: leftKey, val: leftVal, p: leftP, left: leftLeft,
                 right: Treap.node(key: key, val: val, p: p, left: leftRight, right: right))
  } else {
    return .empty
  }
}

internal func rightRotate<Key: Comparable, Element>(_ tree: Treap<Key, Element>) -> Treap<Key, Element> {
  if case let .node(key, val, p, left, .node(rightKey, rightVal, rightP, rightLeft, rightRight)) = tree {
    return .node(key: rightKey, val: rightVal, p: rightP,
                 left: Treap.node(key: key, val: val, p: p, left: left, right: rightLeft), right: rightRight)
  } else {
    return .empty
  }
}

public extension Treap {
  internal func set(key: Key, val: Element, p: Int = Int(arc4random())) -> Treap {
    switch self {
    case .empty:
      return .node(key: key, val: val, p: p, left: .empty, right: .empty)
    case let .node(nodeKey, nodeVal, nodeP, left, right) where key != nodeKey:
      return insertAndBalance(nodeKey, nodeVal, nodeP, left, right, key, val, p)
    case let .node(nodeKey, _, nodeP, left, right) where key == nodeKey:
      return .node(key: key, val: val, p: nodeP, left: left, right: right)
    default: // should never happen
      return .empty
    }
  }
  
  fileprivate func insertAndBalance(_ nodeKey: Key, _ nodeVal: Element, _ nodeP: Int, _ left: Treap,
                                    _ right: Treap, _ key: Key, _ val: Element, _ p: Int) -> Treap {
    let newChild: Treap<Key, Element>
    let newNode: Treap<Key, Element>
    let rotate: (Treap) -> Treap
    if key < nodeKey {
      newChild = left.set(key: key, val: val, p: p)
      newNode = .node(key: nodeKey, val: nodeVal, p: nodeP, left: newChild, right: right)
      rotate = leftRotate
    } else if key > nodeKey {
      newChild = right.set(key: key, val: val, p: p)
      newNode = .node(key: nodeKey, val: nodeVal, p: nodeP, left: left, right: newChild)
      rotate = rightRotate
    } else {
      // It should be impossible to reach here
      newChild = .empty
      newNode = .empty
      return newNode
    }
    
    if case let .node(_, _, newChildP, _, _) = newChild , newChildP < nodeP {
      return rotate(newNode)
    } else {
      return newNode
    }
  }
  
  internal func delete(key: Key) throws -> Treap {
    switch self {
    case .empty:
      throw NSError(domain: "com.wta.treap.errorDomain", code: -1, userInfo: nil)
    case let .node(nodeKey, val, p, left, right) where key < nodeKey:
      return try Treap.node(key: nodeKey, val: val, p: p, left: left.delete(key: key), right: right)
    case let .node(nodeKey, val, p, left, right) where key > nodeKey:
      return try Treap.node(key: nodeKey, val: val, p: p, left: left, right: right.delete(key: key))
    case let .node(_, _, _, left, right):
      return merge(left, right: right)
    }
  }
}
