//
//  LinkedListCycle.swift
//  
//
//  Created by Kai Chen on 7/23/17.
//
//

import Foundation

public class LinkedListCycle1WithHash<T> {
    private let list: LinkedList<T>
    private var exist = Set<LinkedList<T>.LinkedListNode<T>>()
    
    public init(_ list: LinkedList<T>) {
        self.list = list
    }
    
    public func hasCycle() -> Bool {
        var node = list.first
        while node != nil {
            if exist.contains(node!) {
                return true
            }
            exist.insert(node!)
            node = node?.next
        }
        
        return false
    }
}

public class LinkedListCycle1With2Pointers<T> {
    private let list: LinkedList<T>
    
    public init(_ list: LinkedList<T>) {
        self.list = list
    }
    
    public func hasCycle() -> Bool {
        var p1 = list.first
        var p2 = list.first?.next
        
        while p1 != nil && p2 != nil {
            if p1! == p2! {
                return true
            }
            
            p1 = p1?.next
            p2 = p2?.next?.next
        }
        
        return false
    }
}

public class LinkedListCycle2WithHash<T> {
    private let list: LinkedList<T>
    private var exist = Set<LinkedList<T>.LinkedListNode<T>>()
    
    public init(_ list: LinkedList<T>) {
        self.list = list
    }
    
    public func meetPointer() -> LinkedList<T>.LinkedListNode<T>? {
        var node = list.first
        while node != nil {
            if exist.contains(node!) {
                return node
            }
            
            exist.insert(node!)
            node = node?.next
        }
        
        return nil
    }
}

public class LinkedListCycle2With2Pointers<T> {
    private let list: LinkedList<T>
    
    public init(_ list: LinkedList<T>) {
        self.list = list
    }
    
    public func meetPointer() -> LinkedList<T>.LinkedListNode<T>? {
        var p1 = list.first
        var p2 = list.first
        
        while p2 != nil {
            p1 = p1?.next
            p2 = p2?.next?.next
            
            if p1 == nil || p2 == nil {
                return nil
            }
            
            if p1! == p2! {
                break
            }
        }
        
        p1 = list.first
        while p1! != p2! {
            p1 = p1?.next
            p2 = p2?.next
        }
        
        return p1
    }
}
