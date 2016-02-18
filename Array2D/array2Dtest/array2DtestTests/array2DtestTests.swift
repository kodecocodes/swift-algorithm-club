//
//  Array2DTest.swift
//  algorithmclub
//
//  Created by Barbara Rodeker on 2/16/16.
//  Copyright © 2016 Swift Algorithm Club. All rights reserved.
//

import XCTest
@testable import array2Dtest

class Array2DTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testIntegerArrayWithPositiveRowsAndColumns() {
        let array = Array2D<Int>(columns: 3, rows: 2, initialValue: 0)
        XCTAssert(array.columns == 3, "Column count setup worked")
        XCTAssert(array.rows == 2, "Rows count setup worked")
        XCTAssert(array[2,2] == 0, "Integer array: Initialization value properly read")
    }
    
    func testStringArrayWithPositiveRowsAndColumns() {
        let array = Array2D<String>(columns: 3, rows: 2, initialValue: "empty")
        XCTAssert(array.columns == 3, "Column count setup worked")
        XCTAssert(array.rows == 2, "Rows count setup worked")
        XCTAssert(array[2,2] == "empty", "String array: Initialization value properly read")
    }
    
    func testCustomClassArrayWithPositiveRowsAndColumns() {
        let array = Array2D<TestElement>(columns: 3, rows: 2, initialValue: TestElement(identifier: "pepe"))
        XCTAssert(array.columns == 3, "Column count setup worked")
        XCTAssert(array.rows == 2, "Rows count setup worked")
        XCTAssert(array[2,2] == TestElement(identifier: "pepe"), "Custom Class array: Initialization value properly read")
    }
    
    func testArrayWithNegativeColumns() {
        let array = Array2D(columns: -1,rows: 2,initialValue: 0)
        XCTAssertNil(array)
    }
    
    func testAccessingWrongIndex() {
        let array = Array2D(columns: 2, rows: 4, initialValue: 5)
        XCTAssertNil(array[20,20], "Array in 20,20 is not a valid index")
    }
    
    func testPerformanceOnSmallArray() {
        self.measureBlock {
            self.printArrayWith(columns: 2, rows: 2, inititalValue: 1)
        }
    }

    func testPerformanceOnLargeArray() {
        self.measureBlock {
            self.printArrayWith(columns: 2000000, rows: 2000000, inititalValue: 1)
        }
    }

    private func printArrayWith(columns columns: Int, rows: Int, inititalValue: Int){
        let array = Array2D(columns: columns, rows: rows, initialValue: 4)
        for r in 0..<array.rows {
            for c in 0..<array.columns {
                print("Array in [\(r), \(c)] value is: \(array[c,r])")
            }
        }
    }
    
}

class TestElement : Equatable {
    let identifier : String
    
    init(identifier: String) {
        self.identifier = identifier
    }
    
}

func == (lhs: TestElement, rhs: TestElement) -> Bool {
    return lhs.identifier == rhs.identifier
}

