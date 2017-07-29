//
//  TreeSet.swift
//  
//
//  Created by Kai Chen on 7/28/17.
//
//

import Foundation

public struct TreeSet<T: Comparable> {
    private var tree: RedBlackTree<T>
    
    public init(_ isMultiset: Bool = false) {
        tree = RedBlackTree<T>(isMultiset)
    }
    
    public mutating func insert(_ element: T) {
        tree.insert(key: element)
    }
    
    public mutating func remove(_ element: T) {
        tree.delete(key: element)
    }
    
    public func contains(_ element: T) -> Bool {
        return tree.search(input: element) != nil
    }
    
    public func allElements() -> [T] {
        return tree.allElements()
    }
    
    public var count: Int {
        return tree.count()
    }
    
    public var isEmpty: Bool {
        return tree.isEmpty()
    }
}
