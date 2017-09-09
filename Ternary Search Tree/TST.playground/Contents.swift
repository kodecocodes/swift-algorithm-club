//: Playground - noun: a place where people can play

import Cocoa
import Foundation

// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

let treeOfStrings = TernarySearchTree<String>()

var testStrings: [(key: String, data: String)] = []
let testCount = 30
for _ in (1...testCount) {
    let randomLength = Int(arc4random_uniform(10))
    let key = Utils.shared.randomAlphaNumericString(withLength: randomLength)
    let data = Utils.shared.randomAlphaNumericString(withLength: randomLength)
//    print("Key: \(key) Data: \(data)")

    if key != "" && data != "" {
        testStrings.append((key, data))
        treeOfStrings.insert(data: data, withKey: key)
    }
}

for aTest in testStrings {
    let data = treeOfStrings.find(key: aTest.key)

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
    let key = Utils.shared.randomAlphaNumericString(withLength: randomLength)

    if key != "" {
        testNums.append((key, randomNum))
        treeOfInts.insert(data: randomNum, withKey: key)
    }
}

for aTest in testNums {
    let data = treeOfInts.find(key: aTest.key)
    if data == nil {
        print("TEST FAILED. Key: \(aTest.key) Data: \(aTest.data)")
    }
    if data != aTest.data {
        print("TEST FAILED. Key: \(aTest.key) Data: \(aTest.data)")
    }
}
