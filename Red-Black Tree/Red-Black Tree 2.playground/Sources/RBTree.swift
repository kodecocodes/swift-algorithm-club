
private enum RBTColor {
    case red
    case black
    case doubleBlack
}

public class RBTNode<T: Comparable>: CustomStringConvertible {
    fileprivate var color: RBTColor = .red
    public var value: T! = nil
    public var right:  RBTNode<T>!
    public var left:  RBTNode<T>!
    public var parent:  RBTNode<T>!
    
    public var description: String {
        if self.value == nil {
            return "null"
        } else {
            var nodeValue: String
            
            // If the value is encapsulated by parentheses it is red
            // If the value is encapsulated by pipes it is black
            // If the value is encapsulated by double pipes it is double black (This should not occur in a verified RBTree)
            if self.isRed {
                nodeValue = "(\(self.value!))"
            } else if self.isBlack{
                nodeValue = "|\(self.value!)|"
            } else {
                nodeValue = "||\(self.value!)||"
            }
            
            return "(\(self.left.description)<-\(nodeValue)->\(self.right.description))"
        }
    }
    
    init(tree: RBTree<T>) {
        right = tree.nullLeaf
        left = tree.nullLeaf
        parent = tree.nullLeaf
    }
    
    init() {
        //This method is here to support the creation of a nullLeaf
    }
    
    public var isLeftChild: Bool {
        return self.parent.left === self
    }
    
    public var isRightChild: Bool {
        return self.parent.right === self
    }
    
    public var grandparent: RBTNode<T> {
        return parent.parent
    }
    
    public var sibling: RBTNode<T> {
        if isLeftChild {
            return self.parent.right
        } else {
            return self.parent.left
        }
    }
    
    public var uncle: RBTNode<T> {
        return parent.sibling
    }
    
    fileprivate var isRed: Bool {
        return color == .red
    }
    
    fileprivate var isBlack: Bool {
        return color == .black
    }
    
    fileprivate var isDoubleBlack: Bool {
        return color == .doubleBlack
    }
}

public class RBTree<T: Comparable>: CustomStringConvertible {
    public var root: RBTNode<T>
    fileprivate let nullLeaf: RBTNode<T>
    
    public var description: String {
        return root.description
    }
    
    public init() {
        nullLeaf = RBTNode<T>()
        nullLeaf.color = .black
        root = nullLeaf
    }
    
    public convenience init(withValue value: T) {
        self.init()
        insert(value)
    }
    
    public convenience init(withArray array: [T]) {
        self.init()
        insert(array)
    }
    
    public func insert(_ value: T) {
        let newNode = RBTNode<T>(tree: self)
        newNode.value = value
        insertNode(n: newNode)
    }
    
    public func insert(_ values: [T]) {
        for value in values {
            print(value)
            insert(value)
        }
    }
    
    public func delete(_ value: T) {
        let nodeToDelete = find(value)
        if nodeToDelete !== nullLeaf {
            deleteNode(n: nodeToDelete)
        }
    }
    
    public func find(_ value: T) -> RBTNode<T> {
        let foundNode = findNode(rootNode: root, value: value)
        return foundNode
    }
    
    public func minimum(n: RBTNode<T>) -> RBTNode<T> {
        var min = n
        if n.left !== nullLeaf {
            min = minimum(n: n.left)
        }
        
        return min
    }
    
    public func maximum(n: RBTNode<T>) -> RBTNode<T> {
        var max = n
        if n.right !== nullLeaf {
            max = maximum(n: n.right)
        }
        
        return max
    }
    
    public func verify() {
        if self.root === nullLeaf {
            print("The tree is empty")
            return
        }
        property1()
        property2(n: self.root)
        property3()
    }
    
    private func findNode(rootNode: RBTNode<T>, value: T) -> RBTNode<T> {
        var nextNode = rootNode
        if rootNode !== nullLeaf && value != rootNode.value {
            if value < rootNode.value {
                nextNode = findNode(rootNode: rootNode.left, value: value)
            } else {
                nextNode = findNode(rootNode: rootNode.right, value: value)
            }
        }
        
        return nextNode
    }
    
    private func insertNode(n: RBTNode<T>) {
        BSTInsertNode(n: n, parent: root)
        insertCase1(n: n)
    }
    
    private func BSTInsertNode(n: RBTNode<T>, parent: RBTNode<T>) {
        if parent === nullLeaf {
            self.root = n
        } else if n.value < parent.value {
            if parent.left !== nullLeaf {
                BSTInsertNode(n: n, parent: parent.left)
            } else {
                parent.left = n
                parent.left.parent = parent
            }
        } else {
            if parent.right !== nullLeaf {
                BSTInsertNode(n: n, parent: parent.right)
            } else {
                parent.right = n
                parent.right.parent = parent
            }
        }
    }
    
