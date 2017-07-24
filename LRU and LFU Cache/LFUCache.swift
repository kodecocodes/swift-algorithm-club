//
//  LFUCache.swift
//
//
//  Created by Kai Chen on 7/23/17.
//
//

import Foundation

public class LFUCache<KeyType: Hashable> {
    private let maxSize: Int
    private var cache: [KeyType: Any] = [:]
    private var priority: [Int: LinkedList<KeyType>] = [:] // Key: Frequency, Val: All Items at this frequency
    private var frequency: [KeyType: Int] = [:] // Key: Item, Val: Frequency
    private var key2node: [KeyType: LinkedList<KeyType>.LinkedListNode<KeyType>] = [:]
    
    public init(_ maxSize: Int) {
        self.maxSize = maxSize
    }
    
    public func get(_ key: KeyType) -> Any? {
        guard let val = cache[key], let priorityKey = frequency[key] else {
            return nil
        }
        
        remove(key)
        insert(key, val: val, priorityKey: priorityKey + 1)
        
        return val
    }
    
    public func set(_ key: KeyType, val: Any) {
        var priorityKey = 0
        
        if cache[key] != nil {
            remove(key)
            if let pk = frequency[key] {
                priorityKey = pk + 1
            } else {
                priorityKey = 0
            }
        } else if cache.count >= maxSize, let keyToRemove = getKeyToRemove() {
            remove(keyToRemove)
        }
        
        insert(key, val: val, priorityKey: priorityKey)
    }
    
    private func getKeyToRemove() -> KeyType? {
        let keys = priority.keys.sorted()
        
        var keyToRemove: KeyType? = nil
        for key in keys {
            if let list = priority[key] {
                if list.isEmpty {
                    priority.removeValue(forKey: key)
                } else {
                    if keyToRemove == nil {
                        keyToRemove = list.last?.value
                    }
                }
            }
        }
        
        return keyToRemove
    }
    
    private func remove(_ key: KeyType) {
        guard let node = key2node[key],
            let priorityKey = frequency[key],
            let list = priority[priorityKey] else {
                return
        }
        
        cache.removeValue(forKey: key)
        list.remove(node: node)
        frequency.removeValue(forKey: key)
        key2node.removeValue(forKey: key)
    }
    
    private func insert(_ key: KeyType, val: Any, priorityKey: Int = 0) {
        cache[key] = val
        if priority[priorityKey] == nil {
            priority[priorityKey] = LinkedList<KeyType>()
        }
        
        priority[priorityKey]?.insert(key, atIndex: 0)
        
        guard let first = priority[priorityKey]?.first else {
            return
        }
        
        key2node[key] = first
        frequency[key] = priorityKey
    }
}
