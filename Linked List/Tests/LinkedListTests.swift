import XCTest

class LinkedListTest: XCTestCase {
  let numbers = [8, 2, 10, 9, 7, 5]

  fileprivate func buildList() -> LinkedList<Int> {
    let list = LinkedList<Int>()
    for number in numbers {
      list.append(number)
    }
    return list
  }

  func testSwift4() {
    // last checked with Xcode 9.0b4
    #if swift(>=4.0)
      print("Hello, Swift 4!")
    #endif
  }

  func testEmptyList() {
    let list = LinkedList<Int>()
    XCTAssertTrue(list.isEmpty)
    XCTAssertEqual(list.count, 0)
    XCTAssertNil(list.first)
    XCTAssertNil(list.last)
  }

  func testListWithOneElement() {
    let list = LinkedList<Int>()
    list.append(123)

    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(list.count, 1)

    XCTAssertNotNil(list.first)
    XCTAssertNil(list.first!.previous)
    XCTAssertNil(list.first!.next)
    XCTAssertEqual(list.first!.value, 123)

    XCTAssertNotNil(list.last)
    XCTAssertNil(list.last!.previous)
    XCTAssertNil(list.last!.next)
    XCTAssertEqual(list.last!.value, 123)

    XCTAssertTrue(list.first === list.last)
  }

  func testListWithTwoElements() {
    let list = LinkedList<Int>()
    list.append(123)
    list.append(456)

    XCTAssertEqual(list.count, 2)

    XCTAssertNotNil(list.first)
    XCTAssertEqual(list.first!.value, 123)

    XCTAssertNotNil(list.last)
    XCTAssertEqual(list.last!.value, 456)

    XCTAssertTrue(list.first !== list.last)

    XCTAssertNil(list.first!.previous)
    XCTAssertTrue(list.first!.next === list.last)
    XCTAssertTrue(list.last!.previous === list.first)
    XCTAssertNil(list.last!.next)
  }

  func testListWithThreeElements() {
    let list = LinkedList<Int>()
    list.append(123)
    list.append(456)
    list.append(789)

    XCTAssertEqual(list.count, 3)

    XCTAssertNotNil(list.first)
    XCTAssertEqual(list.first!.value, 123)

    let second = list.first!.next
    XCTAssertNotNil(second)
    XCTAssertEqual(second!.value, 456)

    XCTAssertNotNil(list.last)
    XCTAssertEqual(list.last!.value, 789)

    XCTAssertNil(list.first!.previous)
    XCTAssertTrue(list.first!.next === second)
    XCTAssertTrue(second!.previous === list.first)
    XCTAssertTrue(second!.next === list.last)
    XCTAssertTrue(list.last!.previous === second)
    XCTAssertNil(list.last!.next)
  }

  func testNodeAtIndexInEmptyList() {
    let list = LinkedList<Int>()
    let node = list.node(atIndex: 0)
    XCTAssertNil(node)
  }

  func testNodeAtIndexInListWithOneElement() {
    let list = LinkedList<Int>()
    list.append(123)

    let node = list.node(atIndex: 0)
    XCTAssertNotNil(node)
    XCTAssertEqual(node!.value, 123)
    XCTAssertTrue(node === list.first)
  }

  func testNodeAtIndex() {
    let list = buildList()

    let nodeCount = list.count
    XCTAssertEqual(nodeCount, numbers.count)

    XCTAssertNil(list.node(atIndex: -1))
    XCTAssertNil(list.node(atIndex: nodeCount))

    let first = list.node(atIndex: 0)
    XCTAssertNotNil(first)
    XCTAssertTrue(first === list.first)
    XCTAssertEqual(first!.value, numbers[0])

    let last = list.node(atIndex: nodeCount - 1)
    XCTAssertNotNil(last)
    XCTAssertTrue(last === list.last)
    XCTAssertEqual(last!.value, numbers[nodeCount - 1])

    for i in 0..<nodeCount {
      let node = list.node(atIndex: i)
      XCTAssertNotNil(node)
      XCTAssertEqual(node!.value, numbers[i])
    }
  }

  func testSubscript() {
    let list = buildList()
    for i in 0 ..< list.count {
      XCTAssertEqual(list[i], numbers[i])
    }
  }

  func testInsertAtIndexInEmptyList() {
    let list = LinkedList<Int>()
    list.insert(123, atIndex: 0)

    XCTAssertFalse(list.isEmpty)
    XCTAssertEqual(list.count, 1)

    let node = list.node(atIndex: 0)
    XCTAssertNotNil(node)
    XCTAssertEqual(node!.value, 123)
  }

  func testInsertAtIndex() {
    let list = buildList()
    let prev = list.node(atIndex: 2)
    let next = list.node(atIndex: 3)
    let nodeCount = list.count

    list.insert(444, atIndex: 3)

    let node = list.node(atIndex: 3)
    XCTAssertNotNil(node)
    XCTAssertEqual(node!.value, 444)
    XCTAssertEqual(nodeCount + 1, list.count)

    XCTAssertFalse(prev === node)
    XCTAssertFalse(next === node)
    XCTAssertTrue(prev!.next === node)
    XCTAssertTrue(next!.previous === node)
  }

  func testInsertListAtIndex() {
    let list = buildList()
    let list2 = LinkedList<Int>()
    list2.append(99)
    list2.append(102)
    list.insert(list2, atIndex: 2)
    XCTAssertTrue(list.count == 8)
    XCTAssertEqual(list.node(atIndex: 1)?.value, 2)
    XCTAssertEqual(list.node(atIndex: 2)?.value, 99)
    XCTAssertEqual(list.node(atIndex: 3)?.value, 102)
    XCTAssertEqual(list.node(atIndex: 4)?.value, 10)
  }

