public class LinkedListNode<T: Comparable> {
  var value: T
  var next: LinkedListNode?
  var previous: LinkedListNode?

  public init(value: T) {
    self.value = value
  }
}

public class BoundedPriorityQueue<T: Comparable> {
  private typealias Node = LinkedListNode<T>

  private(set) public var count = 0
  fileprivate var head: Node?
  private var tail: Node?
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

  public func enqueue(_ value: T) {
    if let node = insert(value, after: findInsertionPoint(value)) {
      // If the newly inserted node is the last one in the list, then update
      // the tail pointer.
      if node.next == nil {
        tail = node
      }

      // If the queue is full, then remove an element from the back.
      count += 1
      if count > maxElements {
        removeLeastImportantElement()
      }
    }
  }

  private func insert(_ value: T, after: Node?) -> Node? {
    if let previous = after {

      // If the queue is full and we have to insert at the end of the list,
      // then there's no reason to insert the new value.
      if count == maxElements && previous.next == nil {
        print("Queue is full and priority of new object is too small")
        return nil
      }

      // Put the new node in between previous and previous.next (if exists).
      let node = Node(value: value)
      node.next = previous.next
      previous.next?.previous = node
      previous.next = node
      node.previous = previous
      return node

    } else if let first = head {
      // Have to insert at the head, so shift the existing head up once place.
      head = Node(value: value)
      head!.next = first
      first.previous = head
      return head

    } else {
      // This is the very first item in the queue.
      head = Node(value: value)
      return head
    }
  }

  /* Find the node after which to insert the new value. If this returns nil,
     the new value should be inserted at the head of the list. */
  private func findInsertionPoint(_ value: T) -> Node? {
    var node = head
    var prev: Node? = nil

    while let current = node, value < current.value {
      prev = node
      node = current.next
    }
    return prev
  }

  private func removeLeastImportantElement() {
    if let last = tail {
      tail = last.previous
      tail?.next = nil
      count -= 1
    }

    // Note: Instead of using a tail pointer, we could just scan from the new
    // node until the end. Then nodes also don't need a previous pointer. But
    // this is much slower on large lists.
  }

  public func dequeue() -> T? {
    if let first = head {
      count -= 1
      if count == 0 {
        head = nil
        tail = nil
      } else {
        head = first.next
        head!.previous = nil
      }
      return first.value
    } else {
      return nil
    }
  }
}

extension LinkedListNode: CustomStringConvertible {
  public var description: String {
    return "\(value)"
  }
}

extension BoundedPriorityQueue: CustomStringConvertible {
  public var description: String {
    var s = "<"
    var node = head
    while let current = node {
      s += "\(current), "
      node = current.next
    }
    return s + ">"
  }
}