    // if node is root change color to black, else move on
    private func insertCase1(n: RBTNode<T>) {
        if n === root {
            n.color = .black
        } else {
            insertCase2(n: n)
        }
    }
    
    // if parent of node is not black, and node is not root move on
    private func insertCase2(n: RBTNode<T>) {
        if !n.parent.isBlack {
            insertCase3(n: n)
        }
    }
    
    // if uncle is red do stuff otherwise move to 4
    private func insertCase3(n: RBTNode<T>) {
        if n.uncle.isRed { // node must have grandparent as children of root have a black parent
            // both parent and uncle are red, so grandparent must be black.
            n.parent.color = .black
            n.uncle.color = .black
            n.grandparent.color = .red
            // now both parent and uncle are black and grandparent is red.
            // we repeat for the grandparent
            insertCase1(n: n.grandparent)
        } else {
            insertCase4(n: n)
        }
    }
    
    // parent is red, grandparent is black, uncle is black
    // There are 4 cases left:
    // - left left
    // - left right
    // - right right
    // - right left
    
    // the cases "left right" and "right left" can be rotated into the other two
    // so if either of the two is detected we apply a rotation and then move on to
    // deal with the final two cases, if neither is detected we move on to those cases anyway
    private func insertCase4(n: RBTNode<T>) {
        if n.parent.isLeftChild && n.isRightChild { // left right case
            leftRotate(n: n.parent)
            insertCase5(n: n.left)
        } else if n.parent.isRightChild && n.isLeftChild { // right left case
            rightRotate(n: n.parent)
            insertCase5(n: n.right)
        } else {
            insertCase5(n: n)
        }
    }
    
    private func insertCase5(n: RBTNode<T>) {
        // swap color of parent and grandparent
        // parent is red grandparent is black
        n.parent.color = .black
        n.grandparent.color = .red
        
        if n.isLeftChild { // left left case
            rightRotate(n: n.grandparent)
        } else { // right right case
            leftRotate(n: n.grandparent)
        }
    }
    
    private func deleteNode(n: RBTNode<T>) {
        var toDel = n
        
        if toDel.left === nullLeaf && toDel.right === nullLeaf && toDel.parent === nullLeaf {
            self.root = nullLeaf
            return
        }
        
        if toDel.left === nullLeaf && toDel.right === nullLeaf && toDel.isRed {
            if toDel.isLeftChild {
                toDel.parent.left = nullLeaf
            } else {
                toDel.parent.right = nullLeaf
            }
            return
        }
        
        if toDel.left !== nullLeaf && toDel.right !== nullLeaf {
            let pred = maximum(n: toDel.left)
            toDel.value = pred.value
            toDel = pred
        }
        
        // from here toDel has at most 1 non nullLeaf child
        
        var child: RBTNode<T>
        if toDel.left !== nullLeaf {
            child = toDel.left
        } else {
            child = toDel.right
        }
        
        if toDel.isRed || child.isRed {
            child.color = .black
            
            if toDel.isLeftChild {
                toDel.parent.left = child
            } else {
                toDel.parent.right = child
            }
            
            if child !== nullLeaf {
                child.parent = toDel.parent
            }
        } else { // both toDel and child are black
            
            var sibling = toDel.sibling
            
            if toDel.isLeftChild {
                toDel.parent.left = child
            } else {
                toDel.parent.right = child
            }
            if child !== nullLeaf {
                child.parent = toDel.parent
            }
            child.color = .doubleBlack
            
            while child.isDoubleBlack || (child.parent !== nullLeaf && child.parent != nil) {
                if sibling.isBlack {
                    
                    var leftRedChild: RBTNode<T>! = nil
                    if sibling.left.isRed {
                        leftRedChild = sibling.left
                    }
                    var rightRedChild: RBTNode<T>! = nil
                    if sibling.right.isRed {
                        rightRedChild = sibling.right
                    }
                    
                    if leftRedChild != nil || rightRedChild != nil { // at least one of sibling's children are red
                        child.color = .black
                        if sibling.isLeftChild {
                            if leftRedChild != nil { // left left case
                                sibling.left.color = .black
                                let tempColor = sibling.parent.color
                                sibling.parent.color = sibling.color
                                sibling.color = tempColor
                                rightRotate(n: sibling.parent)
                            } else { // left right case
                                if sibling.parent.isRed {
                                    sibling.parent.color = .black
                                } else {
                                    sibling.right.color = .black
                                }
                                leftRotate(n: sibling)
                                rightRotate(n: sibling.grandparent)
                            }
                        } else {
                            if rightRedChild != nil { // right right case
                                sibling.right.color = .black
                                let tempColor = sibling.parent.color
                                sibling.parent.color = sibling.color
                                sibling.color = tempColor
                                leftRotate(n: sibling.parent)
                            } else { // right left case
                                if sibling.parent.isRed {
                                    sibling.parent.color = .black
                                } else {
                                    sibling.left.color = .black
                                }
                                rightRotate(n: sibling)
                                leftRotate(n: sibling.grandparent)
                            }
                        }
                        break
                    } else { // both sibling's children are black
                        child.color = .black
                        sibling.color = .red
                        if sibling.parent.isRed {
                            sibling.parent.color = .black
                            break
                        }
                        /*
                        sibling.parent.color = .doubleBlack
                        child = sibling.parent
                        sibling = child.sibling
                        */
                        if sibling.parent.parent === nullLeaf { // parent of child is root
                            break
                        } else {
                            sibling.parent.color = .doubleBlack
                            child = sibling.parent
                            sibling = child.sibling // can become nill if child is root as parent is nullLeaf
                        }
                        //---------------
                    }
                } else { // sibling is red
                    sibling.color = .black
                    
                    if sibling.isLeftChild { // left case
                        rightRotate(n: sibling.parent)
                        sibling = sibling.right.left
                        sibling.parent.color = .red
                    } else { // right case
                        leftRotate(n: sibling.parent)
                        sibling = sibling.left.right
                        sibling.parent.color = .red
                    }
                }
                
                // sibling check is here for when child is a nullLeaf and thus does not have a parent.
                // child is here as sibling can become nil when child is the root
                if (sibling.parent === nullLeaf) || (child !== nullLeaf && child.parent === nullLeaf) {
                    child.color = .black
                }
            }
        }
    }
    
