//
//  TreapTests.swift
//  TreapTests
//
//  Created by Robert Thompson on 2/18/16.
//  Copyright © 2016 Robert Thompson
/* Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.*/

// swiftlint:disable force_try

import XCTest
@testable import Treap

class TreapTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSanity() {
        var treap = Treap<Int, String>.Empty
        treap = treap.set(5, val: "a").set(7, val: "b")
        XCTAssert(treap.get(5) == "a")
        XCTAssert(treap.get(7) == "b")
        treap = treap.set(2, val: "c")
        XCTAssert(treap.get(2) == "c")
        treap = treap.set(2, val: "d")
        XCTAssert(treap.get(2) == "d")
        treap = try! treap.delete(5)
        XCTAssert(!treap.contains(5))
        XCTAssert(treap.contains(7))
    }

    func testFairlyBalanced() {
        var treap = Treap<Int, Int?>.Empty
        for i in 0..<1000 {
            treap = treap.set(i, val: nil)
        }
        let depth = treap.depth
        XCTAssert(depth < 30, "treap.depth was \(depth)")
    }

    func testFairlyBalancedCollection() {
        var treap = Treap<Int, Int?>()
        for i in 0..<1000 {
            treap[i] = Optional<Int>.None
        }
        let depth = treap.depth
        XCTAssert(depth > 0 && depth < 30)
    }

}
