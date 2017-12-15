/*
 Last-in first-out stack (LIFO)
 Push and pop are O(1) operations.
 */
public struct Stack<T> {
  fileprivate var array = [T]()
  
  public var isEmpty: Bool {
    return array.isEmpty
  }
  
  public var count: Int {
    return array.count
  }
  
  public mutating func push(_ element: T) {
    array.append(element)
  }
  
  public mutating func pop() -> T? {
    return array.popLast()
  }
  
  public var top: T? {
    return array.last
  }
}

extension Stack: Sequence {
  public func makeIterator() -> AnyIterator<T> {
    var curr = self
    return AnyIterator {
      return curr.pop()
    }
  }
}

protocol StackProtocol {
  associatedtype T
  var count: Int { get }
  var isEmpty: Bool { get }
  func push(item: T)
  func pop() -> T?
}

// LinkedList implementation of Stack
class LinkedList<T>: StackProtocol {
  
  public class LinkedListNode<T> {
    var value: T
    var next: LinkedListNode?
    
    init(value: T) {
      self.value = value
    }
  }
  
  private var counter = 0
  
  // the number of items - O(1)
  var count: Int {
    return counter
  }
  
  private var first: LinkedListNode<T>?
  
  var isEmpty: Bool {
    return first == nil
  }
  
  public func push(item: T) {
    let oldFirst = first
    first = LinkedListNode(value: item)
    first?.value = item
    first?.next = oldFirst
    
    counter += 1
  }
  
  func pop() -> T? {
    if let item = first?.value {
      
      first = first?.next
      
      counter -= 1
      return item
    }
    return nil
  }
}


