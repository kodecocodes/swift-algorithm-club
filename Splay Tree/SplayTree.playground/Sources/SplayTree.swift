/*
 *  Splay Tree 
 *
 * Based on Binary Search Tree Implementation written by Nicolas Ameghino and Matthijs Hollemans for Swift Algorithms Club
 * https://github.com/raywenderlich/swift-algorithm-club/blob/master/Binary%20Search%20Tree
 * And extended for the specifics of a Splay Tree by Barbara Martina Rodeker
 *
 */

/**
    Represent the 3 possible operations (combinations of rotations) that
    could be performed during the Splay phase in Splay Trees
 
    - zigZag       Left child of a right child OR right child of a left child
    - zigZig       Left child of a left child OR right child of a right child
    - zig          Only 1 parent and that parent is the root
 
 */
public enum SplayOperation {
    case zigZag
    case zigZig
    case zig
    
    
    /**
        Splay the given node up to the root of the tree
     
        - Parameters:
            - node      SplayTree node to move up to the root
     */
    public static func splay<T: Comparable>(node: SplayTree<T>) {
        
        while (node.parent != nil) {
            operation(forNode: node).apply(onNode: node)
        }
    }
    
    /**
        Compares the node and its parent and determine
        if the rotations should be performed in a zigZag, zigZig or zig case.
     
        - Parmeters:
            - forNode       SplayTree node to be checked
        - Returns
            - Operation     Case zigZag - zigZig - zig
     */
    private static func operation<T: Comparable>(forNode node: SplayTree<T>) -> SplayOperation {
        
        if let parent = node.parent, let grandParent = parent.parent {
            if (node.isLeftChild && grandParent.isRightChild) || (node.isRightChild && grandParent.isLeftChild) {
                return .zigZag
            }
            return .zigZig
        }
        return .zig
    }
    
    /**
        Applies the rotation associated to the case 
        Modifying the splay tree and briging the received node further to the top of the tree
     
        - Parameters:
            - onNode    Node to splay up. Should be alwayas the node that needs to be splayed, neither its parent neither it's grandparent
     */
    private func apply<T: Comparable>(onNode node: SplayTree<T>) {
        switch self {
        case .zigZag:
            assert(node.parent != nil && node.parent!.parent != nil, "Should be at least 2 nodes up in the tree")
            rotate(child: node, parent: node.parent!)
            rotate(child: node, parent: node.parent!)

        case .zigZig:
            assert(node.parent != nil && node.parent!.parent != nil, "Should be at least 2 nodes up in the tree")
            rotate(child: node.parent!, parent: node.parent!.parent!)
            rotate(child: node, parent: node.parent!)
        
        case .zig:
            assert(node.parent != nil && node.parent!.parent == nil, "There should be a parent which is the root")
            rotate(child: node, parent: node.parent!)
        }
    }
    
    /**
        Performs a single rotation from a node to its parent
        re-arranging the children properly
     */
    private func rotate<T: Comparable>(child: SplayTree<T>, parent: SplayTree<T>) {
        
        assert(child.parent != nil && child.parent!.value == parent.value, "Parent and child.parent should match here")
        
        var grandchildToMode: SplayTree<T>?
        if child.isLeftChild {
            
            grandchildToMode = child.right
            child.right = parent
            parent.left = grandchildToMode
            
        } else {
            
            grandchildToMode = child.left
            child.left = parent
            parent.right = grandchildToMode
        }

        let grandParent = parent.parent
        parent.parent = child
        child.parent = grandParent
    }
}

public class SplayTree<T: Comparable> {
    
    fileprivate(set) public var value: T
    fileprivate(set) public var parent: SplayTree?
    fileprivate(set) public var left: SplayTree?
    fileprivate(set) public var right: SplayTree?
    
    public init(value: T) {
        self.value = value
    }
    
    public convenience init(array: [T]) {
        precondition(array.count > 0)
        self.init(value: array.first!)
        for v in array.dropFirst() {
            insert(value: v)
        }
    }
    
