/*
 Each node stores a value and two children. The left child contains a smaller
 value; the right a larger (or equal) value.
 */
public class BSTNode<T: Comparable> {
    var value: T
    var left: BSTNode?
    var right: BSTNode?
    var parent: BSTNode?
    
    init(initialValue: T, leftNode: BSTNode? = nil, rightNode: BSTNode? = nil, parentNode: BSTNode? = nil) {
        value = initialValue
        left = leftNode
        right = rightNode
        parent = parentNode
    }
}

extension BSTNode : CustomStringConvertible {
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
    
    /*
     Returns the leftmost descendent. O(h) time.
     */
    public func minimum() -> BSTNode {
        var node = self
        while let next = node.left {
            node = next
        }
        return node
    }
    
    /*
     Returns the rightmost descendent. O(h) time.
     */
    public func maximum() -> BSTNode {
        var node = self
        while let next = node.right {
            node = next
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
        while let parent = node.parent {
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
    public func predecessor() -> BSTNode<T>? {
        if let left = left {
            return left.maximum()
        } else {
            var node = self
            while let parent = node.parent {
                if parent.value < value { return parent }
                node = parent
            }
            return nil
        }
    }
    
    /*
     Finds the node whose value succeeds our value in sorted order.
     */
    public func successor() -> BSTNode<T>? {
        if let right = right {
            return right.minimum()
        } else {
            var node = self
            while let parent = node.parent {
                if parent.value > value { return parent }
                node = parent
            }
            return nil
        }
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
    
    public func remove(value: T, parentNode:BSTNode<T>?) -> Bool {
        if value < self.value {
            if let left = left {
                return left.remove(value: value, parentNode: self)
            } else {
                return false
            }
        } else if value > self.value {
            if let right = right {
                return right.remove(value: value, parentNode: self)
            } else {
                return false
            }
        } else {
            if hasBothChildren {
                // use the min value of the right tree, could change this max value of left tree if preferred
                if let right = right {
                    self.value = right.minimum().value
                    right.remove(value: self.value, parentNode: self)
                }
            } else if let parentLeft = parentNode?.left, self === parentLeft {
                parentNode?.left = hasLeftChild ? left : right
            } else if let parentRight = parentNode?.right, self === parentRight {
                parentNode?.right = hasLeftChild ? left : right
            }
            return true
        }
    }
}
/*
 A binary search tree.
 This tree allows duplicate elements.
 This tree does not automatically balance itself. To make sure it is balanced,
 you should insert new values in randomized order, not in sorted order.
 */
public class BinarySearchTree<T: Comparable> {
    fileprivate(set) var root: BSTNode<T>?
    
    public init(value: T) {
        self.root = BSTNode(initialValue: value)
    }
    
    public convenience init(array: [T]) {
        precondition(array.count > 0)
        self.init(value: array.first!)
        for v in array.dropFirst() {
            insert(value: v)
        }
    }
    
    /** Counts number of nodes in this subtree. Performance: O(n).
     @param node to count from a specific node - default root
     @return how many nodes are in this subtree - default how many nodes are in entire tree
    */
    public func count(node: BSTNode<T>? = nil) -> Int {
        var tempNode = node
        if let root = root, tempNode == nil {
            tempNode = root
        }
        var sum = 1
        if let leftNode = tempNode?.left {
            sum += count(node: leftNode)
        }
        if let rightNode = tempNode?.right {
            sum += count(node: rightNode)
        }
        return sum
    }
    
}

// MARK: - Adding items
extension BinarySearchTree {
    /*
     Inserts a new element into the tree. You should only insert elements
     at the root, to make to sure this remains a valid binary tree!
     Performance: runs in O(h) time, where h is the height of the tree.
     */
    public func insert(value: T) {
        if let root = root {
            insertFromRoot(value: value, parentNode: root)
        } else {
            root = BSTNode(initialValue: value)
        }
    }
    
    public func insertFromRoot(value: T, parentNode: BSTNode<T>) {
        if value < parentNode.value {
            if let left = parentNode.left {
                insertFromRoot(value: value, parentNode: left)
            } else {
                parentNode.left = BSTNode(initialValue: value, parentNode: parentNode)
            }
        } else {
            if let right = parentNode.right {
                insertFromRoot(value: value, parentNode: right)
            } else {
                parentNode.right = BSTNode(initialValue: value, parentNode: parentNode)
            }
        }
    }
}

// MARK: - Deleting items
extension BinarySearchTree {
    
 /*
 Deletes a node from the tree.
 Returns if the node was successfully removed.
 Performance: runs in O(h) time, where h is the height of the tree.
 */
  public func remove(value: T) -> Bool {
        if let root = root {
            if root.value == value {
                // set up a temp for the new root, the value is the same as root.value only to keep same type T
                let newRoot = BSTNode(initialValue: root.value)
                newRoot.left = root
                let result = root.remove(value: value, parentNode: newRoot)
                self.root = newRoot.left
                newRoot.left = root
                return result
            } else {
                return root.remove(value: value, parentNode: nil)
            }
        } else {
            return false
        }
    }
}

// MARK: - Searching
extension BinarySearchTree {
    /*
     Finds the node with the specified value.
     Performance: runs in O(h) time, where h is the height of the tree.
    */
    public func iterativeSearch(value: T) -> BSTNode<T>? {
        var node = root
        while let n = node {
            if value < n.value {
                node = n.left
            } else if value > n.value {
                node = n.right
            } else {
                return node
            }
        }
        return nil
    }
    
     // Recursive version of search
    public func recursiveSearch(value: T) -> BSTNode<T>? {
        if let root = root {
            return recursiveSearchFromRoot(value: value, node: root)
        }
        return nil
     }
    
    private func recursiveSearchFromRoot(value: T, node: BSTNode<T>) -> BSTNode<T>? {
        print( "\(value)  \(node.value)")
        if value == node.value {
            return node // found it
        }
        if let left = node.left, value < node.value {
            return recursiveSearchFromRoot(value: value, node: left)
        }
        if let right = node.right, value > node.value {
            return recursiveSearchFromRoot(value: value, node: right)
        }
        return nil  // didn't find it :(
    }
    
    public func contains(value: T) -> Bool {
        return recursiveSearch(value: value) != nil
    }
}

// MARK: - Traversal
extension BinarySearchTree {
    public func traverseInOrder(process: (T) -> Void) {
        if let root = root {
            traverseInOrderFromRoot(node: root, process: process)
        }
    }
    
    private func traverseInOrderFromRoot(node: BSTNode<T>, process: (T) -> Void) {
        if let left = node.left {
            traverseInOrderFromRoot(node: left, process: process)
        }
        process(node.value)
        if let right = node.right {
            traverseInOrderFromRoot(node: right, process: process)
        }
    }
    
    public func traversePreOrder(process: (T) -> Void) {
        if let root = root {
            traversePreOrderFromRoot(node: root, process: process)
        }
    }
    
    private func traversePreOrderFromRoot(node: BSTNode<T>, process: (T) -> Void) {
        process(node.value)
        if let left = node.left {
            traversePreOrderFromRoot(node: left, process: process)
        }
        if let right = node.right {
            traversePreOrderFromRoot(node: right, process: process)
        }
    }
    
    public func traversePostOrder(process: (T) -> Void) {
        if let root = root {
            traversePostOrderFromRoot(node: root, process: process)
        }
    }
    
    private func traversePostOrderFromRoot(node: BSTNode<T>, process: (T) -> Void) {
        if let left = node.left {
            traversePostOrderFromRoot(node: left, process: process)
        }
        if let right = node.right {
            traversePostOrderFromRoot(node: right, process: process)
        }
        process(node.value)
    }
}

/*
 Is this binary tree a valid binary search tree?
 */
extension BinarySearchTree {
    public func isBST(minValue: T, maxValue: T) -> Bool {
        return isBSTfromRoot(node: nil, minValue: minValue, maxValue: maxValue)
    }
    
    private func isBSTfromRoot(node: BSTNode<T>?, minValue: T, maxValue: T) -> Bool {
        var tempNode = node
        if let root = root, tempNode == nil {
            tempNode = root
        } else if root == nil {
            return true
        }
        var leftBST = true
        var rightBST = true
        if let tempValue = tempNode?.value {
            if tempValue < minValue || tempValue > maxValue { return false }
            
            if let left = tempNode?.left {
                leftBST = isBSTfromRoot(node: left, minValue: minValue, maxValue: tempValue)
            }
            if let right = tempNode?.right {
                rightBST = isBSTfromRoot(node: right, minValue: tempValue, maxValue: maxValue)
            }
        }
        return leftBST && rightBST
    }
}

// MARK: - Debugging
extension BinarySearchTree {
    public func toArray() -> [T] {
        if let root = root {
            return root.map(formula: { $0 })
        }
        return []
    }
}
