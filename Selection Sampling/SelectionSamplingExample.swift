//
//  Select.swift
//  
//
//  Created by Cheer on 2017/3/9.
//
//

import Foundation

func select<T>(from a: [T], count requested: Int) -> [T] {
    
    // if requested > a.count, will throw ==> fatal error: Index out of range
    
    if requested < a.count {
        var arr = a
        for i in 0..<requested {
            
            //arc4random_uniform(n) ==> the range is [0...n-1]
            //So: arc4random_uniform(UInt32(arr.count - i - 2)) + (i + 1) ==> [0...arr.count - (i + 1) - 1] + (i + 1) ==> the range is [(i + 1)...arr.count - 1]
            //Why start index is "(i + 1)"?  Because in "swap(&A,&B)", if A's index == B's index, will throw a error: "swapping a location with itself is not supported"
            
            let nextIndex = Int(arc4random_uniform(UInt32(arr.count - i - 2))) + (i + 1)
            swap(&arr[nextIndex], &arr[i])
        }
        return Array(arr[0..<requested])
    }
    
    if requested == a.count { return a }
    
    return [T]()
}
