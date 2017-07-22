//
//  RateLimiter.swift
//
//
//  Created by Kai Chen on 7/22/17.
//
//

import Foundation

public class RateCounter {
    private var count: [Int: Int] = [:]
    
    public init() {}
    
    public func hit(_ timestamp: Int) {
        guard let c = count[timestamp] else {
            count[timestamp] = 1
            return
        }
        
        count[timestamp] = c + 1
    }
    
    public func getCount(_ timestamp: Int) -> Int {
        let beg = timestamp - 300 + 1
        let end = timestamp
        
        var totalCount = 0
        for (key, val) in count {
            if beg <= key && key <= end {
                totalCount += val
            }
        }
        
        return totalCount
    }
}

public class RateCounterWithClean {
    private var count: [Int: Int] = [:]
    
    public init() {}
    
    public func hit(_ timestamp: Int) {
        guard let c = count[timestamp] else {
            count[timestamp] = 1
            return
        }
        
        count[timestamp] = c + 1
    }
    
    public func getCount(_ timestamp: Int) -> Int {
        let beg = timestamp - 300 + 1
        let end = timestamp
        
        var totalCount = 0
        var removedKeys: [Int] = []
        for (key, val) in count {
            if key < beg {
                removedKeys.append(key)
                continue
            }
            
            if key <= end {
                totalCount += val
            }
        }
        
        clean(removedKeys)
        
        return totalCount
    }
    
    private func clean(_ keys: [Int]) {
        for key in keys {
            count.removeValue(forKey: key)
        }
    }
}

public class RateCounterByArray {
    private var count = Array(repeating: 0, count: 300)
    private var keys = Array(repeating: -1, count: 300)
    
    public init() {}
    
    public func hit(_ timestamp: Int) {
        let index = timestamp % 300
        
        if keys[index] == timestamp {
            count[index] += 1
        } else {
            keys[index] = timestamp
            count[index] = 1
        }
    }
    
    public func getCount(_ timestamp: Int) -> Int {
        let beg = timestamp - 300 + 1
        let end = timestamp
        
        var totalCount = 0
        
        for i in 0..<300 {
            let key = keys[i]
            
            if beg <= key && key <= end {
                totalCount += count[i]
            }
        }
        
        return totalCount
    }
}
