//
//  BoundedPriorityQueue.swift
//
//  Created by John Gill on 2/28/16.
//

public class LinkedListNode<T: Comparable> {
  var value: T
  var next: LinkedListNode?
  var previous: LinkedListNode?
  
  public init(value: T) {
    self.value = value
    self.next = nil
    self.previous = nil
  }
}

public class BoundedPriorityQueue<T: Comparable> {
  private typealias Node = LinkedListNode<T>

  private(set) public var count = 0
  private var head: Node?
  private var maxElements: Int

  public init(maxElements: Int) {
    self.maxElements = maxElements
  }

  public var isEmpty: Bool {
    return count == 0
  }

  public func peek() -> T? {
    return head?.value
  }

  public func enqueue(value: T) {
    let newNode = Node(value: value)

    if head == nil  {
      head = newNode
      count = 1
      return
    }

    var node = head
    if count == maxElements && newNode.value > node!.value {
      return
    }
    
    while (node!.next != nil) && (newNode.value < node!.value) {
      node = node!.next
    }
    
    if newNode.value < node!.value {
      newNode.next = node!.next
      newNode.previous = node
      
      if newNode.next != nil {     /* TAIL */
        newNode.next!.previous = newNode
      }
      node!.next = newNode
    } else {
      newNode.previous = node!.previous
      newNode.next = node
      if node!.previous == nil {   /* HEAD */
        head = newNode
      } else {
        node!.previous!.next = newNode
      }
      node!.previous = newNode
    }

    if count == maxElements {
      dequeue()
    }
    count += 1
  }
  
  public func dequeue() -> T? {
    if count == 0 {
      return nil
    }

    let retVal = head!.value
    
    if count == 1 {
      head = nil
    } else {
      head = head!.next
      head!.previous = nil
    }

    count -= 1
    return retVal
  }
}
