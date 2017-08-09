import Foundation
import XCTest

private struct Message: Hashable {
  let text: String
  let priority: Int
  
  var hashValue: Int {
    return text.hashValue
  }
  
  static func == (lhs: Message, rhs: Message) -> Bool {
    return lhs.text == rhs.text
  }
  
  static func < (m1: Message, m2: Message) -> Bool {
    return m1.priority < m2.priority
  }
}

class HashedHeapTest: XCTestCase {
  override func setUp() {
    super.setUp()
    // last checked with Xcode 9.0b4
    #if swift(>=4.0)
      print("Hello, Swift 4!")
    #endif
  }
  
  func testEmpty() {
    var queue = HashedHeap<Message>(sort: <)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertNil(queue.peek())
    XCTAssertNil(queue.remove())
  }
  
  func testOneElement() {
    var queue = HashedHeap<Message>(sort: <)
    
    queue.insert(Message(text: "hello", priority: 100))
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 1)
    XCTAssertEqual(queue.peek()!.priority, 100)
    
    let result = queue.remove()
    XCTAssertEqual(result!.priority, 100)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertNil(queue.peek())
  }
  
  func testTwoElementsInOrder() {
    var queue = HashedHeap<Message>(sort: <)
    
    queue.insert(Message(text: "hello", priority: 100))
    queue.insert(Message(text: "world", priority: 200))
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 2)
    XCTAssertEqual(queue.peek()!.priority, 100)
    
    let result1 = queue.remove()
    XCTAssertEqual(result1!.priority, 100)
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 1)
    XCTAssertEqual(queue.peek()!.priority, 200)
    
    let result2 = queue.remove()
    XCTAssertEqual(result2!.priority, 200)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertNil(queue.peek())
  }
  
  func testTwoElementsOutOfOrder() {
    var queue = HashedHeap<Message>(sort: <)
    
    queue.insert(Message(text: "world", priority: 200))
    queue.insert(Message(text: "hello", priority: 100))
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 2)
    XCTAssertEqual(queue.peek()!.priority, 100)
    
    let result1 = queue.remove()
    XCTAssertEqual(result1!.priority, 100)
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 1)
    XCTAssertEqual(queue.peek()!.priority, 200)
    
    let result2 = queue.remove()
    XCTAssertEqual(result2!.priority, 200)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertNil(queue.peek())
  }
}
