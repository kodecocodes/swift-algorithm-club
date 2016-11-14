
/// Binary search tree using value types
/// There will be no duplicate elements in the tree
public enum BinarySearchTree<T: Comparable> {
    // Node(left, value, right, parent)
    indirect case Node(BinarySearchTree<T>?, T, BinarySearchTree<T>?, BinarySearchTree<T>?)

    public init(_ value: T) {
        self = .Node(nil, value, nil, nil)
    }
    public init(array: [T]) {
        self.init(array.first!)
        for v in array.dropFirst() {
            insert(v)
        }
    }
}

// MARK: - Equatable
extension BinarySearchTree: Equatable {
    public static func ==(lhs: BinarySearchTree, rhs: BinarySearchTree) -> Bool {
        switch (lhs, rhs) {
            
        case let (.Node(leftL, valueL, rightL, parentL), .Node(leftR, valueR, rightR, parentR))
            where leftL == leftR && valueL == valueR && rightL == rightR && parentL == parentR: return true
            
        default:
            return false
        }
    }
}

// MARK: - Debugging
extension BinarySearchTree: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .Node(left, value, right, _):
            let l = left == nil ? "" : "(\(left!.debugDescription)) <- "
            let r = right == nil ? "" : " -> (\(right!.debugDescription))"
            return l + "\(value)" + r
        }
    }
}

// MARK: - Helpers
extension BinarySearchTree {
    
    public var value: T {
        switch self { case let .Node(_, value, _, _):return value }
    }
    
    public var parent: BinarySearchTree? {
        switch self { case let .Node(_, _, _, parent):return parent }
    }
    
    public var left: BinarySearchTree<T>? {
        switch self { case let .Node(left, _, _, _):return left }
    }
    
    public var right: BinarySearchTree<T>? {
        switch self { case let .Node(_, _, right, _): return right }
    }
    
    public var isRoot: Bool {
        return parent == nil
    }
    
    public var isLeaf: Bool {
        return left == nil && right == nil
    }
    
    public var isLeftChild: Bool {
        return parent?.left == self
    }
    
    public var isRightChild: Bool {
        return parent?.right == self
    }
    
    public var hasLeftChild: Bool {
        return left != nil
    }
    
    public var hasRightChild: Bool {
        return right != nil
    }
    
    public var hasAnyChild: Bool {
        return hasLeftChild || hasRightChild
    }
    
    public var hasBothChildren: Bool {
        return hasLeftChild && hasRightChild
    }
    /// How many nodes are in this subtree. Performance: O(n).
    public var count: Int {
        switch self {
        case let .Node(left, _, right, _) where left == nil && right == nil: return 1
        case let .Node(left, _, right, _) where left != nil && right == nil: return 1 + left!.count
        case let .Node(left, _, right, _) where left == nil && right != nil: return 1 + right!.count
        case let .Node(left, _, right, _) where left != nil && right != nil: return 1 + left!.count + right!.count
        default: return 0
        }
    }
    
    /// Distance of this node to its lowest leaf. Performance: O(n).
    public var height: Int {
        switch self {
        case let .Node(left, _, right, _) where left != nil && right == nil: return 1 + left!.height
        case let .Node(left, _, right, _) where left == nil && right != nil: return 1 + right!.height
        case let .Node(left, _, right, _) where left != nil && right != nil: return 1 + max(left!.height, right!.height)
        default: return 0
        }
    }

}

// MARK: - Searching
extension BinarySearchTree {
    /// Finds the "highest" node with the specified value.
    /// Performance: runs in O(h) time, where h is the height of the tree.
    public func search(_ x: T) -> BinarySearchTree? {
        switch self {
        case let .Node(left, y, right, _):
            if x < y {
                return left?.search(x)
            } else if y < x {
                return right?.search(x)
            } else {
                return self
            }
        }
    }
    /// If there is a special value in the tree
    public func contains(_ x: T) -> Bool {
        return search(x) != nil
    }
}

// MARK: - Adding items
extension BinarySearchTree {
    
