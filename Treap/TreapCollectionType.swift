//
//  TreapCollectionType.swift
//  Treap
//
//  Created by Robert Thompson on 2/18/16.
//  Copyright © 2016 WillowTree, Inc. All rights reserved.
//

import Foundation

extension Treap: MutableCollectionType {
    public typealias Index = TreapIndex<Key>

    public subscript(index: TreapIndex<Key>) -> Element {
        get {
            guard let result = self.get(index.keys[index.keyIndex]) else {
                fatalError("Invalid index!")
            }

            return result
        }

        mutating set {
            let key = index.keys[index.keyIndex]
            self = self.set(key, val: newValue)
        }
    }

    public subscript(key: Key) -> Element? {
        get {
            return self.get(key)
        }

        mutating set {
            guard let value = newValue else {
                let _ = try? self.delete(key)
                return
            }

            self = self.set(key, val: value)
        }
    }

    public var startIndex: TreapIndex<Key> {
        return TreapIndex<Key>(keys: keys, keyIndex: 0)
    }

    public var endIndex: TreapIndex<Key> {
        let keys = self.keys
        return TreapIndex<Key>(keys: keys, keyIndex: keys.count)
    }

    private var keys: [Key] {
        var results: [Key] = []
        if case let .Node(key, _, _, left, right) = self {
            results.appendContentsOf(left.keys)
            results.append(key)
            results.appendContentsOf(right.keys)
        }

        return results
    }
}

public struct TreapIndex<Key: Comparable>: BidirectionalIndexType {
    private let keys: [Key]
    private let keyIndex: Int

    public func successor() -> TreapIndex {
        return TreapIndex(keys: keys, keyIndex: keyIndex + 1)
    }

    public func predecessor() -> TreapIndex {
        return TreapIndex(keys: keys, keyIndex: keyIndex - 1)
    }

    private init(keys: [Key] = [], keyIndex: Int = 0) {
        self.keys = keys
        self.keyIndex = keyIndex
    }
}

public func ==<Key: Comparable>(lhs: TreapIndex<Key>, rhs: TreapIndex<Key>) -> Bool {
    return lhs.keys == rhs.keys && lhs.keyIndex == rhs.keyIndex
}
