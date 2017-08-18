//: # Linked Lists

// For best results, don't forget to select "Show Rendered Markup" from XCode's "Editor" menu

//: Linked List Class Declaration:
// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

public final class LinkedList<T> {

  /// Linked List's Node Class Declaration
  public class LinkedListNode<T> {
    var value: T
    var next: LinkedListNode?
    weak var previous: LinkedListNode?

    public init(value: T) {
      self.value = value
    }
  }

  /// Typealiasing the node class to increase readability of code
  public typealias Node = LinkedListNode<T>

  /// The head of the Linked List
  fileprivate var head: Node?

  /// Default initializer
  public init() {}

  /// Computed property to check if the linked list is empty
  public var isEmpty: Bool {
    return head == nil
  }

  /// Computed property to get the first node in the linked list (if any)
  public var first: Node? {
    return head
  }

  /// Computed property to iterate through the linked list and return the last node in the list (if any)
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

  /// Computed property to iterate through the linked list and return the total number of nodes
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

  /// Function to return the node at a specific index. Crashes if index is out of bounds (0...self.count)
  ///
  /// - Parameter index: Integer value of the node's index to be returned
  /// - Returns: Optional LinkedListNode
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

  /// Subscript function to return the node at a specific index
  ///
  /// - Parameter index: Integer value of the requested value's index
  public subscript(index: Int) -> T {
    let node = self.node(atIndex: index)
    assert(node != nil)
    return node!.value
  }

  /// Append a value to the end of the list
  ///
  /// - Parameter value: The data value to be appended
  public func append(_ value: T) {
    let newNode = Node(value: value)
    self.append(newNode)
  }

  /// Append a copy of a LinkedListNode to the end of the list.
  ///
  /// - Parameter node: The node containing the value to be appended
  public func append(_ node: Node) {
    let newNode = LinkedListNode(value: node.value)
    if let lastNode = last {
      newNode.previous = lastNode
      lastNode.next = newNode
    } else {
      head = newNode
    }
  }

  /// Append a copy of a LinkedList to the end of the list.
  ///
  /// - Parameter list: The list to be copied and appended.
  public func append(_ list: LinkedList) {
    var nodeToCopy = list.head
    while let node = nodeToCopy {
      self.append(node.value)
      nodeToCopy = node.next
    }
  }

  /// A private helper funciton to find the nodes before and after a specified index. Crashes if index is out of bounds (0...self.count)
  ///
  /// - Parameter index: Integer value of the index between the nodes.
  /// - Returns: A tuple of 2 nodes before & after the specified index respectively.
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

  /// Insert a value at a specific index. Crashes if index is out of bounds (0...self.count)
  ///
  /// - Parameters:
  ///   - value: The data value to be inserted
  ///   - index: Integer value of the index to be insterted at
  public func insert(_ value: T, atIndex index: Int) {
    let newNode = Node(value: value)
    self.insert(newNode, atIndex: index)
  }

  /// Insert a copy of a node at a specific index. Crashes if index is out of bounds (0...self.count)
  ///
  /// - Parameters:
  ///   - node: The node containing the value to be inserted
  ///   - index: Integer value of the index to be inserted at
  public func insert(_ node: Node, atIndex index: Int) {
    let (prev, next) = nodesBeforeAndAfter(index: index)
    let newNode = LinkedListNode(value: node.value)
    newNode.previous = prev
    newNode.next = next
    prev?.next = newNode
    next?.previous = newNode

    if prev == nil {
      head = newNode
    }
  }

  /// Insert a copy of a LinkedList at a specific index. Crashes if index is out of bounds (0...self.count)
  ///
  /// - Parameters:
  ///   - list: The LinkedList to be copied and inserted
  ///   - index: Integer value of the index to be inserted at
  public func insert(_ list: LinkedList, atIndex index: Int) {
    if list.isEmpty { return }
    var (prev, next) = nodesBeforeAndAfter(index: index)
    var nodeToCopy = list.head
    var newNode: Node?
    while let node = nodeToCopy {
      newNode = Node(value: node.value)
      newNode?.previous = prev
      if let previous = prev {
        previous.next = newNode
      } else {
        self.head = newNode
      }
      nodeToCopy = nodeToCopy?.next
      prev = newNode
    }
    prev?.next = next
    next?.previous = prev
  }

  /// Function to remove all nodes/value from the list
  public func removeAll() {
    head = nil
  }

  /// Function to remove a specific node.
  ///
  /// - Parameter node: The node to be deleted
  /// - Returns: The data value contained in the deleted node.
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

  /// Function to remove the last node/value in the list. Crashes if the list is empty
  ///
  /// - Returns: The data value contained in the deleted node.
  @discardableResult public func removeLast() -> T {
    assert(!isEmpty)
    return remove(node: last!)
  }

  /// Function to remove a node/value at a specific index. Crashes if index is out of bounds (0...self.count)
  ///
  /// - Parameter index: Integer value of the index of the node to be removed
  /// - Returns: The data value contained in the deleted node
  @discardableResult public func remove(atIndex index: Int) -> T {
    let node = self.node(atIndex: index)
    assert(node != nil)
    return remove(node: node!)
  }
}

//: End of the base class declarations & beginning of extensions' declarations:

// MARK: - Extension to enable the standard conversion of a list to String 
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

// MARK: - Extension to add a 'reverse' function to the list
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

// MARK: - An extension with an implementation of 'map' & 'filter' functions
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

// MARK: - Extension to enable initialization from an Array
extension LinkedList {
  convenience init(array: Array<T>) {
    self.init()

    for element in array {
      self.append(element)
    }
  }
}

// MARK: - Extension to enable initialization from an Array Literal
extension LinkedList: ExpressibleByArrayLiteral {
  public convenience init(arrayLiteral elements: T...) {
    self.init()

    for element in elements {
      self.append(element)
    }
  }
}

//: Ok, now that the declarations are done, let's see our Linked List in action:
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

let list2 = LinkedList<String>()
list2.append("Goodbye")
list2.append("World")
list.append(list2)            // [Hello, World, Goodbye, World]
list2.removeAll()             // [ ]
list2.isEmpty                 // true
list.removeLast()             // "World"
list.remove(atIndex: 2)       // "Goodbye"

list.insert("Swift", atIndex: 1)
list[0]     // "Hello"
list[1]     // "Swift"
list[2]     // "World"
print(list)

list.reverse()   // [World, Swift, Hello]

list.node(atIndex: 0)!.value = "Universe"
list.node(atIndex: 1)!.value = "Swifty"
let m = list.map { s in s.characters.count }
m    // [8, 6, 5]
let f = list.filter { s in s.characters.count > 5 }
f    // [Universe, Swifty]

list.remove(node: list.first!) // "Universe"
list.count                     // 2
list[0]                        // "Swifty"
list[1]                        // "Hello"

list.removeLast()              // "Hello"
list.count                     // 1
list[0]                        // "Swifty"

list.remove(atIndex: 0)        // "Swifty"
list.count                     // 0

let linkedList: LinkedList<Int> = [1, 2, 3, 4] // [1, 2, 3, 4]
linkedList.count               // 4
linkedList[0]                  // 1

// Infer the type from the array
let listArrayLiteral2: LinkedList = ["Swift", "Algorithm", "Club"]
listArrayLiteral2.count        // 3
listArrayLiteral2[0]           // "Swift"
listArrayLiteral2.removeLast()  // "Club"
