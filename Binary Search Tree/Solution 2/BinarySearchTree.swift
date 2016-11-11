/*
 Binary search tree using value types
 */
public enum BinarySearchTree<T: Comparable> {
    case Empty
    case Leaf(T)
    indirect case Node(BinarySearchTree, T, BinarySearchTree)
    
    public init(_ value: T) {
        self = .Leaf(value)
    }
    public init(array: [T]) {
        precondition(array.count > 0)
        self.init(array.first!)
        for v in array.dropFirst() {
            insert(v)
        }
    }
 
//    public var isLeftChild: Bool {
//        return parent?.left === self
//    }
//    
//    public var isRightChild: Bool {
//        return parent?.right === self
//    }
//    
//    public var hasLeftChild: Bool {
//        return left != nil
//    }
//    
//    public var hasRightChild: Bool {
//        return right != nil
//    }
//    
//    public var hasAnyChild: Bool {
//        return hasLeftChild || hasRightChild
//    }
//    
//    public var hasBothChildren: Bool {
//        return hasLeftChild && hasRightChild
//    }
    
    
    /* How many nodes are in this subtree. Performance: O(n). */
    public var count: Int {
        switch self {
        case .Empty: return 0
        case .Leaf: return 1
        case let .Node(left, _, right): return left.count + 1 + right.count
        }
    }
}

// MARK: - Searching
extension BinarySearchTree {
    /*
     Finds the "highest" node with the specified value.
     Performance: runs in O(h) time, where h is the height of the tree.
     */
    public func search(_ x: T) -> BinarySearchTree? {
        switch self {
        case .Empty:
            return nil
        case .Leaf(let y):
            return (x == y) ? self : nil
        case let .Node(left, y, right):
            if x < y {
                return left.search(x)
            } else if y < x {
                return right.search(x)
            } else {
                return self
            }
        }
    }
    
    public func contains(_ x: T) -> Bool {
        return search(x) != nil
    }
    
    /*
     Returns the leftmost descendent. O(h) time.
     */
    public var minimum: BinarySearchTree {
        var node = self
        var prev = node
        while case let .Node(next, _, _) = node {
            prev = node
            node = next
        }
        if case .Leaf = node {
            return node
        }
        return prev
    }
    
    /*
     Returns the rightmost descendent. O(h) time.
     */
    public var maximum: BinarySearchTree {
        var node = self
        var prev = node
        while case let .Node(_, _, next) = node {
            prev = node
            node = next
        }
        if case .Leaf = node {
            return node
        }
        return prev
    }
    /* Distance of this node to its lowest leaf. Performance: O(n). */
    public var height: Int {
        switch self {
        case .Empty: return 0
        case .Leaf: return 1
        case let .Node(left, _, right): return 1 + max(left.height, right.height)
        }
    }
}

// MARK: - Adding items
extension BinarySearchTree {
    /*
     Inserts a new element into the tree.
     Performance: runs in O(h) time, where h is the height of the tree.
     */
    public mutating func insert(_ newValue: T) {
        self = p_insert(newValue)
    }
    private func p_insert(_ newValue: T) -> BinarySearchTree {
        switch self {
        case .Empty:
            return .Leaf(newValue)
            
        case .Leaf(let value):
            if newValue < value {
                return .Node(.Leaf(newValue), value, .Empty)
            } else {
                return .Node(.Empty, value, .Leaf(newValue))
            }
            
        case .Node(let left, let value, let right):
            if newValue < value {
                return .Node(left.p_insert(newValue), value, right)
            } else {
                return .Node(left, value, right.p_insert(newValue))
            }
        }
    }
}

// MARK: - Deleting items
extension BinarySearchTree {
}



// MARK: - Traversal
extension BinarySearchTree {
}

// MARK: - Debugging
extension BinarySearchTree: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .Empty: return "."
        case .Leaf(let value): return "\(value)"
        case .Node(let left, let value, let right):
            return "(\(left.debugDescription) <- \(value) -> \(right.debugDescription))"
        }
    }
}