    /// Inserts a new element into the tree.
    /// Performance: runs in O(h) time, where h is the height of the tree.
    public mutating func insert(_ newElement: T) {
        // It's not allowed to insert an element in a sub tree, maybe the operation will make the whole tree not a valid BST.
        precondition(isRoot)
        self = self.p_insert(newElement)
    }
    private func p_insert(_ newElement: T) -> BinarySearchTree {
        switch self {
        case let .Node(left, value, right, parent):
            if newElement < value {
                if left == nil {
                    return .Node(BinarySearchTree.Node(nil, newElement, nil, self), value, right, parent)
                }
                return .Node(left!.p_insert(newElement), value, right, parent)
            }
            if newElement > value {
                if right == nil {
                    return .Node(left, value, BinarySearchTree.Node(nil, newElement, nil, self), parent)
                }
                return .Node(left, value, right!.p_insert(newElement), parent)
            }
            // no duplicates
            return self
        }
    }
}

// MARK: - Deleting items
extension BinarySearchTree {
    
    /// Remove the element from the tree
    /// Performance: runs in O(h) time, where h is the height of the tree.
    /// If there is only a single node in the tree, after removing it, the tree will be empty, so remove() may return nil.
    public func remove(_ element: T)-> BinarySearchTree? {
        return p_remove(element)
    }
    public func p_remove(_ element: T) -> BinarySearchTree? {
        
        switch self {
        case let .Node(left, value, right, _) where left == nil && right == nil: // has no children
            if value == element { return nil }
            return self
        case let .Node(left, value, right, parent) where (left == nil && right != nil) || (left != nil && right == nil): // has 1 child
            if element == value {
                let child =  left != nil ? left : right
                switch child! {
                case let .Node(left, value, right, _):
                    return .Node(left, value, right, parent)
                }
            }
            if element < value {
                return .Node(left?.p_remove(element), value, right, parent)
            }
            return .Node(left, value, right?.p_remove(element), parent)
        case let .Node(left, value, right, parent) where left != nil && right != nil: // has 2 children
            if element == value {
                let lowestOfRight = right!.minimum
                let removedRight = right!.p_remove(lowestOfRight.value)
                return .Node(left, lowestOfRight.value, removedRight, parent)
            }
            if element < value {
                return .Node(left!.p_remove(element), value, right, parent)
            }
            return .Node(left, value, right!.p_remove(element), parent)
        default: return nil
        }

    }
    /// The leftmost descendent. O(h) time.
    private var minimum: BinarySearchTree {
        var node = self
        var prev = node
        while case let .Node(next, _, _, _) = node {
            prev = node
            if next == nil {
                break
            } else {
                node = next!
            }
        }
        return prev
    }
}

// MARK: - Traversal
extension BinarySearchTree {
    
    /// left -> root -> right
    public func traverseInOrder(_ process: (T) -> Void) {
        if case let .Node(left, value, right, _) = self {
            left?.traverseInOrder(process)
            process(value)
            right?.traverseInOrder(process)
        }
    }
    
    /// root -> left -> right
    public func traversePreOrder(_ process: (T) -> Void) {
        if case let .Node(left, value, right, _) = self {
            process(value)
            left?.traversePreOrder(process)
            right?.traversePreOrder(process)
        }
    }
    
    /// left -> right -> root
    public func traversePostOrder(_ process: (T) -> Void) {
        if case let .Node(left, value, right, _) = self {
            left?.traversePostOrder(process)
            right?.traversePostOrder(process)
            process(value)
        }
    }
}

// Test 1:
var tree1 = BinarySearchTree(7)
tree1.insert(5)
tree1.insert(2)
tree1.p_remove(2)
if let node2 = tree1.search(2) {
    let p = node2.parent
}
tree1.insert(5)
tree1.p_remove(5)

// Test 2:
var tree = BinarySearchTree(array: [8, 5, 10, 9, 1])
tree.insert(7)
tree.insert(4)
tree.insert(12)
tree.insert(11)
tree.insert(12)

// The code belloe will print: 1 4 5 7 8 9 10 11 12
tree.traverseInOrder { value in
    print(value)
}
//tree.traversePreOrder { value in
//    print(value)
//}
////tree.traversePostOrder { value in
////    print(value)
////}
//
if let node5 = tree.search(5) {
    node5.left?.value
    node5.parent?.value
    node5.right?.value
    node5.count
    node5.height
    let node10 = tree.search(10)
    if node5.right == node10 {
        print("node5.right is node10")
    }
    let node7 = tree.search(7)
    if node5.right == node7 {
        print("node5.right is node7")
    }
    node5.remove(1)
    
}

tree.remove(8)
tree             // The tree is still the old tree
tree = tree.remove(5)!
tree.remove(100) // because no 100 in the tree, so no element removed