  func testInsertListAtFirstIndex() {
    let list = buildList()
    let list2 = LinkedList<Int>()
    list2.append(99)
    list2.append(102)
    list.insert(list2, atIndex: 0)
    XCTAssertTrue(list.count == 8)
    XCTAssertEqual(list.node(atIndex: 0)?.value, 99)
    XCTAssertEqual(list.node(atIndex: 1)?.value, 102)
    XCTAssertEqual(list.node(atIndex: 2)?.value, 8)
  }

  func testInsertListAtLastIndex() {
    let list = buildList()
    let list2 = LinkedList<Int>()
    list2.append(99)
    list2.append(102)
    list.insert(list2, atIndex: list.count)
    XCTAssertTrue(list.count == 8)
    XCTAssertEqual(list.node(atIndex: 5)?.value, 5)
    XCTAssertEqual(list.node(atIndex: 6)?.value, 99)
    XCTAssertEqual(list.node(atIndex: 7)?.value, 102)
  }

  func testAppendList() {
    let list = buildList()
    let list2 = LinkedList<Int>()
    list2.append(99)
    list2.append(102)
    list.append(list2)
    XCTAssertTrue(list.count == 8)
    XCTAssertEqual(list.node(atIndex: 5)?.value, 5)
    XCTAssertEqual(list.node(atIndex: 6)?.value, 99)
    XCTAssertEqual(list.node(atIndex: 7)?.value, 102)
  }

  func testAppendListToEmptyList() {
    let list = LinkedList<Int>()
    let list2 = LinkedList<Int>()
    list2.append(5)
    list2.append(10)
    list.append(list2)
    XCTAssertTrue(list.count == 2)
    XCTAssertEqual(list.node(atIndex: 0)?.value, 5)
    XCTAssertEqual(list.node(atIndex: 1)?.value, 10)
  }

  func testRemoveAtIndexOnListWithOneElement() {
    let list = LinkedList<Int>()
    list.append(123)

    let value = list.remove(atIndex: 0)
    XCTAssertEqual(value, 123)

    XCTAssertTrue(list.isEmpty)
    XCTAssertEqual(list.count, 0)
    XCTAssertNil(list.first)
    XCTAssertNil(list.last)
  }

  func testRemoveAtIndex() {
    let list = buildList()
    let prev = list.node(atIndex: 2)
    let next = list.node(atIndex: 3)
    let nodeCount = list.count

    list.insert(444, atIndex: 3)

    let value = list.remove(atIndex: 3)
    XCTAssertEqual(value, 444)

    let node = list.node(atIndex: 3)
    XCTAssertTrue(next === node)
    XCTAssertTrue(prev!.next === node)
    XCTAssertTrue(node!.previous === prev)
    XCTAssertEqual(nodeCount, list.count)
  }

  func testRemoveLastOnListWithOneElement() {
    let list = LinkedList<Int>()
    list.append(123)

    let value = list.removeLast()
    XCTAssertEqual(value, 123)

    XCTAssertTrue(list.isEmpty)
    XCTAssertEqual(list.count, 0)
    XCTAssertNil(list.first)
    XCTAssertNil(list.last)
  }

  func testRemoveLast() {
    let list = buildList()
    let last = list.last
    let prev = last!.previous
    let nodeCount = list.count

    let value = list.removeLast()
    XCTAssertEqual(value, 5)

    XCTAssertNil(last!.previous)
    XCTAssertNil(last!.next)

    XCTAssertNil(prev!.next)
    XCTAssertTrue(list.last === prev)
    XCTAssertEqual(nodeCount - 1, list.count)
  }

  func testRemoveAll() {
    let list = buildList()
    list.removeAll()
    XCTAssertTrue(list.isEmpty)
    XCTAssertEqual(list.count, 0)
    XCTAssertNil(list.first)
    XCTAssertNil(list.last)
  }

  func testReverseLinkedList() {
    let list = buildList()
    let first = list.first
    let last = list.last
    let nodeCount = list.count

    list.reverse()

    XCTAssertTrue(first === list.last)
    XCTAssertTrue(last === list.first)
    XCTAssertEqual(nodeCount, list.count)
  }

  func testArrayLiteralInitTypeInfer() {
    let arrayLiteralInitInfer: LinkedList = [1.0, 2.0, 3.0]

    XCTAssertEqual(arrayLiteralInitInfer.count, 3)
    XCTAssertEqual(arrayLiteralInitInfer.first?.value, 1.0)
    XCTAssertEqual(arrayLiteralInitInfer.last?.value, 3.0)
    XCTAssertEqual(arrayLiteralInitInfer[1], 2.0)
    XCTAssertEqual(arrayLiteralInitInfer.removeLast(), 3.0)
    XCTAssertEqual(arrayLiteralInitInfer.count, 2)
  }

  func testArrayLiteralInitExplicit() {
    let arrayLiteralInitExplicit: LinkedList<Int> = [1, 2, 3]

    XCTAssertEqual(arrayLiteralInitExplicit.count, 3)
    XCTAssertEqual(arrayLiteralInitExplicit.first?.value, 1)
    XCTAssertEqual(arrayLiteralInitExplicit.last?.value, 3)
    XCTAssertEqual(arrayLiteralInitExplicit[1], 2)
    XCTAssertEqual(arrayLiteralInitExplicit.removeLast(), 3)
    XCTAssertEqual(arrayLiteralInitExplicit.count, 2)
  }
}