    private func property1() {
        
        if self.root.isRed {
            print("Root is not black")
        }
    }
    
    private func property2(n: RBTNode<T>) {
        if n === nullLeaf {
            return
        }
        if n.isRed {
            if n.left !== nullLeaf && n.left.isRed {
                print("Red node: \(n.value), has red left child")
            } else if n.right !== nullLeaf && n.right.isRed {
                print("Red node: \(n.value), has red right child")
            }
        }
        property2(n: n.left)
        property2(n: n.right)
    }
    
    private func property3() {
        let bDepth = blackDepth(root: self.root)
        
        let leaves:[RBTNode<T>] = getLeaves(n: self.root)
        
        for leaflet in leaves {
            var leaf = leaflet
            var i = 0
            
            while leaf !== nullLeaf {
                if leaf.isBlack {
                    i = i + 1
                }
                leaf = leaf.parent
            }
            
            if i != bDepth {
                print("black depth: \(bDepth), is not equal (depth: \(i)) for leaf with value: \(leaflet.value)")
            }
        }
        
    }
    
    private func getLeaves(n: RBTNode<T>) -> [RBTNode<T>] {
        var leaves = [RBTNode<T>]()
        
        if n !== nullLeaf {
            if n.left === nullLeaf && n.right === nullLeaf {
                leaves.append(n)
            } else {
                let leftLeaves = getLeaves(n: n.left)
                let rightLeaves = getLeaves(n: n.right)
                
                leaves.append(contentsOf: leftLeaves)
                leaves.append(contentsOf: rightLeaves)
            }
        }
        
        return leaves
    }
    
    private func blackDepth(root: RBTNode<T>) -> Int {
        if root === nullLeaf {
            return 0
        } else {
            let returnValue = root.isBlack ? 1 : 0
            return returnValue + (max(blackDepth(root: root.left), blackDepth(root: root.right)))
        }
    }
    
    private func leftRotate(n: RBTNode<T>) {
        let newRoot = n.right!
        n.right = newRoot.left!
        if newRoot.left !== nullLeaf {
            newRoot.left.parent = n
        }
        newRoot.parent = n.parent
        if n.parent === nullLeaf {
            self.root = newRoot
        } else if n.isLeftChild {
            n.parent.left = newRoot
        } else {
            n.parent.right = newRoot
        }
        newRoot.left = n
        n.parent = newRoot
    }
    
    private func rightRotate(n: RBTNode<T>) {
        let newRoot = n.left!
        n.left = newRoot.right!
        if newRoot.right !== nullLeaf {
            newRoot.right.parent = n
        }
        newRoot.parent = n.parent
        if n.parent === nullLeaf {
            self.root = newRoot
        } else if n.isRightChild {
            n.parent.right = newRoot
        } else {
            n.parent.left = newRoot
        }
        newRoot.right = n
        n.parent = newRoot
    }
}
