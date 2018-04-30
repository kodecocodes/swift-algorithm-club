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
    private(set) var head: Node?
    
    /// Computed property to iterate through the linked list and return the last node in the list (if any)
    public var last: Node? {
        guard var node = head else {
            return nil
        }
        
        while let next = node.next {
            node = next
        }
        return node
    }
    
    /// Computed property to check if the linked list is empty
    public var isEmpty: Bool {
        return head == nil
    }
    
    /// Computed property to iterate through the linked list and return the total number of nodes
    public var count: Int {
        guard var node = head else {
            return 0
        }
        
        var count = 1
        while let next = node.next {
            node = next
            count += 1
        }
        return count
    }
    
    /// Default initializer
    public init() {}
    
    
    /// Subscript function to return the node at a specific index
    ///
    /// - Parameter index: Integer value of the requested value's index
    public subscript(index: Int) -> T {
        let node = self.node(at: index)
        return node.value
    }
    
    /// Function to return the node at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameter index: Integer value of the node's index to be returned
    /// - Returns: LinkedListNode
    public func node(at index: Int) -> Node {
        assert(head != nil, "List is empty")
        assert(index >= 0, "index must be greater than 0")
        
        if index == 0 {
            return head!
        } else {
            var node = head!.next
            for _ in 1..<index {
                node = node?.next
                if node == nil {
                    break
                }
            }
            
            assert(node != nil, "index is out of bounds.")
            return node!
        }
    }
    
    /// Append a value to the end of the list
    ///
    /// - Parameter value: The data value to be appended
    public func append(_ value: T) {
        let newNode = Node(value: value)
        append(newNode)
    }
    
    /// Append a copy of a LinkedListNode to the end of the list.
    ///
    /// - Parameter node: The node containing the value to be appended
    public func append(_ node: Node) {
        let newNode = node
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
            append(node.value)
            nodeToCopy = node.next
        }
    }
    
    /// Insert a value at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameters:
    ///   - value: The data value to be inserted
    ///   - index: Integer value of the index to be insterted at
    public func insert(_ value: T, at index: Int) {
        let newNode = Node(value: value)
        insert(newNode, at: index)
    }
    
    /// Insert a copy of a node at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameters:
    ///   - node: The node containing the value to be inserted
    ///   - index: Integer value of the index to be inserted at
    public func insert(_ newNode: Node, at index: Int) {
        if index == 0 {
            newNode.next = head
            head?.previous = newNode
            head = newNode
        } else {
            let prev = node(at: index - 1)
            let next = prev.next
            newNode.previous = prev
            newNode.next = next
            next?.previous = newNode
            prev.next = newNode
        }
    }
    
    /// Insert a copy of a LinkedList at a specific index. Crashes if index is out of bounds (0...self.count)
    ///
    /// - Parameters:
    ///   - list: The LinkedList to be copied and inserted
    ///   - index: Integer value of the index to be inserted at
    public func insert(_ list: LinkedList, at index: Int) {
        if list.isEmpty { return }
        
        if index == 0 {
            list.last?.next = head
            head = list.head
        } else {
            let prev = node(at: index - 1)
            let next = prev.next
            
            prev.next = list.head
            list.head?.previous = prev
            
            list.last?.next = next
            next?.previous = list.last?.next
        }
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
    @discardableResult public func remove(at index: Int) -> T {
        let node = self.node(at: index)
        return remove(node: node)
    }
}

//: End of the base class declarations & beginning of extensions' declarations:

// MARK: - Extension to enable the standard conversion of a list to String 
extension LinkedList: CustomStringConvertible {
    public var description: String {
        var s = "["
        var node = head
        while let nd = node {
            s += "\(nd.value)"
            node = nd.next
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
        while let nd = node {
            result.append(transform(nd.value))
            node = nd.next
        }
        return result
    }
    
    public func filter(predicate: (T) -> Bool) -> LinkedList<T> {
        let result = LinkedList<T>()
        var node = head
        while let nd = node {
            if predicate(nd.value) {
                result.append(nd.value)
            }
            node = nd.next
        }
        return result
    }
}

// MARK: - Extension to enable initialization from an Array
extension LinkedList {
    convenience init(array: Array<T>) {
        self.init()
        
        array.forEach { append($0) }
    }
}

// MARK: - Extension to enable initialization from an Array Literal
extension LinkedList: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init()
        
        elements.forEach { append($0) }
    }
}

// MARK: - Collection
extension LinkedList: Collection {
    
