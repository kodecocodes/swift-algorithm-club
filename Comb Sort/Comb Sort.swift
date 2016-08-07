//  Comb Sort.swift
//  Comb Sort
//
//  Created by Stephen.Rutstein on 7/16/16.
//  Copyright © 2016 Stephen.Rutstein. All rights reserved.
//

import Foundation

func combSort (input: [Int]) -> [Int] {
    var copy: [Int] = input
    var gap = copy.count
    let shrink = 1.3
    
    while gap > 1 {
        gap = (Int)(Double(gap) / shrink)
        if gap < 1 {
            gap = 1
        }
        
        var index = 0
        while !(index + gap >= copy.count) {
            if copy[index] > copy[index + gap] {
                swap(&copy[index], &copy[index + gap])
            }
            index += 1
        }
    }
    return copy
}

func swap (inout a: Int, inout b: Int) {
    let temp = a
    a = b
    b = temp
}
