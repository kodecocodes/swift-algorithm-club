//
//  CombSortTests.swift
//  Tests
//
//  Created by theng on 2017-01-09.
//  Copyright © 2017 Swift Algorithm Club. All rights reserved.
//

import XCTest

class CombSortTests: XCTestCase {
    var sequence: [Int]!
    let expectedSequence: [Int] = [-12, -10, -1, 2, 9, 32, 55, 67, 89, 101]

    func testSwift4(){
        #if swift(>=4.0)
            print("Hello, Swift 4!")
        #endif
    }
    
    override func setUp() {
        super.setUp()
        sequence = [2, 32, 9, -1, 89, 101, 55, -10, -12, 67]
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCombSort() {
        let sortedSequence = combSort(sequence)
        XCTAssertEqual(sortedSequence, expectedSequence)
    }
}
