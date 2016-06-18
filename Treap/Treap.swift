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
    case Empty
    case Node(key: Key, val: Element, p: Int, left: Treap, right: Treap)

    public init() {
        self = .Empty
    }

    internal func get(key: Key) -> Element? {
        switch self {
        case .Empty:
            return nil
        case let .Node(treeKey, val, _, _, _) where treeKey == key:
            return val
        case let .Node(treeKey, _, _, left, _) where key < treeKey:
            return left.get(key)
        case let .Node(treeKey, _, _, _, right) where key > treeKey:
            return right.get(key)
        default:
            return nil
        }
    }

    public func contains(key: Key) -> Bool {
        switch self {
        case .Empty:
            return false
        case let .Node(treeKey, _, _, _, _) where treeKey == key:
            return true
        case let .Node(treeKey, _, _, left, _) where key < treeKey:
            return left.contains(key)
        case let .Node(treeKey, _, _, _, right) where key > treeKey:
            return right.contains(key)
        default:
            return false
        }
    }

    public var depth: Int {
        get {
            switch self {
            case .Empty:
                return 0
            case let .Node(_, _, _, left, .Empty):
                return 1 + left.depth
            case let .Node(_, _, _, .Empty, right):
                return 1 + right.depth
            case let .Node(_, _, _, left, right):
                let leftDepth = left.depth
                let rightDepth = right.depth
                return 1 + max(leftDepth, rightDepth)
            }

        }
    }

    public var count: Int {
        get {
            return Treap.countHelper(self)
        }
    }

    private static func countHelper(treap: Treap<Key, Element>) -> Int {
        if case let .Node(_, _, _, left, right) = treap {
            return countHelper(left) + 1 + countHelper(right)
        }

        return 0
    }
}

internal func leftRotate<Key: Comparable, Element>(tree: Treap<Key, Element>) -> Treap<Key, Element> {
    if case let .Node(key, val, p, .Node(leftKey, leftVal, leftP, leftLeft, leftRight), right) = tree {
        return .Node(key: leftKey, val: leftVal, p: leftP, left: leftLeft,
                     right: Treap.Node(key: key, val: val, p: p, left: leftRight, right: right))
    } else {
        return .Empty
    }
}

internal func rightRotate<Key: Comparable, Element>(tree: Treap<Key, Element>) -> Treap<Key, Element> {
    if case let .Node(key, val, p, left, .Node(rightKey, rightVal, rightP, rightLeft, rightRight)) = tree {
        return .Node(key: rightKey, val: rightVal, p: rightP,
                     left: Treap.Node(key: key, val: val, p: p, left: left, right: rightLeft), right: rightRight)
    } else {
        return .Empty
    }
}

public extension Treap {
    internal func set(key: Key, val: Element, p: Int = Int(arc4random())) -> Treap {
        switch self {
        case .Empty:
            return .Node(key: key, val: val, p: p, left: .Empty, right: .Empty)
        case let .Node(nodeKey, nodeVal, nodeP, left, right) where key != nodeKey:
            return insertAndBalance(nodeKey, nodeVal, nodeP, left, right, key, val, p)
        case let .Node(nodeKey, _, nodeP, left, right) where key == nodeKey:
            return .Node(key: key, val: val, p: nodeP, left: left, right: right)
        default: // should never happen
            return .Empty
        }

    }

    private func insertAndBalance(nodeKey: Key, _ nodeVal: Element, _ nodeP: Int, _ left: Treap,
                                  _ right: Treap, _ key: Key, _ val: Element, _ p: Int) -> Treap {
        let newChild: Treap<Key, Element>
        let newNode: Treap<Key, Element>
        let rotate: (Treap) -> Treap
        if key < nodeKey {
            newChild = left.set(key, val: val, p: p)
            newNode = .Node(key: nodeKey, val: nodeVal, p: nodeP, left: newChild, right: right)
            rotate = leftRotate
        } else if key > nodeKey {
            newChild = right.set(key, val: val, p: p)
            newNode = .Node(key: nodeKey, val: nodeVal, p: nodeP, left: left, right: newChild)
            rotate = rightRotate
        } else {
            // It should be impossible to reach here
            newChild = .Empty
            newNode = .Empty
            return newNode
        }

        if case let .Node(_, _, newChildP, _, _) = newChild where newChildP < nodeP {
            return rotate(newNode)
        } else {
            return newNode
        }
    }

    internal func delete(key: Key) throws -> Treap {
        switch self {
        case .Empty:
            throw NSError(domain: "com.wta.treap.errorDomain", code: -1, userInfo: nil)
        case let .Node(nodeKey, val, p, left, right) where key < nodeKey:
                return try Treap.Node(key: nodeKey, val: val, p: p, left: left.delete(key), right: right)
        case let .Node(nodeKey, val, p, left, right) where key > nodeKey:
                return try Treap.Node(key: nodeKey, val: val, p: p, left: left, right: right.delete(key))
        case let .Node(_, _, _, left, right):
                return merge(left, right: right)
        }
    }
}
