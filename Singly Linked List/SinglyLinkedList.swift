import Foundation


/// Helper class to implement copy-on-write
fileprivate class IndirectStorage<T> {
    
  var head: SinglyLinkedListNode<T>?
    
  var tail: SinglyLinkedListNode<T>?
  
  init(head: SinglyLinkedListNode<T>?, tail: SinglyLinkedListNode<T>?) {
    self.head = head
    self.tail = tail
  }
  
  convenience init() {
    self.init(head: nil, tail: nil)
  }
}



// MARK: - NODE -

/// A node is the building block of a linked list.
/// It can be used on its own to create linked lists. However users of this class,
/// will need to manipulate references directly.
public class SinglyLinkedListNode<T> {
    
  /// Data container
  public var value: T
  
  /// Link to the next node
  public var next: SinglyLinkedListNode<T>?
  
  /// Designated initializer
  ///
  /// - Parameter value: A value
  public init(value: T) {
    self.value = value
  }
}



// MARK: - LINKED LIST -

/// Data structure to hold a collection of items.
/// Each nodes contains a reference to the next node.
/// The last node does not reference any other node.
/// This class implements value semantics based on copy-on-write.
///
/// However, the elements contained in the list, will be shallow copied if they
/// implement reference semantics.
public struct SinglyLinkedList<T> {
  // MARK: PROPERTIES
  
  // A level of inderiction, with reference semantics to allow easy
  // detection of when there are more than one references of the storage.
  private var storage: IndirectStorage<T>
  
  /// Whenever there's a change that potentially can change the value, this reference to the
  /// storage should be used to guarantee that a new copy is created and written on.
  private var storageForWritting: IndirectStorage<T> {
    
    mutating get {
      if !isKnownUniquelyReferenced(&storage) {
          storage = copyStorage()
      }
      return storage
    }
  }
  
  /// Returns the last element in the collection
  public var last: T? {
    get {
      return storage.tail?.value
    }
  }
  
  
  
  // MARK: INITIALIZERS
  
  /// Creates an empty list
  public init() {
    self.storage = IndirectStorage()
  }
  
  
  // MARK: EDITION
  
  /// Convenience method to append a value directly to the list
  ///
  /// - Parameter value: value to be added
  public mutating func append(value: T) {
    let node = SinglyLinkedListNode<T>(value: value)
    append(node: node)
  }
  
  
  /// Convenience method to prepend a value directly to the list
  ///
  /// - Parameter value: value to be added as the new head of the list
  public mutating func prepend(value: T) {
    let node = SinglyLinkedListNode<T>(value: value)
    prepend(node: node)
  }
  
  
  public mutating func deleteItem(at index:Int) -> T {
    precondition((index >= 0) && (index < count))
    
    var previous: SinglyLinkedListNode<T>? = nil
    var current = storageForWritting.head
    var i = 0
    var elementToDelete: SinglyLinkedListNode<T>
    
    while i < index {
      previous = current
      current = current?.next
      i += 1
    }
    
    // Current is now the element to delete (at index position.tag)
    elementToDelete = current!
    if storage.head === current {
      storageForWritting.head = current?.next
    }
    
    if storage.tail === current {
      storageForWritting.tail = previous
    }
    
    previous?.next = current?.next
    
    return elementToDelete.value
  }
  
  
  
  // MARK: SEARCH
  
  /// Returns the node located at the k-th to last position
  ///
  /// - Parameter kthToLast: 1 <= k <= N
  private func find(kthToLast: UInt, startingAt node: SinglyLinkedListNode<T>?, count: UInt) -> SinglyLinkedListNode<T>? {
    guard kthToLast <= count else {
      return nil
    }
    
    guard (node != nil) else {
      return nil
    }
    
    let i = (count - kthToLast)
    
    if i == 0 {
      return node
    }
    
    return find(kthToLast: kthToLast, startingAt: node?.next, count: (count - 1))
  }
  
  
  /// Returns the kth-to-last element in the list
  ///
  /// - Parameter kthToLast: Reversed ordinal number of the node to fetch.
  public func find(kthToLast: UInt) -> SinglyLinkedListNode<T>? {
    return find(kthToLast: kthToLast, startingAt: storage.head, count: UInt(count))
  }
    
}



// MARK:- Private Methods

private extension SinglyLinkedList {
    
  /// Adds a new node to the current head. This method can easily break value semantics. It is left
  /// for internal use.
  ///
  /// - Parameter node: the node that will be the new head of the list.
  private mutating func prepend(node: SinglyLinkedListNode<T>) {
    let (tailFromNewNode, _) = findTail(in: node)
    tailFromNewNode.next = storageForWritting.head
    storageForWritting.head = node
    
    if storage.tail == nil {
      storageForWritting.tail = tailFromNewNode
    }
  }
  
  /// Appends a new node to the list. This method can easily break value semantics. It is left
  /// for internal use.
  /// - Discussion: If the node to be inserted contains a loop, the node is appended but tail is set to nil.
  ///   This is a private method, therefore this can only happen directly under the control of this class.
  /// - Parameter node: node to be appended. (It can be a list, even contain loops).
  private mutating func append(node: SinglyLinkedListNode<T>) {
    if storage.tail != nil {
      // Copy on write: we are about to modify next a property in
      // a potentially shared node. Make sure it's new if necessary.
      storageForWritting.tail?.next = node
      let (tail, _) = findTail(in: node)
      storageForWritting.tail = tail // There
    } else {
      // This also means that there's no head.
      // Otherwise the state would be inconsistent.
      // This will be checked when adding and deleting nodes.
      storageForWritting.head = node
      let (tail, _) = findTail(in: node)
      storageForWritting.tail = tail // There
    }
  }
  
