//: Playground - noun: a place where people can play

import Cocoa
import Foundation

let treeOfStrings = TernarySearchTree<String>()
let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

//Random string generator from:
//http://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift/26845710
func randomAlphaNumericString(length: Int) -> String {
    let allowedCharsCount = UInt32(allowedChars.characters.count)
    var randomString = ""

    for _ in (0..<length) {
        let randomNum = Int(arc4random_uniform(allowedCharsCount))
        let newCharacter = allowedChars[allowedChars.startIndex.advancedBy(randomNum)]
        randomString += String(newCharacter)
    }

    return randomString
}

var testStrings: [(key: String, data: String)] = []
let testCount = 30
for _ in (1...testCount) {
    let randomLength = Int(arc4random_uniform(10))
    let key = randomAlphaNumericString(randomLength)
    let data = randomAlphaNumericString(randomLength)
//    print("Key: \(key) Data: \(data)")

    if key != "" && data != "" {
        testStrings.append((key, data))
        treeOfStrings.insert(data, withKey: key)
    }
}

for aTest in testStrings {
    let data = treeOfStrings.find(aTest.key)

    if data == nil {
        print("TEST FAILED. Key: \(aTest.key) Data: \(aTest.data)")
    }
    if data != aTest.data {
        print("TEST FAILED. Key: \(aTest.key) Data: \(aTest.data)")
    }
}

var testNums: [(key: String, data: Int)] = []
let treeOfInts = TernarySearchTree<Int>()
for _ in (1...testCount) {
    let randomNum = Int(arc4random_uniform(UInt32.max))
    let randomLength = Int(arc4random_uniform(10))
    let key = randomAlphaNumericString(randomLength)

    if key != "" {
        testNums.append((key, randomNum))
        treeOfInts.insert(randomNum, withKey: key)
    }
}

for aTest in testNums {
    let data = treeOfInts.find(aTest.key)
    if data == nil {
        print("TEST FAILED. Key: \(aTest.key) Data: \(aTest.data)")
    }
    if data != aTest.data {
        print("TEST FAILED. Key: \(aTest.key) Data: \(aTest.data)")
    }
}