    public var isRoot: Bool {
        return parent == nil
    }
    
    public var isLeaf: Bool {
        return left == nil && right == nil
    }
    
    public var isLeftChild: Bool {
        return parent?.left === self
    }
    
    public var isRightChild: Bool {
        return parent?.right === self
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
    
    /* How many nodes are in this subtree. Performance: O(n). */
    public var count: Int {
        return (left?.count ?? 0) + 1 + (right?.count ?? 0)
    }
}

// MARK: - Adding items

extension SplayTree {
    
    /*
     Inserts a new element into the tree. You should only insert elements
     at the root, to make to sure this remains a valid binary tree!
     Performance: runs in O(h) time, where h is the height of the tree.
     */
    public func insert(value: T) {
        if value < self.value {
            if let left = left {
                left.insert(value: value)
            } else {
                
                left = SplayTree(value: value)
                left?.parent = self
                
                if let left = left {
                    SplayOperation.splay(node: left)
                    self.parent = nil
                    self.value = left.value
                    self.left = left.left
                    self.right = left.right
                }
            }
        } else {
            
            if let right = right {
                right.insert(value: value)
            } else {
                
                right = SplayTree(value: value)
                right?.parent = self
                
                if let right = right {
                    SplayOperation.splay(node: right)
                    self.parent = nil
                    self.value = right.value
                    self.left = right.left
                    self.right = right.right
                }
            }
        }
    }
}

// MARK: - Deleting items

extension SplayTree {
    /*
     Deletes a node from the tree.
     Returns the node that has replaced this removed one (or nil if this was a
     leaf node). That is primarily useful for when you delete the root node, in
     which case the tree gets a new root.
     Performance: runs in O(h) time, where h is the height of the tree.
     */
    @discardableResult public func remove() -> SplayTree? {
        let replacement: SplayTree?
        
        if let left = left {
            if let right = right {
                replacement = removeNodeWithTwoChildren(left, right)
            } else {
                // This node only has a left child. The left child replaces the node.
                replacement = left
            }
        } else if let right = right {
            // This node only has a right child. The right child replaces the node.
            replacement = right
        } else {
            // This node has no children. We just disconnect it from its parent.
            replacement = nil
        }

        // Save the parent to splay before reconnecting
        var parentToSplay: SplayTree?
        if let replacement = replacement {
            parentToSplay = replacement.parent
        } else {
            parentToSplay = self.parent
        }
        
        reconnectParentTo(node: replacement)
        
        // performs the splay operation
        if let parentToSplay = parentToSplay {
            SplayOperation.splay(node: parentToSplay)
        }
        
        // The current node is no longer part of the tree, so clean it up.
        parent = nil
        left = nil
        right = nil
        
        return replacement
    }
    
    private func removeNodeWithTwoChildren(_ left: SplayTree, _ right: SplayTree) -> SplayTree {
        // This node has two children. It must be replaced by the smallest
        // child that is larger than this node's value, which is the leftmost
        // descendent of the right child.
        let successor = right.minimum()
        
        // If this in-order successor has a right child of its own (it cannot
        // have a left child by definition), then that must take its place.
        successor.remove()
        
        // Connect our left child with the new node.
        successor.left = left
        left.parent = successor
        
        // Connect our right child with the new node. If the right child does
        // not have any left children of its own, then the in-order successor
        // *is* the right child.
        if right !== successor {
            successor.right = right
            right.parent = successor
        } else {
            successor.right = nil
        }
        
        // And finally, connect the successor node to our parent.
        return successor
    }
    
    private func reconnectParentTo(node: SplayTree?) {
        if let parent = parent {
            if isLeftChild {
                parent.left = node
            } else {
                parent.right = node
            }
        }
        node?.parent = parent
    }
}

// MARK: - Searching

extension SplayTree {
    
