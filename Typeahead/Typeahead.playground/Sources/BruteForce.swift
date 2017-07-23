//
//  BruteForce.swift
//  
//
//  Created by Kai Chen on 7/23/17.
//
//

import Foundation

public class BruteForce {
    
    private let words: [String]
    
    public init(_ words: [String]) {
        self.words = words
    }
    
    public func find(_ prefix: String) -> [String] {
        var ret: [String] = []
        
        for word in words {
            if word.hasPrefix(prefix) {
                ret.append(word)
            }
        }
        
        return ret
    }
}
