//
//  CountingSort.swift
//  CountingSort
//
//  Created by Kauserali on 11/04/16.
//
//

import XCTest

class CountingSort: XCTestCase {

  func testCountingSort() {
    let sequence = [10, 8, 1, 2, 5, 8]
    let sortedSequence = [1, 2, 5, 8, 8, 10]

    do {
      let afterCountingSort = try countingSort(sequence)
      XCTAssertEqual(afterCountingSort, sortedSequence)
    } catch {
      XCTFail("")
    }
  }
}
