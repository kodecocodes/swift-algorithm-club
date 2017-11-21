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
    public static func splay<T: Comparable>(node: Node<T>) {
        
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
    public static func operation<T: Comparable>(forNode node: Node<T>) -> SplayOperation {
        
        if let parent = node.parent, let _ = parent.parent {
            if (node.isLeftChild && parent.isRightChild) || (node.isRightChild && parent.isLeftChild) {
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
    public func apply<T: Comparable>(onNode node: Node<T>) {
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
    public func rotate<T: Comparable>(child: Node<T>, parent: Node<T>) {
        
        assert(child.parent != nil && child.parent!.value == parent.value, "Parent and child.parent should match here")
        
        var grandchildToMode: Node<T>?
        
        if child.isLeftChild {
            
            grandchildToMode = child.right
            parent.left = grandchildToMode
            grandchildToMode?.parent = parent

            let grandParent = parent.parent
            child.parent = grandParent

            if parent.isLeftChild {
                grandParent?.left = child
            } else {
                grandParent?.right = child
            }

            child.right = parent
            parent.parent = child
    

        } else {
            
            grandchildToMode = child.left
            parent.right = grandchildToMode
            grandchildToMode?.parent = parent

            let grandParent = parent.parent
            child.parent = grandParent

            if parent.isLeftChild {
                grandParent?.left = child
            } else {
                grandParent?.right = child
            }

            child.left = parent
            parent.parent = child

        }
        

    }
}

public class Node<T: Comparable> {
    
    fileprivate(set) public var value: T?
    fileprivate(set) public var parent: Node<T>?
    fileprivate(set) public var left: Node<T>?
    fileprivate(set) public var right: Node<T>?
    
    init(value: T) {
        self.value = value
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

public class SplayTree<T: Comparable> {

    internal var root: Node<T>?
    
    var value: T? {
        return root?.value
    }

    //MARK: - Initializer
    
    public init(value: T) {
        self.root = Node(value:value)
    }
    
    public func insert(value: T) {
        if let root = root {
            self.root = root.insert(value: value)
        } else {
            root = Node(value: value)
        }
    }
    
    public func remove(value: T) {
        root = root?.remove(value: value)
    }

    public func search(value: T) -> Node<T>? {
        root = root?.search(value: value)
        return root
    }
    
    public func minimum() -> Node<T>? {
        root = root?.minimum(splayed: true)
        return root
    }
    
    public func maximum() -> Node<T>? {
        root = root?.maximum(splayed: true)
        return root
    }
    
}

// MARK: - Adding items

extension Node {
    
    /*
     Inserts a new element into the node tree.
     
     - Parameters:
            - value T value to be inserted. Will be splayed to the root position
     
     - Returns:
            - Node inserted
     */
    public func insert(value: T) -> Node {
        if let selfValue = self.value {
            if value < selfValue {
                if let left = left {
                    return left.insert(value: value)
                } else {
                    
                    left = Node(value: value)
                    left?.parent = self
                    
                    if let left = left {
                        SplayOperation.splay(node: left)
                        return left
                    }
                }
            } else {
                
                if let right = right {
                    return right.insert(value: value)
                } else {
                    
                    right = Node(value: value)
                    right?.parent = self
                    
                    if let right = right {
                        SplayOperation.splay(node: right)
                        return right
                    }
                }
            }
        }
        return self
    }
}

// MARK: - Deleting items

extension Node {
    
    /*
     Deletes the given node from the nodes tree.
     Return the new tree generated by the removal. 
     The removed node (not necessarily the one containing the value), will be splayed to the root.
     
     - Parameters:
            - value         To be removed
     
     - Returns:
            - Node     Resulting from the deletion and the splaying of the removed node
     
     */
    public func remove(value: T) -> Node<T>? {
        let replacement: Node<T>?
        
        if let v = self.value, v == value {
            
            var parentToSplay: Node<T>?
            if let left = left {
                if let right = right {
                    
                    replacement = removeNodeWithTwoChildren(left, right)
                    
                    if let replacement = replacement,
                        let replacementParent = replacement.parent,
                        replacementParent.value != self.value {
                        
                        parentToSplay = replacement.parent
                        
                    } else if self.parent != nil {
                        parentToSplay = self.parent
                    } else {
                        parentToSplay = replacement
                    }
                    
                } else {
                    // This node only has a left child. The left child replaces the node.
                    replacement = left
                    if self.parent != nil {
                        parentToSplay = self.parent
                    } else {
                        parentToSplay = replacement
                    }
                }
            } else if let right = right {
                // This node only has a right child. The right child replaces the node.
                replacement = right
                if self.parent != nil {
                    parentToSplay = self.parent
                } else {
                    parentToSplay = replacement
                }
            } else {
                // This node has no children. We just disconnect it from its parent.
                replacement = nil
                parentToSplay = parent
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

            return parentToSplay
            
        } else if let v = self.value, value < v {
            if left != nil {
                return left!.remove(value: value)
            } else {
                let node = self
                SplayOperation.splay(node: node)
                return node
                
            }
        } else {
            if right != nil {
                return right?.remove(value: value)
            } else {
                let node = self
                SplayOperation.splay(node: node)
                return node
                
            }
        }
    }
    
    private func removeNodeWithTwoChildren(_ left: Node, _ right: Node) -> Node {
        // This node has two children. It must be replaced by the smallest
        // child that is larger than this node's value, which is the leftmost
        // descendent of the right child.
        let successor = right.minimum()
        
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
    
    private func reconnectParentTo(node: Node?) {
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

extension Node {
    
    /*
     Finds the "highest" node with the specified value.
     Performance: runs in O(h) time, where h is the height of the tree.
     */
    public func search(value: T) -> Node<T>? {
        var node: Node? = self
        var nodeParent: Node? = self
        while case let n? = node, n.value != nil {
            if value < n.value! {
                if n.left != nil { nodeParent = n.left }
                node = n.left
            } else if value > n.value! {
                node = n.right
                if n.right != nil { nodeParent = n.right }
            } else {
                break
            }
        }
        
        if let node = node {
            SplayOperation.splay(node: node)
            return node
        } else if let nodeParent = nodeParent {
            SplayOperation.splay(node: nodeParent)
            return nodeParent
        }
        
        return nil
    }
    
    public func contains(value: T) -> Bool {
        return search(value: value) != nil
    }
    
    /*
     Returns the leftmost descendent. O(h) time.
     */
    public func minimum(splayed: Bool = false) -> Node<T> {
        var node = self
        while case let next? = node.left {
            node = next
        }
        
        if splayed == true {
            SplayOperation.splay(node: node)
        }
        
        return node
    }
    
    /*
     Returns the rightmost descendent. O(h) time.
     */
    public func maximum(splayed: Bool = false) -> Node<T> {
        var node = self
        while case let next? = node.right {
            node = next
        }
        
        if splayed == true {
            SplayOperation.splay(node: node)
        }
        
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
    public func predecessor() -> Node<T>? {
        if let left = left {
            return left.maximum()
        } else {
            var node = self
            while case let parent? = node.parent, parent.value != nil, value != nil {
                if parent.value! < value! { return parent }
                node = parent
            }
            return nil
        }
    }
    
    /*
     Finds the node whose value succeeds our value in sorted order.
     */
    public func successor() -> Node<T>? {
        if let right = right {
            return right.minimum()
        } else {
            var node = self
            while case let parent? = node.parent, parent.value != nil , value != nil {
                if parent.value! > value! { return parent }
                node = parent
            }
            return nil
        }
    }
}

// MARK: - Traversal
extension Node {
    
    public func traverseInOrder(process: (T) -> Void) {
        left?.traverseInOrder(process: process)
        process(value!)
        right?.traverseInOrder(process: process)
    }
    
    public func traversePreOrder(process: (T) -> Void) {
        process(value!)
        left?.traversePreOrder(process: process)
        right?.traversePreOrder(process: process)
    }
    
    public func traversePostOrder(process: (T) -> Void) {
        left?.traversePostOrder(process: process)
        right?.traversePostOrder(process: process)
        process(value!)
    }
    
    /*
     Performs an in-order traversal and collects the results in an array.
     */
    public func map(formula: (T) -> T) -> [T] {
        var a = [T]()
        if let left = left { a += left.map(formula: formula) }
        a.append(formula(value!))
        if let right = right { a += right.map(formula: formula) }
        return a
    }
}

/*
 Is this binary tree a valid binary search tree?
 */
extension Node {
    
    public func isBST(minValue: T, maxValue: T) -> Bool {
        if let value = value {
            if value < minValue || value > maxValue { return false }
            let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
            let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
            return leftBST && rightBST
        }
        return false
    }
}

// MARK: - Debugging

extension Node: CustomStringConvertible {
    public var description: String {
        var s = ""
        if let left = left {
            s += "left: (\(left.description)) <- "
        }
        if let v = value {
            s += "\(v)"
        }
        if let right = right {
            s += " -> (right: \(right.description))"
        }
        return s
    }
}

extension SplayTree: CustomStringConvertible {
    public var description: String {
        return root?.description ?? "Empty tree"
    }
}

extension Node: CustomDebugStringConvertible {
    public var debugDescription: String {
        var s = "value: \(value)"
        if let parent = parent, let v = parent.value {
            s += ", parent: \(v)"
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

extension SplayTree: CustomDebugStringConvertible {
    public var debugDescription: String {
        return root?.debugDescription ?? "Empty tree"
    }
}
