//
//  TestTests.swift
//  TestTests
//
//  Created by Barbara Rodeker on 4/5/16.
//  Copyright © 2016 Barbara M. Rodeker. All rights reserved.
//

import XCTest

class TestTests: XCTestCase {

    var smallArray: [Int]?

    let total = 400
    let maximum = 1000
    var largeArray: [Int]?

    var sparsedArray: [Int]?

    override func setUp() {
        super.setUp()

        smallArray = [8, 3, 33, 0, 12, 8, 2, 18]

        largeArray = [Int]()
        for _ in 0..<total {
            largeArray!.append( random() % maximum )
        }

        sparsedArray = [Int]()
        sparsedArray = [10, 400, 1500, 500]
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSmallArray() {

        let results = performBucketSort(smallArray!, totalBuckets: 3)
        XCTAssert(isSorted(results))
    }

    func testBigArray() {

        let results = performBucketSort(largeArray!, totalBuckets: 8)
        XCTAssert(isSorted(results))
    }

    func testSparsedArray() {

        let results = performBucketSort(sparsedArray!, totalBuckets: 3)
        XCTAssert(isSorted(results))
    }

    // MARK: Private functions

    private func performBucketSort(elements: [Int], totalBuckets: Int) -> [Int] {

        let value = (elements.maxElement()?.toInt())! + 1
        let capacityRequired = Int( ceil( Double(value) / Double(totalBuckets) ) )

        var buckets = [Bucket<Int>]()
        for _ in 0..<totalBuckets {
            buckets.append(Bucket<Int>(capacity: capacityRequired))
        }

        let results = bucketSort(smallArray!, distributor: RangeDistributor(), sorter: InsertionSorter(), buckets: buckets)
        return results
    }

    func isSorted(array: [Int]) -> Bool {

        var index = 0
        var sorted = true
        while index < (array.count - 1) && sorted {
            if array[index] > array[index+1] {
                sorted = false
            }
            index += 1
        }

        return sorted
    }
}


//////////////////////////////////////
// MARK: Extensions
//////////////////////////////////////

extension Int: IntConvertible, Sortable {
    public func toInt() -> Int {
        return self
    }
}
