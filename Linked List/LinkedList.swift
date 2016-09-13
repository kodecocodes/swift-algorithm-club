/*
  Doubly-linked list

  Most operations on the linked list have complexity O(n).
*/
open class LinkedListNode<T> {
  var value: T
  var next: LinkedListNode?
  weak var previous: LinkedListNode?

  public init(value: T) {
    self.value = value
  }
}

open class LinkedList<T> {
  public typealias Node = LinkedListNode<T>

  fileprivate var head: Node?

  open var isEmpty: Bool {
    return head == nil
  }

  open var first: Node? {
    return head
  }

  open var last: Node? {
    if var node = head {
      while case let next? = node.next {
        node = next
      }
      return node
    } else {
      return nil
    }
  }

  open var count: Int {
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

  open func nodeAt(_ index: Int) -> Node? {
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

  open subscript(index: Int) -> T {
    let node = nodeAt(index)
    assert(node != nil)
    return node!.value
  }

  open func append(_ value: T) {
    let newNode = Node(value: value)
    if let lastNode = last {
      newNode.previous = lastNode
      lastNode.next = newNode
    } else {
      head = newNode
    }
  }

  fileprivate func nodesBeforeAndAfter(_ index: Int) -> (Node?, Node?) {
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

  open func insert(_ value: T, atIndex index: Int) {
    let (prev, next) = nodesBeforeAndAfter(index)

    let newNode = Node(value: value)
    newNode.previous = prev
    newNode.next = next
    prev?.next = newNode
    next?.previous = newNode

    if prev == nil {
      head = newNode
    }
  }

  open func removeAll() {
    head = nil
  }

  open func remove(_ node: Node) -> T {
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

  open func removeLast() -> T {
    assert(!isEmpty)
    return remove(last!)
  }

  open func removeAt(_ index: Int) -> T {
    let node = nodeAt(index)
    assert(node != nil)
    return remove(node!)
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
  public func map<U>(_ transform: (T)-> U) -> LinkedList<U> {
    let result = LinkedList<U>()
    var node = head
    while node != nil {
        result.append(transform(node!.value))
      node = node!.next
    }
    return result
  }

  public func filter(_ predicate: (T)-> Bool) -> LinkedList<T> {
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
