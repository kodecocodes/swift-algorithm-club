//
//  NumberOfIslandsTest.swift
//  NumberOfIslandsTests
//
//  Created by Sumant Sogikar on 30/09/20.
//  Copyright © 2020 Jayant Sogiakar. All rights reserved.
//

import XCTest
@testable import NumberOfIslands
class NumOfIslandsTest : XCTestCase{
    func test_1(){
        let val = numOfIslands([
          ["1","1","1","1","0"],
          ["1","1","0","1","0"],
          ["1","1","0","0","0"],
          ["0","0","0","0","0"]
        ])
        XCTAssertEqual(val, 1)
    }
    func test_2(){
        let val = numOfIslands([
          ["1","1","0","0","0"],
          ["1","1","0","0","0"],
          ["0","0","1","0","0"],
          ["0","0","0","1","1"]
        ])
        XCTAssertEqual(val, 3)
    }
    func test_3(){
        let val = numOfIslands([["1","0","1","1","0","1","1"]])
        XCTAssertEqual(val, 3)
    }
}
