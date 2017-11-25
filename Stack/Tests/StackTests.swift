import Foundation
import XCTest

class StackTest: XCTestCase {
  func testEmpty() {
    var stack = Stack<Int>()
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(stack.count, 0)
    XCTAssertEqual(stack.top, nil)
    XCTAssertNil(stack.pop())
  }
  
  func testLLStackEmpty() {
    let linkedListStack = StackLinkedList<Int>()
    XCTAssertTrue(linkedListStack.isEmpty())
    XCTAssertEqual(linkedListStack.count, 0)
    XCTAssertNil(linkedListStack.pop())
  }
  
  func testOneElement() {
    var stack = Stack<Int>()
    
    stack.push(123)
    XCTAssertFalse(stack.isEmpty)
    XCTAssertEqual(stack.count, 1)
    XCTAssertEqual(stack.top, 123)
    
    let result = stack.pop()
    XCTAssertEqual(result, 123)
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(stack.count, 0)
    XCTAssertEqual(stack.top, nil)
    XCTAssertNil(stack.pop())
  }
  
  func testOneElementLLStack() {
    let stack = StackLinkedList<Int>()
    
    stack.push(item: 123)
    XCTAssertFalse(stack.isEmpty())
    XCTAssertEqual(stack.count, 1)
    
    let result = stack.pop()
    XCTAssertEqual(result, 123)
    XCTAssertTrue(stack.isEmpty())
    XCTAssertEqual(stack.count, 0)
    XCTAssertNil(stack.pop())
  }
  
  func testTwoElements() {
    var stack = Stack<Int>()
    
    stack.push(123)
    stack.push(456)
    XCTAssertFalse(stack.isEmpty)
    XCTAssertEqual(stack.count, 2)
    XCTAssertEqual(stack.top, 456)
    
    let result1 = stack.pop()
    XCTAssertEqual(result1, 456)
    XCTAssertFalse(stack.isEmpty)
    XCTAssertEqual(stack.count, 1)
    XCTAssertEqual(stack.top, 123)
    
    let result2 = stack.pop()
    XCTAssertEqual(result2, 123)
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(stack.count, 0)
    XCTAssertEqual(stack.top, nil)
    XCTAssertNil(stack.pop())
  }
  
  func testTwoElementsLLStack() {
    let stack = StackLinkedList<Int>()
    
    stack.push(item: 123)
    stack.push(item: 456)
    XCTAssertFalse(stack.isEmpty())
    XCTAssertEqual(stack.count, 2)
    
    let result1 = stack.pop()
    XCTAssertEqual(result1, 456)
    XCTAssertFalse(stack.isEmpty())
    XCTAssertEqual(stack.count, 1)
    
    let result2 = stack.pop()
    XCTAssertEqual(result2, 123)
    XCTAssertTrue(stack.isEmpty())
    XCTAssertEqual(stack.count, 0)
    XCTAssertNil(stack.pop())
  }
  
  func testMakeEmpty() {
    var stack = Stack<Int>()
    
    stack.push(123)
    stack.push(456)
    XCTAssertNotNil(stack.pop())
    XCTAssertNotNil(stack.pop())
    XCTAssertNil(stack.pop())
    
    stack.push(789)
    XCTAssertEqual(stack.count, 1)
    XCTAssertEqual(stack.top, 789)
    
    let result = stack.pop()
    XCTAssertEqual(result, 789)
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(stack.count, 0)
    XCTAssertEqual(stack.top, nil)
    XCTAssertNil(stack.pop())
  }
  
  func testMakeEmptyLLStack() {
    let stack = StackLinkedList<Int>()
    
    stack.push(item: 123)
    stack.push(item: 456)
    XCTAssertNotNil(stack.pop())
    XCTAssertNotNil(stack.pop())
    XCTAssertNil(stack.pop())
    
    stack.push(item: 789)
    XCTAssertEqual(stack.count, 1)
    
    let result = stack.pop()
    XCTAssertEqual(result, 789)
    XCTAssertTrue(stack.isEmpty())
    XCTAssertEqual(stack.count, 0)
    XCTAssertNil(stack.pop())
  }
}
