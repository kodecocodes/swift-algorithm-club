//
//  PrefixHashTable.swift
//  
//
//  Created by Kai Chen on 7/23/17.
//
//

import Foundation

public class PrefixHashTable {
    private var prefixWords: [String: [String]] = [:]
    
    public init(_ words: [String]) {
        constructPrefixWords(words)
    }
    
    public func find(_ prefix: String) -> [String]? {
        return prefixWords[prefix]
    }
    
    private func constructPrefixWords(_ words: [String]) {
        for word in words {
            for end in 0..<word.characters.count {
                let endIndex = word.index(word.startIndex, offsetBy: end)
                let prefix = word[word.startIndex...endIndex]
                if prefixWords[prefix] == nil {
                    prefixWords[prefix] = []
                }
                prefixWords[prefix]?.append(word)
            }
        }
    }
}
