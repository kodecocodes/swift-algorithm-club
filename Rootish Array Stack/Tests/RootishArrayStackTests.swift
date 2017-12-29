import XCTest

fileprivate extension RootishArrayStack {
	func equal(toArray array: Array<Int>) -> Bool {
		for index in 0..<count {
			guard let integerElement = self[index] as? Int else { return false }
			if array[index] != integerElement {
				return false
			}
		}
		return true
	}
}

class RootishArrayStackTests: XCTestCase {

	private func buildList(withNumbers numbers: [Int]? = nil) -> RootishArrayStack<Int> {
    var list = RootishArrayStack<Int>()

		if let numbers = numbers {
			for number in numbers {
				list.append(element: number)
			}
		}
    return list
  }

	func testEmptyList() {
		let emptyArray = [Int]()
		let list = buildList()

		XCTAssertTrue(list.isEmpty)
		XCTAssertEqual(list.count, 0)
		XCTAssertEqual(list.capacity, 0)
		XCTAssertNil(list.first)
		XCTAssertNil(list.last)
		XCTAssertTrue(list.equal(toArray: emptyArray))
	}

	func testListWithOneElement() {
		let array = [1]
		let list = buildList(withNumbers: array)

		XCTAssertFalse(list.isEmpty)
		XCTAssertEqual(list.count, 1)
		XCTAssertEqual(list.capacity, 1)
		XCTAssertEqual(list.first, 1)
		XCTAssertEqual(list.last, 1)
		XCTAssertEqual(list.first, list.last)
		XCTAssertTrue(list.equal(toArray: array))
	}

	func testListWithTwoElements() {
		let array = [1, 2]
		let list = buildList(withNumbers: array)

		XCTAssertFalse(list.isEmpty)
		XCTAssertEqual(list.count, 2)
		XCTAssertEqual(list.capacity, 3)
		XCTAssertEqual(list.first, 1)
		XCTAssertEqual(list.last, 2)
		XCTAssertNotEqual(list.first, list.last)
		XCTAssertTrue(list.equal(toArray: array))
	}

	func testListWithThreeElements() {
		let array = [1, 2, 3]
		let list = buildList(withNumbers: array)

		XCTAssertFalse(list.isEmpty)
		XCTAssertEqual(list.count, 3)
		XCTAssertEqual(list.capacity, 6)
		XCTAssertEqual(list.first, 1)
		XCTAssertEqual(list.last, 3)
		XCTAssertNotEqual(list.first, list.last)
		XCTAssertTrue(list.equal(toArray: array))
	}

	func testFillThenEmpty() {
		let array = [Int](0..<100)
		let emptyArray = [Int]()
		var list = buildList(withNumbers: array)

		XCTAssertTrue(list.equal(toArray: array))

		for _ in 0..<100 {
			list.remove(atIndex: list.count - 1)
		}

		XCTAssertEqual(list.count, 0)
		XCTAssertEqual(list.capacity, 0)
		XCTAssertTrue(list.equal(toArray: emptyArray))
	}

	func testInsertFront() {
		var array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		var list = buildList(withNumbers: array)

		XCTAssertEqual(list.count, 10)
		XCTAssertEqual(list.capacity, 15)
		XCTAssertEqual(list.first, 1)
		XCTAssertTrue(list.equal(toArray: array))

		let newElement = 0
		list.insert(element: newElement, atIndex: 0)
		array.insert(newElement, at: 0)

		XCTAssertEqual(list.count, 11)
		XCTAssertEqual(list.capacity, 21)
		XCTAssertEqual(list.first, newElement)
		XCTAssertTrue(list.equal(toArray: array))
	}

	func testInsertMiddle() {
		var array = [0, 2, 3]
		var list = buildList(withNumbers: array)

		XCTAssertEqual(list.count, 3)
		XCTAssertEqual(list.capacity, 6)
		XCTAssertTrue(list.equal(toArray: array))

		let newElement = 1
		list.insert(element: newElement, atIndex: 1)
		array.insert(newElement, at: 1)

		XCTAssertEqual(list.count, 4)
		XCTAssertEqual(list.capacity, 10)
		XCTAssertEqual(list[1], newElement)
		XCTAssertTrue(list.equal(toArray: array))
	}

	func testSubscriptGet() {
		let array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
		let list = buildList(withNumbers: array)
		for index in 0...9 {
			XCTAssertEqual(list[index], index)
		}
		XCTAssertTrue(list.equal(toArray: array))
	}

	func testSubscriptSet() {
		var array = [Int](0..<10)
		var list = buildList(withNumbers: array)

		list[1] = 100
		list[5] = 500
		list[8] = 800
		array[1] = 100
		array[5] = 500
		array[8] = 800

		XCTAssertTrue(list.equal(toArray: array))
	}

	func testRemoveFirst() {
		var array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
		var list = buildList(withNumbers: array)

		XCTAssertEqual(list.count, 10)
		XCTAssertEqual(list.capacity, 15)
		XCTAssertEqual(list.first, 1)
		XCTAssertTrue(list.equal(toArray: array))

		list.remove(atIndex: 0)
		array.remove(at: 0)

		XCTAssertEqual(list.count, 9)
		XCTAssertEqual(list.capacity, 15)
		XCTAssertEqual(list.first, 2)
		XCTAssertTrue(list.equal(toArray: array))
	}

	func testRemoveMiddle() {
		var array = [0, 1, 2, 3]
		var list = buildList(withNumbers: array)

		XCTAssertEqual(list.count, 4)
		XCTAssertEqual(list.capacity, 10)
		XCTAssertEqual(list.first, 0)
		XCTAssertTrue(list.equal(toArray: array))

		list.remove(atIndex: 2)
		array.remove(at: 2)

		XCTAssertEqual(list.count, 3)
		XCTAssertEqual(list.capacity, 6)
		XCTAssertEqual(list.first, 0)
		XCTAssertTrue(list.equal(toArray: array))
	}

	func testRemoveLast() {
		var array = [0, 1, 2, 3]
		var list = buildList(withNumbers: array)

		XCTAssertEqual(list.count, 4)
		XCTAssertEqual(list.capacity, 10)
		XCTAssertEqual(list.first, 0)
		XCTAssertTrue(list.equal(toArray: array))

		list.remove(atIndex: 3)
		array.remove(at: 3)

		XCTAssertEqual(list.count, 3)
		XCTAssertEqual(list.capacity, 6)
		XCTAssertEqual(list.first, 0)
		XCTAssertTrue(list.equal(toArray: array))
	}

  func testSwift4() {
    // last checked with Xcode 9.0b4
    #if swift(>=4.0)
      print("Hello, Swift 4!")
    #endif
  }
}
