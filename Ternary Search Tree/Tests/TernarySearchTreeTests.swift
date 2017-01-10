//
//  Tests.swift
//  Tests
//
//  Created by Peter Bødskov on 10/01/17.
//  Copyright © 2017 Swift Algorithm Club. All rights reserved.
//

import XCTest

class TernarySearchTreeTests: XCTestCase {
    
    let treeOfStrings = TernarySearchTree<String>()
    let testCount = 30
    
    func testCanFindStringInTree() {
        var testStrings: [(key: String, data: String)] = []
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
            
            XCTAssertNotNil(data)
            XCTAssertEqual(data, aTest.data)
        }
    }
    
    func testCanFindNumberInTree() {
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
            XCTAssertNotNil(data)
            XCTAssertEqual(data, aTest.data)
        }
    }
}
