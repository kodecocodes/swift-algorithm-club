//
//  HeapTests.swift
//  Written for the Swift Algorithm Club by Kevin Randrup
//

import XCTest
@testable import Heap

class HeapTests: XCTestCase {
    
    func testIsEmpty() {
        var heap = MaxHeap<Int>()
        XCTAssertTrue(heap.isEmpty)
        heap.insert(1)
        XCTAssertFalse(heap.isEmpty)
        heap.remove()
        XCTAssertTrue(heap.isEmpty)
    }
    
    func testInsertRemove() {
        /**   9
         *  7    5
         * 1 2  3
         * Should be represented in memory as [9, 5, 7, 1, 3, 2] though we are just testing the effects.
         */
        var heap = MaxHeap<Int>()
        heap.insert([1, 3, 2, 7, 5, 9])
        
        //Should be removed in order
        XCTAssertEqual(9, heap.remove())
        XCTAssertEqual(7, heap.remove())
        XCTAssertEqual(5, heap.remove())
        XCTAssertEqual(3, heap.remove())
        XCTAssertEqual(2, heap.remove())
        XCTAssertEqual(1, heap.remove())
        XCTAssertNil(heap.remove())
    }
    
    func testCount() {
        var heap = MaxHeap<Int>()
        XCTAssertEqual(0, heap.count)
        heap.insert(1)
        XCTAssertEqual(1, heap.count)
    }

    func testRemoveEmpty() {
        var heap = MaxHeap<Int>()
        let removed = heap.remove()
        XCTAssertNil(removed)
    }
}
