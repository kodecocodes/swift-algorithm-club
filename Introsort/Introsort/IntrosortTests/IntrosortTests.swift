//
//  IntrosortTests.swift
//  IntrosortTests
//
//  Created by Richard Ash on 7/18/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import XCTest

class IntrosortTests: XCTestCase {
  
  func testIntrosort() {
    var array = [Int].random(size: 100)
    introsort(&array)
    
    for index in 0..<array.count-1 {
      XCTAssertTrue(array[index] <= array[index+1])
    }
  }
  
  func testIntrosortLarge() {
    var array = [Int].random(size: 1000)
    introsort(&array)
    
    for index in 0..<array.count-1 {
      XCTAssertTrue(array[index] <= array[index+1])
    }
  }
  
  func testIntrosortFixed() {
    var array = [5, 12, 2, 438, 1, 8, 0, 38, 57, 678, 6, 32, 1, 2, 44, 55]
    let expectedResult = [0, 1, 1, 2, 2, 5, 6, 8, 12, 32, 38, 44, 55, 57, 438, 678]
    introsort(&array)
    
    XCTAssertEqual(array, expectedResult)
  }
}
