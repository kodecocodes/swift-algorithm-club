import Foundation
import XCTest

private struct Message {
  let text: String
  let priority: Int
}

private func < (m1: Message, m2: Message) -> Bool {
  return m1.priority < m2.priority
}

class PriorityQueueTest: XCTestCase {
  func testEmpty() {
    var queue = PriorityQueue<Message>(sort: <)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertNil(queue.peek())
    XCTAssertNil(queue.dequeue())
  }

  func testOneElement() {
    var queue = PriorityQueue<Message>(sort: <)

    queue.enqueue(Message(text: "hello", priority: 100))
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 1)
    XCTAssertEqual(queue.peek()!.priority, 100)

    let result = queue.dequeue()
    XCTAssertEqual(result!.priority, 100)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertNil(queue.peek())
  }

  func testTwoElementsInOrder() {
    var queue = PriorityQueue<Message>(sort: <)

    queue.enqueue(Message(text: "hello", priority: 100))
    queue.enqueue(Message(text: "world", priority: 200))
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 2)
    XCTAssertEqual(queue.peek()!.priority, 100)

    let result1 = queue.dequeue()
    XCTAssertEqual(result1!.priority, 100)
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 1)
    XCTAssertEqual(queue.peek()!.priority, 200)

    let result2 = queue.dequeue()
    XCTAssertEqual(result2!.priority, 200)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertNil(queue.peek())
  }

  func testTwoElementsOutOfOrder() {
    var queue = PriorityQueue<Message>(sort: <)

    queue.enqueue(Message(text: "world", priority: 200))
    queue.enqueue(Message(text: "hello", priority: 100))
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 2)
    XCTAssertEqual(queue.peek()!.priority, 100)

    let result1 = queue.dequeue()
    XCTAssertEqual(result1!.priority, 100)
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 1)
    XCTAssertEqual(queue.peek()!.priority, 200)

    let result2 = queue.dequeue()
    XCTAssertEqual(result2!.priority, 200)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertNil(queue.peek())
  }
}
