//
//  RadixSortTests.swift
//  Tests
//
//  Created by theng on 2017-01-10.
//  Copyright © 2017 Swift Algorithm Club. All rights reserved.
//

import XCTest

class RadixSortTests: XCTestCase {
  func testSwift4() {
    // last checked with Xcode 9.0b4
    #if swift(>=4.0)
      print("Hello, Swift 4!")
    #endif
  }
  
  func testCombSort() {
    let expectedSequence: [Int] = [2, 9, 19, 32, 55, 67, 89, 101, 912, 4242]
    var sequence = [19, 4242, 2, 9, 912, 101, 55, 67, 89, 32]
    radixSort(&sequence)
    XCTAssertEqual(sequence, expectedSequence)
  }
}
