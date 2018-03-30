public final class LinkedList<T> {
    
    public class LinkedListNode<T> {
        var value: T
        var next: LinkedListNode?
        weak var previous: LinkedListNode?
        
        public init(value: T) {
            self.value = value
        }
    }
    
    public typealias Node = LinkedListNode<T>
    
    private(set) var first: Node?
    
    public var last: Node? {
        guard var node = first else { return nil }
        while let next = node.next {
            node = next
        }
        return node
    }
    
    public var isEmpty: Bool {
        return first == nil
    }
    
    public var count: Int {
        guard var node = first else { return 0 }
        var c = 1
        while let next = node.next {
            node = next
            c += 1
        }
        return c
    }
    
    public func node(atIndex index: Int) -> Node? {
        if index >= 0 {
            var node = first
            var i = index
            while let nd = node {
                if i == 0 { return nd }
                i -= 1
                node = nd.next
            }
        }
        return nil
    }
    
    public subscript(index: Int) -> T? {
        return self.node(atIndex: index)?.value
    }
    
    public init() {}
    
    public func append(_ value: T) {
        let newNode = Node(value: value)
        append(newNode)
    }
    
    public func append(_ node: Node) {
        let newNode = LinkedListNode(value: node.value)
        if let lastNode = last {
            newNode.previous = lastNode
            lastNode.next = newNode
        } else {
            first = newNode
        }
    }
    
    public func append(_ list: LinkedList) {
        var nodeToCopy = list.first
        while let node = nodeToCopy {
            append(node.value)
            nodeToCopy = node.next
        }
    }
    
    private func nodesBeforeAndAfter(index: Int) -> (Node?, Node?) {
        assert(index >= 0)
        
        var i = index
        var next = first
        var prev: Node?
        
        while let nxt = next, i > 0 {
            i -= 1
            prev = nxt
            next = nxt.next
        }
        assert(i == 0)  // if > 0, then specified index was too large
        
        return (prev, next)
    }
    
    public func insert(_ value: T, atIndex index: Int) {
        let newNode = Node(value: value)
        insert(newNode, atIndex: index)
    }
    
    public func insert(_ node: Node, atIndex index: Int) {
        let (prev, next) = nodesBeforeAndAfter(index: index)
        let newNode = LinkedListNode(value: node.value)
        newNode.previous = prev
        newNode.next = next
        prev?.next = newNode
        next?.previous = newNode
        
        if prev == nil {
            first = newNode
        }
    }
    
    public func insert(_ list: LinkedList, atIndex index: Int) {
        if list.isEmpty { return }
        var (prev, next) = nodesBeforeAndAfter(index: index)
        var nodeToCopy = list.first
        var newNode: Node?
        while let node = nodeToCopy {
            newNode = Node(value: node.value)
            newNode?.previous = prev
            if let previous = prev {
                previous.next = newNode
            } else {
                first = newNode
            }
            nodeToCopy = nodeToCopy?.next
            prev = newNode
        }
        prev?.next = next
        next?.previous = prev
    }
    
    public func removeAll() {
        first = nil
    }
    
    @discardableResult public func remove(node: Node) -> T {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            first = next
        }
        next?.previous = prev
        
        node.previous = nil
        node.next = nil
        return node.value
    }
    
    @discardableResult public func removeLast() -> T? {
        guard let last = last else { return nil }
        return remove(node: last)
    }
    
    @discardableResult public func remove(atIndex index: Int) -> T? {
        guard let node = node(atIndex: index) else { return nil }
        return remove(node: node)
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        var s = "["
        var node = first
        while let nd = node {
            s += "\(nd.value)"
            node = nd.next
            if node != nil { s += ", " }
        }
        return s + "]"
    }
}

extension LinkedList {
    public func reverse() {
        var node = first
        while let currentNode = node {
            node = currentNode.next
            swap(&currentNode.next, &currentNode.previous)
            first = currentNode
        }
    }
}

extension LinkedList {
    public func map<U>(transform: (T) -> U) -> LinkedList<U> {
        let result = LinkedList<U>()
        var node = first
        while let nd = node {
            result.append(transform(nd.value))
            node = nd.next
        }
        return result
    }
    
    public func filter(predicate: (T) -> Bool) -> LinkedList<T> {
        let result = LinkedList<T>()
        var node = first
        while let nd = node {
            if predicate(nd.value) {
                result.append(nd.value)
            }
            node = nd.next
        }
        return result
    }
}

extension LinkedList {
    convenience init(array: Array<T>) {
        self.init()
        array.forEach { append($0) }
    }
}

extension LinkedList: ExpressibleByArrayLiteral {
    public convenience init(arrayLiteral elements: T...) {
        self.init()
        elements.forEach { append($0) }
    }
}
