//
//  ShellSortExample.swift
//  
//
//  Created by Cheer on 2017/2/26.
//
//

import Foundation

public func shellSort(_ list : inout [Int])
{
    var sublistCount = list.count / 2
    
    while sublistCount > 0
    {
        for index in 0..<arr.count{
            
            guard index + sublistCount < arr.count else { break }
            
            if arr[index] > arr[index + sublistCount]{
                swap(&arr[index], &arr[index + sublistCount])
            }
            
            guard sublistCount == 1 && index > 0 else { continue }
            
            if arr[index - 1] > arr[index]{
                swap(&arr[index - 1], &arr[index])
            }
        }
        sublistCount = sublistCount / 2
    }
}
