import Foundation
import XCTest

func randomArray(size: Int) -> [Int] {
  var a = [Int]()
  for _ in 1...size {
    a.append(Int(arc4random_uniform(1000)))
  }
  return a
}

func arrayIsSortedLowToHigh(a: [Int]) -> Bool {
  for x in 1..<a.count {
    if a[x - 1] > a[x] { return false }
  }
  return true
}

typealias SortFunction = [Int] -> [Int]

func checkSortingRandomArray(sortFunction: SortFunction) {
  let numberOfIterations = 100
  for _ in 1...numberOfIterations {
    let a = randomArray(Int(arc4random_uniform(100)) + 1)
    let s = sortFunction(a)
    XCTAssertEqual(a.count, s.count)
    XCTAssertTrue(arrayIsSortedLowToHigh(s))
  }
}

func checkSortingEmptyArray(sortFunction: SortFunction) {
  let a = [Int]()
  let s = sortFunction(a)
  XCTAssertEqual(s.count, 0)
}

func checkSortingArrayOneElement(sortFunction: SortFunction) {
  let a = [123]
  let s = sortFunction(a)
  XCTAssertEqual(s, [123])
}

func checkSortingArrayTwoElementsInOrder(sortFunction: SortFunction) {
  let a = [123, 456]
  let s = sortFunction(a)
  XCTAssertEqual(s, [123, 456])
}

func checkSortingArrayTwoElementsOutOfOrder(sortFunction: SortFunction) {
  let a = [456, 123]
  let s = sortFunction(a)
  XCTAssertEqual(s, [123, 456])
}

func checkSortingArrayTwoEqualElements(sortFunction: SortFunction) {
  let a = [123, 123]
  let s = sortFunction(a)
  XCTAssertEqual(s, [123, 123])
}

func checkSortingArrayThreeElementsABC(sortFunction: SortFunction) {
  let a = [2, 4, 6]
  let s = sortFunction(a)
  XCTAssertEqual(s, [2, 4, 6])
}

func checkSortingArrayThreeElementsACB(sortFunction: SortFunction) {
  let a = [2, 6, 4]
  let s = sortFunction(a)
  XCTAssertEqual(s, [2, 4, 6])
}

func checkSortingArrayThreeElementsBAC(sortFunction: SortFunction) {
  let a = [4, 2, 6]
  let s = sortFunction(a)
  XCTAssertEqual(s, [2, 4, 6])
}

func checkSortingArrayThreeElementsBCA(sortFunction: SortFunction) {
  let a = [4, 6, 2]
  let s = sortFunction(a)
  XCTAssertEqual(s, [2, 4, 6])
}

func checkSortingArrayThreeElementsCAB(sortFunction: SortFunction) {
  let a = [6, 2, 4]
  let s = sortFunction(a)
  XCTAssertEqual(s, [2, 4, 6])
}

func checkSortingArrayThreeElementsCBA(sortFunction: SortFunction) {
  let a = [6, 4, 2]
  let s = sortFunction(a)
  XCTAssertEqual(s, [2, 4, 6])
}

func checkSortAlgorithm(sortFunction: SortFunction) {
  checkSortingEmptyArray(sortFunction)
  checkSortingArrayOneElement(sortFunction)
  checkSortingArrayTwoElementsInOrder(sortFunction)
  checkSortingArrayTwoElementsOutOfOrder(sortFunction)
  checkSortingArrayTwoEqualElements(sortFunction)
  checkSortingArrayThreeElementsABC(sortFunction)
  checkSortingArrayThreeElementsACB(sortFunction)
  checkSortingArrayThreeElementsBAC(sortFunction)
  checkSortingArrayThreeElementsBCA(sortFunction)
  checkSortingArrayThreeElementsCAB(sortFunction)
  checkSortingArrayThreeElementsCBA(sortFunction)
  checkSortingRandomArray(sortFunction)
}

func checkSortAlgorithm(sortFunction: ([Int], (Int, Int) -> Bool) -> [Int]) {
  checkSortAlgorithm { a in sortFunction(a, <) }
}