    public typealias Index = LinkedListIndex<T>
    
    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    /// - Complexity: O(1)
    public var startIndex: Index {
        get {
            return LinkedListIndex<T>(node: head, tag: 0)
        }
    }
    
    /// The collection's "past the end" position---that is, the position one
    /// greater than the last valid subscript argument.
    /// - Complexity: O(n), where n is the number of elements in the list. This can be improved by keeping a reference
    ///   to the last node in the collection.
    public var endIndex: Index {
        get {
            if let h = self.head {
                return LinkedListIndex<T>(node: h, tag: count)
            } else {
                return LinkedListIndex<T>(node: nil, tag: startIndex.tag)
            }
        }
    }
    
    public subscript(position: Index) -> T {
        get {
            return position.node!.value
        }
    }
    
    public func index(after idx: Index) -> Index {
        return LinkedListIndex<T>(node: idx.node?.next, tag: idx.tag + 1)
    }
}

// MARK: - Collection Index
/// Custom index type that contains a reference to the node at index 'tag'
public struct LinkedListIndex<T>: Comparable {
    fileprivate let node: LinkedList<T>.LinkedListNode<T>?
    fileprivate let tag: Int
    
    public static func==<T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
        return (lhs.tag == rhs.tag)
    }
    
    public static func< <T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
        return (lhs.tag < rhs.tag)
    }
}
//: Ok, now that the declarations are done, let's see our Linked List in action:
let list = LinkedList<String>()
list.isEmpty                  // true
list.head                    // nil
list.last                     // nil

list.append("Hello")
list.isEmpty                  // false
list.head!.value             // "Hello"
list.last!.value              // "Hello"
list.count                    // 1

list.append("World")
list.head!.value             // "Hello"
list.last!.value              // "World"
list.count                    // 2

list.head!.previous          // nil
list.head!.next!.value       // "World"
list.last!.previous!.value    // "Hello"
list.last!.next               // nil

list.node(at: 0).value    // "Hello"
list.node(at: 1).value    // "World"
//list.node(at: 2)           // crash!

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
list.remove(at: 2)       // "Goodbye"

list.insert("Swift", at: 1)
list[0]     // "Hello"
list[1]     // "Swift"
list[2]     // "World"
print(list)

list.reverse()   // [World, Swift, Hello]

list.node(at: 0).value = "Universe"
list.node(at: 1).value = "Swifty"
let m = list.map { s in s.count }
m    // [8, 6, 5]
let f = list.filter { s in s.count > 5 }
f    // [Universe, Swifty]

list.remove(node: list.head!) // "Universe"
list.count                     // 2
list[0]                        // "Swifty"
list[1]                        // "Hello"

list.count                     // 2
list.removeLast()              // "Hello"
list.head?.value
list.count                     // 1
list[0]                        // "Swifty"

list.remove(at: 0)        // "Swifty"
list.count                     // 0

let list3 = LinkedList<String>()
list3.insert("2", at: 0) // [2]
list3.count                   // 1
list3.insert("4", at: 1) // [2,4]
list3.count                   // 2
list3.insert("5", at: 2) // [2,4,5]
list3.count                   // 3
list3.insert("3", at: 1) // [2,3,4,5]
list3.insert("1", at: 0) // [1,2,3,4,5]

let list4 = LinkedList<String>()
list4.insert(list3, at: 0) // [1,2,3,4,5]
list4.count                     // 5

let list5 = LinkedList<String>()
list5.append("0")                // [0]
list5.insert("End", at:1)   // [0,End]
list5.count                      // 2
list5.insert(list4, at: 1)  // [0,1,2,3,4,5,End]
list5.count                      // 7


let linkedList: LinkedList<Int> = [1, 2, 3, 4] // [1, 2, 3, 4]
linkedList.count               // 4
linkedList[0]                  // 1

// Infer the type from the array
let listArrayLiteral2: LinkedList = ["Swift", "Algorithm", "Club"]
listArrayLiteral2.count        // 3
listArrayLiteral2[0]           // "Swift"
listArrayLiteral2.removeLast()  // "Club"


// Conformance to the Collection protocol
let collection: LinkedList<Int> = [1, 2, 3, 4, 5]
let index2 = collection.index(collection.startIndex, offsetBy: 2)
let value = collection[index2] // 3

// Iterating in a for loop, since the Sequence protocol allows this.
var sum = 0
for element in collection {
    sum += element
}
// sum is 15

// Another way of achieving the same result though 'reduce', another method defined in an extension of Sequence. Collections are Sequences.
let result = collection.reduce(0) {$0 + $1} // 15




