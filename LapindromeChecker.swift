//
//  LapindromeChecker.swift
//
//
//  Created by Guillermo Martinez Espina on 11/12/18.
//
import Foundation

public func checkIfLapindrome(StringToCheck stringToCheck: String) -> String {
    
    let stringLength = stringToCheck.count
    var result = "String: \(stringToCheck) is lapindrome"
    
    if stringLength%2 != 0 {
        result = "String: \(stringToCheck) is not lapindrome"
    }
    
    let firstHalfIndex = stringToCheck.index(stringToCheck.startIndex, offsetBy: stringLength/2-1)
    let secondHalfIndex = stringToCheck.index(stringToCheck.startIndex, offsetBy: stringLength/2)
    
    let firstHalf = String(stringToCheck[...firstHalfIndex])
    let secondHalf = String(stringToCheck[secondHalfIndex...])
    
    if firstHalf != secondHalf {
        var firstHalfDictionary: Dictionary<Character, Int> = [:]
        var secondHalfDictionary: Dictionary<Character, Int> = [:]
        for characterFirstHalf in firstHalf {
            firstHalfDictionary[characterFirstHalf] = firstHalfDictionary[characterFirstHalf] == nil ? 1 : firstHalfDictionary[characterFirstHalf]! + 1
        }
        for characterSecondHalf in secondHalf {
            secondHalfDictionary[characterSecondHalf] = secondHalfDictionary[characterSecondHalf] == nil ? 1 : secondHalfDictionary[characterSecondHalf]! + 1
        }
        
        for (character, repetitions) in firstHalfDictionary {
            if secondHalfDictionary[character] == nil || secondHalfDictionary[character] != repetitions {
                result = "String: \(stringToCheck) is not lapindrome"
            }
        }
    }
    
    return result
}
