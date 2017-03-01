//
//  BucketSort.swift
//
//  Created by Barbara Rodeker on 4/4/16.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
//  EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
//  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
//  OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


//////////////////////////////////////
// MARK: Main algorithm
//////////////////////////////////////


/**
    Performs bucket sort algorithm on the given input elements.
    [Bucket Sort Algorithm Reference](https://en.wikipedia.org/wiki/Bucket_sort)

    - Parameter elements:     Array of Sortable elements
    - Parameter distributor:  Performs the distribution of each element of a bucket
    - Parameter sorter:       Performs the sorting inside each bucket, after all the elements are distributed
    - Parameter buckets:      An array of buckets

    - Returns: A new array with sorted elements
 */

public func bucketSort<T: Sortable>(_ elements: [T], distributor: Distributor, sorter: Sorter, buckets: [Bucket<T>]) -> [T] {
    precondition(allPositiveNumbers(elements))
    precondition(enoughSpaceInBuckets(buckets, elements: elements))

    var bucketsCopy = buckets
    for elem in elements {
        distributor.distribute(elem, buckets: &bucketsCopy)
    }

    var results = [T]()

    for bucket in bucketsCopy {
        results += bucket.sort(sorter)
    }

    return results
}

private func allPositiveNumbers<T: Sortable>(_ array: [T]) -> Bool {
    return array.filter { $0.toInt() >= 0 }.count > 0
}

private func enoughSpaceInBuckets<T: Sortable>(_ buckets: [Bucket<T>], elements: [T]) -> Bool {
    let maximumValue = elements.max()?.toInt()
    let totalCapacity = buckets.count * (buckets.first?.capacity)!

    return totalCapacity >= maximumValue
}

//////////////////////////////////////
// MARK: Distributor
//////////////////////////////////////


public protocol Distributor {
    func distribute<T: Sortable>(_ element: T, buckets: inout [Bucket<T>])
}

/*
 * An example of a simple distribution function that send every elements to
 * the bucket representing the range in which it fits.An
 *
 * If the range of values to sort is 0..<49 i.e, there could be 5 buckets of capacity = 10
 * So every element will be classified by the ranges:
 *
 * -  0 ..< 10
 * - 10 ..< 20
 * - 20 ..< 30
 * - 30 ..< 40
 * - 40 ..< 50
 *
 * By following the formula: element / capacity = #ofBucket
 */
public struct RangeDistributor: Distributor {

    public init() {}

    public func distribute<T: Sortable>(_ element: T, buckets: inout [Bucket<T>]) {
        let value = element.toInt()
        let bucketCapacity = buckets.first!.capacity

        let bucketIndex = value / bucketCapacity
        buckets[bucketIndex].add(element)
    }
}

//////////////////////////////////////
// MARK: Sortable
//////////////////////////////////////

public protocol IntConvertible {
    func toInt() -> Int
}

public protocol Sortable: IntConvertible, Comparable {
}

//////////////////////////////////////
// MARK: Sorter
//////////////////////////////////////

public protocol Sorter {
    func sort<T: Sortable>(_ items: [T]) -> [T]
}

public struct InsertionSorter: Sorter {

    public init() {}

    public func sort<T: Sortable>(_ items: [T]) -> [T] {
        var results = items
        for i in 0 ..< results.count {
            var j = i
            while j > 0 && results[j-1] > results[j] {

                let auxiliar = results[j-1]
                results[j-1] = results[j]
                results[j] = auxiliar

                j -= 1
            }
        }
        return results
    }
}

//////////////////////////////////////
// MARK: Bucket
//////////////////////////////////////

public struct Bucket<T:Sortable> {
    var elements: [T]
    let capacity: Int

    public init(capacity: Int) {
        self.capacity = capacity
        elements = [T]()
    }

    public mutating func add(_ item: T) {
        if elements.count < capacity {
            elements.append(item)
        }
    }

    public func sort(_ algorithm: Sorter) -> [T] {
        return algorithm.sort(elements)
    }
}
