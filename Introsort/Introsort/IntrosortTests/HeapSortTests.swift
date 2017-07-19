//
//  HeapSortTests.swift
//  IntrosortTests
//
//  Created by Richard Ash on 7/18/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import XCTest

class HeapSortTests: XCTestCase {

  func testHeapSort() {
    var array = [Int].random(size: 100)
    heapSort(&array, start: 0, end: array.count-1)
    
    for index in 0..<array.count-1 {
      XCTAssertTrue(array[index] <= array[index+1])
    }
  }
  
  func testHeapSortLarge() {
    var array = [Int].random(size: 1000)
    heapSort(&array, start: 0, end: array.count-1)
    
    for index in 0..<array.count-1 {
      XCTAssertTrue(array[index] <= array[index+1])
    }
  }
  
  func testHeapSortFixed() {
    var array = [5, 12, 2, 438, 1, 8, 0, 38, 57, 678, 6, 32, 1, 2, 44, 55]
    let expectedResult = [0, 1, 1, 2, 2, 5, 6, 8, 12, 32, 38, 44, 55, 57, 438, 678]
    heapSort(&array, start: 0, end: array.count-1)
    
    XCTAssertEqual(array, expectedResult)
  }
  
  func testHeapSortPartial() {
    var array = [5, 12, 2, 438, 1, 8, 0, 38, 57, 678, 6, 32, 1, 2, 44, 55]
    let expectedResult = [5, 12, 2, 0, 1, 8, 38, 438, 57, 678, 6, 32, 1, 2, 44, 55]
    insertionSort(&array, start: 3, end: 7)
    
    XCTAssertEqual(array, expectedResult)
  }

}
