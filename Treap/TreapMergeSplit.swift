//
//  TreapMergeSplit.swift
//  TreapExample
//
//  Created by Robert Thompson on 7/27/15.
//  Copyright © 2015 Robert Thompson. All rights reserved.
//

import Foundation
public extension Treap {
    internal func split(key: Key) -> (left: Treap, right: Treap)
    {
        var current = self
        let val: Element
        if let newVal = self.get(key)
        {
            current = try! current.delete(key)
            val = newVal
        }
        else if case let .Node(_, newVal, _, _, _) = self
        {
            val = newVal
        }
        else
        {
            fatalError("No values in treap")
        }
        
        switch self {
        case .Node:
            if case let .Node(_, _, _, left, right) = current.set(key, val: val, p: -1)
            {
                return (left: left, right: right)
            }
            else
            {
                return (left: .Empty, right: .Empty)
            }
        default:
            return (left: .Empty, right: .Empty)
        }
    }
    
    internal var leastKey: Key? {
        switch self {
        case .Empty:
            return nil
        case let .Node(key, _, _, .Empty, _):
            return key
        case let .Node(_, _, _, left, _):
            return left.leastKey
        }
    }
    
    internal var mostKey: Key? {
        switch self {
        case .Empty:
            return nil
        case let .Node(key, _, _, _, .Empty):
            return key
        case let .Node(_, _, _, _, right):
            return right.mostKey
        }
    }
}

internal func merge<Key: Comparable, Element>(left: Treap<Key, Element>, right: Treap<Key, Element>) -> Treap<Key, Element> {
    switch (left, right) {
    case (.Empty, _):
        return right
    case (_, .Empty):
        return left
        
    case let (.Node(leftKey, leftVal, leftP, leftLeft, leftRight), .Node(rightKey, rightVal, rightP, rightLeft, rightRight)):
        if leftP < rightP {
            return .Node(key: leftKey, val: leftVal, p: leftP, left: leftLeft, right: merge(leftRight, right: right))
        }
        else
        {
            return .Node(key: rightKey, val: rightVal, p: rightP, left: merge(rightLeft, right: left), right: rightRight)
        }
    default:
        break
    }
    return .Empty
}

extension Treap: CustomStringConvertible
{
    public var description: String {
        get {
            return Treap.descHelper(self, indent: 0)
        }
    }
    
    private static func descHelper(treap: Treap<Key, Element>, indent: Int) -> String
    {
        if case let .Node(key, value, priority, left, right) = treap {
            var result = ""
            let tabs = String(count: indent, repeatedValue: Character("\t"))
            
            result += descHelper(left, indent: indent + 1)
            result += "\n" + tabs + "\(key), \(value), \(priority)\n"
            result += descHelper(right, indent: indent + 1)
            
            return result
        }
        else
        {
            return ""
        }
    }
}