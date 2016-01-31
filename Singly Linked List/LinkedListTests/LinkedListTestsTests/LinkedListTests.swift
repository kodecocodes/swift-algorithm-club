//
//  LinkedListTestsTests.swift
//  LinkedListTestsTests
//
//  Created by Mac Bellingrath on 1/30/16.
//  Copyright © 2016 Mac Bellingrath. All rights reserved.
//

import XCTest
@testable import LinkedListTests

class SinglyLinkedListTests: XCTestCase {
    
    var sll: SinglyLinkedList<Int>!
    
    override func setUp() {
        super.setUp()
        sll = SinglyLinkedList<Int>()
    }
    
    override func tearDown() {
        super.tearDown()
        sll = nil
    }
    
    func testEmpty() {
        
        XCTAssertTrue(sll.isEmpty)
        XCTAssertEqual(sll?.count, 0)
        
    }
    
    func testOneLink() {
        XCTAssertEqual(sll.count, 0)
        sll.addLink(1)
        XCTAssertEqual(sll.count, 1)
        XCTAssertNil(sll.head.next)
    }
    
    func testTwoLinks() {
        XCTAssertEqual(sll.count, 0)
        sll.addLink(1)
        sll.addLink(2)
        XCTAssertEqual(sll.count, 2)
        XCTAssertNotNil(sll.head.next)
    }
    
    func testRemoveOneLink() {
        XCTAssertEqual(sll.count, 0)
        sll.addLink(1)
        XCTAssertEqual(sll.count, 1)
        sll.removeLinkAtIndex(0)
        XCTAssertEqual(sll.count, 0)
        
    }
    
    
    
    
}