  /// Creates a copy of the linked list in a diffent memory location.
  ///
  /// - Returns: The copy to a new storage or a reference to the old one if no copy was necessary.
  private func copyStorage() -> IndirectStorage<T> {
    // If the list is empty, next time an item will be created, it won't affect
    // other instances of the list that came from copies derived from value types.
    // like assignments or parameters
    guard (storage.head != nil) && (storage.tail != nil) else {
      return IndirectStorage(head: nil, tail: nil)
    }
    
    // Create a new position in memory.
    // Note that we are shallow copying the value. If it was reference type
    // we just make a copy of the reference.
    let copiedHead = SinglyLinkedListNode<T>(value: storage.head!.value)
    var previousCopied: SinglyLinkedListNode<T> = copiedHead
    
    // Iterate through current list of nodes and copy them.
    var current: SinglyLinkedListNode<T>? = storage.head?.next
    
    while current != nil {
      // Create a copy
      let currentCopy = SinglyLinkedListNode<T>(value: current!.value)
      
      // Create links
      previousCopied.next = currentCopy
      
      // Update pointers
      current = current?.next
      previousCopied = currentCopy
    }
    
    return IndirectStorage(head: copiedHead, tail: previousCopied)
  }
}



// MARK:- Extensions when comparable

extension SinglyLinkedList where T: Comparable {
  /// Deletes node containing a given value
  ///
  /// - Parameter v: value of the node to be deleted.
  public mutating func deleteNode(withValue v: T) {
    
    guard storage.head != nil else {
      return
    }
    
    var previous: SinglyLinkedListNode<T>? = nil
    var current = storage.head
    
    while (current != nil) && (current?.value != v) {
      previous = current
      current = current?.next
    }
    
    if let foundNode = current {
      
      if storage.head === foundNode {
        storageForWritting.head = foundNode.next
      }
      
      if storage.tail === foundNode {
        storage.tail = previous
      }
      
      previous?.next = foundNode.next
      foundNode.next = nil
    }
  }
  
  
  /// Deletes duplicates without using additional structures like a set to keep track the visited nodes.
  /// - Complexity: O(N^2)
  public mutating func deleteDuplicatesInPlace() {
    // Copy on write: this updates storage if necessary.
    var current = storageForWritting.head
    
    while current != nil {
      var previous: SinglyLinkedListNode<T>? = current
      var next = current?.next
      
      while next != nil {
        if current?.value == next?.value {
          
          if storage.head === next {
            storage.head = next?.next
          }
          
          if storage.tail === next {
            storage.tail = previous
          }
          
          // Delete next
          previous?.next = next?.next
        }
        previous = next
        next = next?.next
      }
      current = current?.next
    }
  }
}



// MARK: - COLLECTION -

extension SinglyLinkedList : Collection {
    
  public typealias Index = SinglyLinkedListIndex<T>
  
  public var startIndex: Index {
    get {
      return SinglyLinkedListIndex<T>(node: storage.head, tag: 0)
    }
  }
  
  public var endIndex: Index {
    get {
      if let h = storage.head {
        let (_, numberOfElements) = findTail(in: h)
        return SinglyLinkedListIndex<T>(node: h, tag: numberOfElements)
      } else {
        return SinglyLinkedListIndex<T>(node: nil, tag: startIndex.tag)
      }
    }
  }
  
  public subscript(position: Index) -> T {
    get {
      return position.node!.value
    }
  }
  
  public func index(after idx: Index) -> Index {
    return SinglyLinkedListIndex<T>(node: idx.node?.next, tag: idx.tag+1)
  }
}



// MARK: - EXPRESSIBLE-BY-ARRAY-LITERAL -

extension SinglyLinkedList : ExpressibleByArrayLiteral {
  public typealias Element = T
  
  public init(arrayLiteral elements: Element...) {
    var headSet = false
    var current : SinglyLinkedListNode<T>?
    var numberOfElements = 0
    storage = IndirectStorage()
    
    for element in elements {
      
      numberOfElements += 1
      
      if headSet == false {
        storage.head = SinglyLinkedListNode<T>(value: element)
        current = storage.head
        headSet = true
      } else {
        let newNode = SinglyLinkedListNode<T>(value: element)
        current?.next = newNode
        current = newNode
      }
    }
    storage.tail = current
  }
}



// MARK: - FORWARD-INDEX -

public struct SinglyLinkedListIndex<T> : Comparable {
  fileprivate let node: SinglyLinkedListNode<T>?
  fileprivate let tag: Int
  
  public static func==<T>(lhs: SinglyLinkedListIndex<T>, rhs: SinglyLinkedListIndex<T>) -> Bool {
    return (lhs.tag == rhs.tag)
  }
  
  public static func< <T>(lhs: SinglyLinkedListIndex<T>, rhs: SinglyLinkedListIndex<T>) -> Bool {
    return (lhs.tag < rhs.tag)
  }
}


extension SinglyLinkedList where T : KeyValuePair {
    
  public func find(elementWithKey key: T.K) -> T? {
    let searchResults = filter { (keyValuePair) -> Bool in
      return keyValuePair.key == key
    }
    
    return searchResults.first
  }
}

// MARK: - HELPERS -

func findTail<T>(in node: SinglyLinkedListNode<T>) -> (tail: SinglyLinkedListNode<T>, count: Int) {
  // Assign the tail
  // Note that the passed node can already be linking to other nodes,
  // so the tail needs to be calculated.
  var current: SinglyLinkedListNode<T>? = node
  var count = 1
  
  while current?.next != nil {
    current = current?.next
    count += 1
  }
  
  if current != nil {
    return (tail: current!, count: count)
  } else {
    return (tail: node, count: 1)
  }
}
