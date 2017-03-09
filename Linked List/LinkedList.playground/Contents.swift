//: Playground - noun: a place where people can play

public class LinkedListNode<T> {
  var value: T
  var next: LinkedListNode?
  weak var previous: LinkedListNode?
  
  public init(value: T) {
    self.value = value
  }
}

public final class LinkedList<T> {
  public typealias Node = LinkedListNode<T>
  
  fileprivate var head: Node?
  
  public init() {}
  
  public var isEmpty: Bool {
    return head == nil
  }
  
  public var first: Node? {
    return head
  }
  
  public var last: Node? {
    if var node = head {
      while case let next? = node.next {
        node = next
      }
      return node
    } else {
      return nil
    }
  }
  
  public var count: Int {
    if var node = head {
      var c = 1
      while case let next? = node.next {
        node = next
        c += 1
      }
      return c
    } else {
      return 0
    }
  }
  
  public func node(atIndex index: Int) -> Node? {
    if index >= 0 {
      var node = head
      var i = index
      while node != nil {
        if i == 0 { return node }
        i -= 1
        node = node!.next
      }
    }
    return nil
  }
  
  public subscript(index: Int) -> T {
    let node = self.node(atIndex: index)
    assert(node != nil)
    return node!.value
  }
  
  public func append(_ value: T) {
    let newNode = Node(value: value)
    self.append(newNode)
  }
  
  public func append(_ newNode: Node) {
    if let lastNode = last {
      newNode.previous = lastNode
      lastNode.next = newNode
    } else {
      head = newNode
    }
  }
  
  private func nodesBeforeAndAfter(index: Int) -> (Node?, Node?) {
    assert(index >= 0)
    
    var i = index
    var next = head
    var prev: Node?
    
    while next != nil && i > 0 {
      i -= 1
      prev = next
      next = next!.next
    }
    assert(i == 0)  // if > 0, then specified index was too large
    
    return (prev, next)
  }
  
  public func insert(_ value: T, atIndex index: Int) {
    let newNode = Node(value: value)
    self.insert(newNode, atIndex: index)
  }
  
  public func insert(_ newNode: Node, atIndex index: Int) {
    let (prev, next) = nodesBeforeAndAfter(index: index)
    
    newNode.previous = prev
    newNode.next = next
    prev?.next = newNode
    next?.previous = newNode
    
    if prev == nil {
      head = newNode
    }
  }
  
  public func removeAll() {
    head = nil
  }
  
  @discardableResult public func remove(node: Node) -> T {
    let prev = node.previous
    let next = node.next
    
    if let prev = prev {
      prev.next = next
    } else {
      head = next
    }
    next?.previous = prev
    
    node.previous = nil
    node.next = nil
    return node.value
  }
  
  @discardableResult public func removeLast() -> T {
    assert(!isEmpty)
    return remove(node: last!)
  }
  
  @discardableResult public func remove(atIndex index: Int) -> T {
    let node = self.node(atIndex: index)
    assert(node != nil)
    return remove(node: node!)
  }
}

extension LinkedList: CustomStringConvertible {
  public var description: String {
    var s = "["
    var node = head
    while node != nil {
      s += "\(node!.value)"
      node = node!.next
      if node != nil { s += ", " }
    }
    return s + "]"
  }
}

extension LinkedList {
  public func reverse() {
    var node = head
    while let currentNode = node {
      node = currentNode.next
      swap(&currentNode.next, &currentNode.previous)
      head = currentNode
    }
  }
}

extension LinkedList {
  public func map<U>(transform: (T) -> U) -> LinkedList<U> {
    let result = LinkedList<U>()
    var node = head
    while node != nil {
      result.append(transform(node!.value))
      node = node!.next
    }
    return result
  }
  
  public func filter(predicate: (T) -> Bool) -> LinkedList<T> {
    let result = LinkedList<T>()
    var node = head
    while node != nil {
      if predicate(node!.value) {
        result.append(node!.value)
      }
      node = node!.next
    }
    return result
  }
}

extension LinkedList {
  convenience init(array: Array<T>) {
    self.init()
    
    for element in array {
      self.append(element)
    }
  }
}

extension LinkedList: ExpressibleByArrayLiteral {
  public convenience init(arrayLiteral elements: T...) {
    self.init()
    
    for element in elements {
      self.append(element)
    }
  }
}

let list = LinkedList<String>()
list.isEmpty                  // true
list.first                    // nil
list.last                     // nil

list.append("Hello")
list.isEmpty
list.first!.value             // "Hello"
list.last!.value              // "Hello"
list.count                    // 1

list.append("World")
list.first!.value             // "Hello"
list.last!.value              // "World"
list.count                    // 2

list.first!.previous          // nil
list.first!.next!.value       // "World"
list.last!.previous!.value    // "Hello"
list.last!.next               // nil

list.node(atIndex: 0)!.value    // "Hello"
list.node(atIndex: 1)!.value    // "World"
list.node(atIndex: 2)           // nil

list[0]     // "Hello"
list[1]     // "World"
//list[2]   // crash!

list.insert("Swift", atIndex: 1)
list[0]
list[1]
list[2]
print(list)

list.reverse()   // [World, Swift, Hello]

list.node(atIndex: 0)!.value = "Universe"
list.node(atIndex: 1)!.value = "Swifty"
let m = list.map { s in s.characters.count }
m    // [8, 6, 5]
let f = list.filter { s in s.characters.count > 5 }
f    // [Universe, Swifty]

//list.removeAll()
//list.isEmpty

list.remove(node: list.first!) // "Hello"
list.count                     // 2
list[0]                        // "Swift"
list[1]                        // "World"

list.removeLast()              // "World"
list.count                     // 1
list[0]                        // "Swift"

list.remove(atIndex: 0)        // "Swift"
list.count                     // 0

let linkedList: LinkedList<Int> = [1, 2, 3, 4] // [1, 2, 3, 4]
linkedList.count               // 4
linkedList[0]                  // 1

// Infer the type from the array
let listArrayLiteral2: LinkedList = ["Swift", "Algorithm", "Club"]
listArrayLiteral2.count        // 3
listArrayLiteral2[0]           // "Swift"
listArrayLiteral2.removeLast() // "Club"
