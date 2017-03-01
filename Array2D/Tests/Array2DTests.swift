//
//  Array2DTest.swift
//  algorithmclub
//
//  Created by Barbara Rodeker on 2/16/16.
//  Copyright © 2016 Swift Algorithm Club. All rights reserved.
//

import XCTest

class Array2DTest: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testIntegerArrayWithPositiveRowsAndColumns() {
    let array = Array2D<Int>(columns: 3, rows: 2, initialValue: 0)

    XCTAssertEqual(array.columns, 3, "Column count setup failed")
    XCTAssertEqual(array.rows, 2, "Rows count setup failed")
    XCTAssertEqual(array[2, 1], 0, "Integer array: Initialization value is wrong")
  }

  func testStringArrayWithPositiveRowsAndColumns() {
    let array = Array2D<String>(columns: 3, rows: 2, initialValue: "empty")

    XCTAssertEqual(array.columns, 3, "Column count setup failed")
    XCTAssertEqual(array.rows, 2, "Rows count setup failed")
    XCTAssertEqual(array[2, 1], "empty", "String array: Initialization value is wrong")
  }

  func testCustomClassArrayWithPositiveRowsAndColumns() {
    let array = Array2D<TestElement>(columns: 3, rows: 2, initialValue: TestElement(identifier: "pepe"))

    XCTAssertEqual(array.columns, 3, "Column count setup failed")
    XCTAssertEqual(array.rows, 2, "Rows count setup failed")
    XCTAssertEqual(array[2, 1], TestElement(identifier: "pepe"), "Custom Class array: Initialization value is wrong")
  }

  func testPerformanceOnSmallArray() {
    self.measure {
      self.printArrayWith(columns: 2, rows: 2, inititalValue: 1)
    }
  }

  //    func testPerformanceOnLargeArray() {
  //        self.measureBlock {
  //            self.printArrayWith(columns: 2000, rows: 2000, inititalValue: 1)
  //        }
  //    }

  fileprivate func printArrayWith(columns: Int, rows: Int, inititalValue: Int) {
    let array = Array2D(columns: columns, rows: rows, initialValue: 4)
    for r in 0..<array.rows {
      for c in 0..<array.columns {
        print("Array in [\(r), \(c)] value is: \(array[c, r])")
      }
    }
  }

}

class TestElement: Equatable {
  let identifier: String

  init(identifier: String) {
    self.identifier = identifier
  }
}

func == (lhs: TestElement, rhs: TestElement) -> Bool {
  return lhs.identifier == rhs.identifier
}
