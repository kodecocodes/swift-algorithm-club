//
//  InsertionSortTests.swift
//  IntrosortTests
//
//  Created by Richard Ash on 7/18/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import XCTest

class InsertionSortTests: XCTestCase {
  
  
  func testInsertionSort() {
    var array = [Int].random(size: 100)
    insertionSort(&array, start: 0, end: array.count-1)
    
    for index in 0..<array.count-1 {
      XCTAssertTrue(array[index] <= array[index+1])
    }
  }
  
  func testInsertionSortLarge() {
    var array = [Int].random(size: 1000)
    insertionSort(&array, start: 0, end: array.count-1)
    
    for index in 0..<array.count-1 {
      XCTAssertTrue(array[index] <= array[index+1])
    }
  }
  
  func testInsertionSortFixed() {
    var array = [5, 12, 2, 438, 1, 8, 0, 38, 57, 678, 6, 32, 1, 2, 44, 55]
    let expectedResult = [0, 1, 1, 2, 2, 5, 6, 8, 12, 32, 38, 44, 55, 57, 438, 678]
    insertionSort(&array, start: 0, end: array.count-1)
    
    XCTAssertEqual(array, expectedResult)
  }
}