    /*
     Finds the "highest" node with the specified value.
     Performance: runs in O(h) time, where h is the height of the tree.
     */
    public func search(value: T) -> SplayTree? {
        var node: SplayTree? = self
        while case let n? = node {
            if value < n.value {
                node = n.left
            } else if value > n.value {
                node = n.right
            } else {
                
                if let node = node {
                    SplayOperation.splay(node: node)
                }
                
                return node
            }
        }
        
        if let node = node {
            SplayOperation.splay(node: node)
        }
        
        return nil
    }
    
    public func contains(value: T) -> Bool {
        return search(value: value) != nil
    }
    
    /*
     Returns the leftmost descendent. O(h) time.
     */
    public func minimum() -> SplayTree {
        var node = self
        while case let next? = node.left {
            node = next
        }
        
        SplayOperation.splay(node: node)

        return node
    }
    
    /*
     Returns the rightmost descendent. O(h) time.
     */
    public func maximum() -> SplayTree {
        var node = self
        while case let next? = node.right {
            node = next
        }
        
        SplayOperation.splay(node: node)
        
        return node
    }
    
    /*
     Calculates the depth of this node, i.e. the distance to the root.
     Takes O(h) time.
     */
    public func depth() -> Int {
        var node = self
        var edges = 0
        while case let parent? = node.parent {
            node = parent
            edges += 1
        }
        return edges
    }
    
    /*
     Calculates the height of this node, i.e. the distance to the lowest leaf.
     Since this looks at all children of this node, performance is O(n).
     */
    public func height() -> Int {
        if isLeaf {
            return 0
        } else {
            return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
        }
    }
    
    /*
     Finds the node whose value precedes our value in sorted order.
     */
    public func predecessor() -> SplayTree<T>? {
        if let left = left {
            return left.maximum()
        } else {
            var node = self
            while case let parent? = node.parent {
                if parent.value < value { return parent }
                node = parent
            }
            return nil
        }
    }
    
    /*
     Finds the node whose value succeeds our value in sorted order.
     */
    public func successor() -> SplayTree<T>? {
        if let right = right {
            return right.minimum()
        } else {
            var node = self
            while case let parent? = node.parent {
                if parent.value > value { return parent }
                node = parent
            }
            return nil
        }
    }
}

// MARK: - Traversal
extension SplayTree {
    
    public func traverseInOrder(process: (T) -> Void) {
        left?.traverseInOrder(process: process)
        process(value)
        right?.traverseInOrder(process: process)
    }
    
    public func traversePreOrder(process: (T) -> Void) {
        process(value)
        left?.traversePreOrder(process: process)
        right?.traversePreOrder(process: process)
    }
    
    public func traversePostOrder(process: (T) -> Void) {
        left?.traversePostOrder(process: process)
        right?.traversePostOrder(process: process)
        process(value)
    }
    
    /*
     Performs an in-order traversal and collects the results in an array.
     */
    public func map(formula: (T) -> T) -> [T] {
        var a = [T]()
        if let left = left { a += left.map(formula: formula) }
        a.append(formula(value))
        if let right = right { a += right.map(formula: formula) }
        return a
    }
}

/*
 Is this binary tree a valid binary search tree?
 */
extension SplayTree {
    
    public func isBST(minValue: T, maxValue: T) -> Bool {
        if value < minValue || value > maxValue { return false }
        let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
        let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
        return leftBST && rightBST
    }
}

// MARK: - Debugging

extension SplayTree: CustomStringConvertible {
    public var description: String {
        var s = ""
        if let left = left {
            s += "(\(left.description)) <- "
        }
        s += "\(value)"
        if let right = right {
            s += " -> (\(right.description))"
        }
        return s
    }
}

extension SplayTree: CustomDebugStringConvertible {
    public var debugDescription: String {
        var s = "value: \(value)"
        if let parent = parent {
            s += ", parent: \(parent.value)"
        }
        if let left = left {
            s += ", left = [" + left.debugDescription + "]"
        }
        if let right = right {
            s += ", right = [" + right.debugDescription + "]"
        }
        return s
    }
    
    public func toArray() -> [T] {
        return map { $0 }
    }
}
