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
    heapSort(&array, start: 0, end: array.count)
    
    for index in 0..<array.count-1 {
      XCTAssertTrue(array[index] <= array[index+1])
    }
  }

}
