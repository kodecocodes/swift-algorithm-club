//
//  BoundedPriorityQueueTests.swift
//
//  Created by John Gill on 2/28/16.
//

import Foundation
import XCTest

private struct Message: Comparable {
  let name: String
  let priority: Int
}

private func == (m1: Message, m2: Message) -> Bool {
  return m1.priority == m2.priority
}

private func < (m1: Message, m2: Message) -> Bool {
  return m1.priority < m2.priority
}

private func > (m1: Message, m2: Message) -> Bool {
  return m1.priority > m2.priority
}

class BoundedPriorityQueueTest: XCTestCase {
  func testEmpty() {
    let queue = BoundedPriorityQueue<Message>(maxElements: 5)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertNil(queue.dequeue())
  }

  func testOneElement() {
    let queue = BoundedPriorityQueue<Message>(maxElements: 5)

    queue.enqueue(Message(name: "hello", priority: 100))
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 1)

    let result = queue.dequeue()
    XCTAssertEqual(result!.priority, 100)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
  }

  func testMaxElements() {
    let queue = BoundedPriorityQueue<Message>(maxElements: 5)
    XCTAssertTrue(queue.isEmpty)

    queue.enqueue(Message(name: "john", priority: 100))
    XCTAssertEqual(queue.count, 1)
    XCTAssertEqual(queue.peek()?.priority, 100)

    queue.enqueue(Message(name: "james", priority: 200))
    XCTAssertEqual(queue.count, 2)
    XCTAssertEqual(queue.peek()?.priority, 200)

    queue.enqueue(Message(name: "mark", priority: 300))
    XCTAssertEqual(queue.count, 3)
    XCTAssertEqual(queue.peek()?.priority, 300)

    queue.enqueue(Message(name: "ken", priority: 400))
    XCTAssertEqual(queue.count, 4)
    XCTAssertEqual(queue.peek()?.priority, 400)

    queue.enqueue(Message(name: "thomas", priority: 500))
    XCTAssertEqual(queue.count, 5)
    XCTAssertEqual(queue.peek()?.priority, 500)

    queue.enqueue(Message(name: "melanie", priority: 550))
    XCTAssertEqual(queue.count, 5)
    XCTAssertEqual(queue.peek()?.priority, 550)

    queue.enqueue(Message(name: "lily", priority: 450))
    XCTAssertEqual(queue.count, 5)
    XCTAssertEqual(queue.peek()?.priority, 550)

    queue.enqueue(Message(name: "fred", priority: 350))
    XCTAssertEqual(queue.count, 5)
    XCTAssertEqual(queue.peek()?.priority, 550)

    queue.enqueue(Message(name: "rachel", priority: 50))
    XCTAssertEqual(queue.count, 5)
    XCTAssertEqual(queue.peek()?.priority, 550)

    var result = queue.dequeue()
    XCTAssertEqual(result!.priority, 550)
    XCTAssertEqual(queue.count, 4)

    result = queue.dequeue()
    XCTAssertEqual(result!.priority, 500)
    XCTAssertEqual(queue.count, 3)

    result = queue.dequeue()
    XCTAssertEqual(result!.priority, 450)
    XCTAssertEqual(queue.count, 2)

    queue.enqueue(Message(name: "ryan", priority: 150))
    XCTAssertEqual(queue.count, 3)
    XCTAssertEqual(queue.peek()?.priority, 400)

    result = queue.dequeue()
    XCTAssertEqual(result!.priority, 400)
    XCTAssertEqual(queue.count, 2)

    result = queue.dequeue()
    XCTAssertEqual(result!.priority, 350)
    XCTAssertEqual(queue.count, 1)

    result = queue.dequeue()
    XCTAssertEqual(result!.priority, 150)
    XCTAssertEqual(queue.count, 0)

    result = queue.dequeue()
    XCTAssertNil(result)
    XCTAssertEqual(queue.count, 0)
    XCTAssertTrue(queue.isEmpty)
  }
}
