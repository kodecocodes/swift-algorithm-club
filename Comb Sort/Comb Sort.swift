//  Comb Sort.swift
//  Comb Sort
//
//  Created by Stephen.Rutstein on 7/16/16.
//  Copyright © 2016 Stephen.Rutstein. All rights reserved.
//

import Foundation

public func combSort<T: Comparable>(_ input: [T]) -> [T] {        
    var copy = input
    var gap = copy.count
    var done = false

    while gap > 1 || !done {
        gap = max(gap * 10 / 13, 1)
        done = true        
        for index in 0 ..< copy.count - gap {
            if copy[index] > copy[index + gap] {
                copy.swapAt(index, index + gap)
                done = false
            }
        }
    }

    return copy
}

fileprivate func swap<T: Comparable>(a: inout T, b: inout T) {
    let temp = a
    a = b
    b = temp
}
