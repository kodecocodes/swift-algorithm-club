//: Playground - noun: a place where people can play
import Foundation

let shortestEditDistance: ([String], [String]) -> Int = MyersDifferenceAlgorithm.calculateShortestEditDistance(from:to:)

/***
 All elements are same, so any scripts do not need.
 So, the edit distance is 0
 ***/
shortestEditDistance(["1", "2", "3"], ["1", "2", "3"])

/***
 Last element "3" should be inserted.
 So, the edit distance is 1
 ***/
shortestEditDistance(["1", "2"], ["1", "2", "3"])

/***
 First, remove "1", then insert "1" after "2".
 So, the edit distance is 2
***/
shortestEditDistance(["1", "2", "3"], ["2", "1", "3"])
