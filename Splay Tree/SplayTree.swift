/*
  A splay tree is a self-adjusting binary search tree with the additional
  property that recently accessed elements are quick to access again.
 
  It performs basic operations such as insertion, look-up and removal in O(log n)
  amortized time.
 
  For many sequences of non-random operations, splay trees perform better than
  other search trees, even when the specific pattern of the sequence is unknown.
 */
public class SplayTree<T: Comparable> {
  
  private var root: SplayTreeNode<T>?
  
  //MARK: Public
  
  public convenience init(_ values: [T]) {
    
    self.init()
    
    for value in values {
      insert(value: value)
    }
  }
  
  func insert(value: T) {
    
    var current: SplayTreeNode<T>? = root
    var parent: SplayTreeNode<T>?
    
    while (current != nil) {
      
      parent = current
      
      if current!.value < value {
        
        current = current!.right
        
      } else if current!.value > value {
        
        current = current!.left
        
      } else {
        
        return
      }
    }
    
    current = SplayTreeNode(value)
    current?.parent = parent
    
    if parent == nil {
      
      root = current
      
    } else if parent!.value < value {
      
      parent!.right = current
      
    } else {
      
      parent!.left = current
    }
    
    splay(current!)
  }
  
  func find(_ value: T) -> Bool {
    
    return findNode(value) != nil ? true : false
  }
  
  func remove(_ value: T) -> Bool {
    
    let node = findNode(value)
    
    if let node = node {
      
      //Make the node to delete root.
      splay(node)
      //node is now root
      
      if node.left == nil {
        
        root = node.right
        node.right?.parent = nil
        
      } else if node.right == nil {
        
        root = node.left
        node.left?.parent = nil
        
      } else {
        
        let leftSubtreeRoot     = node.left!
        let rightSubtreeRoot    = node.right!
        
        node.left  = nil;
        node.right = nil;
        
        leftSubtreeRoot.parent  = nil;
        rightSubtreeRoot.parent = nil;
        
        root = leftSubtreeRoot
        let maxInLeft = maxInSubtree(leftSubtreeRoot)
        splay(maxInLeft)
        //Root is now maxInLeft.
        //Since it is max, it's right subtree is nil.
        root?.right = rightSubtreeRoot
        rightSubtreeRoot.parent = root
      }
      
      return true
      
    } else {
      
      return false
    }
  }
  
  func traverseInorder() -> [T] {
    
    var traversal: [T] = []
    
    recursiveTraverseInorder(root, traversal: &traversal)
    
    return traversal
  }
  
  func traversePreorder() -> [T] {
    
    var traversal: [T] = []
    
    recursiveTraversePreorder(root, traversal: &traversal)
    
    return traversal
  }
  
  func traversePostorder() -> [T] {
    
    var traversal: [T] = []
    
    recursiveTraversePostorder(root, traversal: &traversal)
    
    return traversal
  }
  
  func traverseBreadthFirst() -> [T] {
    return []
  }
  
  //MARK: Private
  
  private func findNode(_ value: T) -> SplayTreeNode<T>? {
    
    var current: SplayTreeNode<T>? = root
    var result: SplayTreeNode<T>?
    
    while (current != nil) {
      
      if current!.value < value {
        
        current = current!.right
        
      } else if current!.value > value {
        
        current = current!.left
        
      } else {
        
        splay(current!)
        result = current
        break
      }
    }
    
    return result
  }
  
  private func maxInSubtree(_ root: SplayTreeNode<T>) -> SplayTreeNode<T> {
    
    var node: SplayTreeNode<T> = root
    
    while (node.right != nil) {
      
      node = node.right!
    }
    
    return node
  }
  
  private func replace(node x: SplayTreeNode<T>, with y: SplayTreeNode<T>?) {
    
    if x.parent == nil {
      root = y
    } else if x == x.parent?.left {
      x.parent?.left = y
    } else {
      x.parent?.right = y
    }
    
    if y != nil {
      y?.parent = x.parent
    }
  }
  
  private func rotateLeft(_ x: SplayTreeNode<T>) {
    
    let y = x.right
    x.right = y?.left
    
    if y?.left != nil {
      y?.left?.parent = x
    }
    
    y?.parent = x.parent
    
    if x.parent == nil {
      
      root = y
      
    } else if x == x.parent?.left {
      
      x.parent?.left = y
      
    } else {
      
      x.parent?.right = y
    }
    
    y?.left = x
    x.parent = y
  }
  
  private func rotateRight(_ x: SplayTreeNode<T>) {
    
    let y = x.left
    x.left = y?.right
    
    if y?.right != nil {
      y?.right?.parent = x
    }
    
    y?.parent = x.parent
    
    if x.parent == nil {
      
      root = y
      
    } else if x == x.parent?.left {
      
      x.parent?.left = y
      
    } else {
      
      x.parent?.right = y
    }
    
    y?.right = x
    x.parent = y
  }
  
  private func splay(_ x: SplayTreeNode<T>) {
    
    while x.parent != nil {
      
      if x.parent!.parent == nil {
        
        if x == x.parent!.left {
          rotateRight(x.parent!)
        } else {
          rotateLeft(x.parent!)
        }
        
      } else if x == x.parent!.left && x.parent == x.parent!.parent!.left {
        
        rotateRight(x.parent!.parent!)
        rotateRight(x.parent!)
        
      } else if x == x.parent!.right && x.parent == x.parent!.parent!.right {
        
        rotateLeft(x.parent!.parent!)
        rotateLeft(x.parent!)
        
      } else if x == x.parent!.left && x.parent == x.parent!.parent!.right {
        
        rotateRight(x.parent!)
        rotateLeft(x.parent!)
        
      } else {
        
        rotateLeft(x.parent!)
        rotateRight(x.parent!)
      }
    }
  }
  
  private func inorderSuccessor(_ node: SplayTreeNode<T>) -> SplayTreeNode<T>? {
    
    return nil
  }
  
  private func recursiveTraverseInorder(_ node: SplayTreeNode<T>?, traversal: inout [T]) {
    
    if let node = node {
      
      recursiveTraverseInorder(node.left, traversal: &traversal)
      traversal.append(node.value)
      recursiveTraverseInorder(node.right, traversal: &traversal)
    }
  }
  
  private func recursiveTraversePreorder(_ node: SplayTreeNode<T>?, traversal: inout [T]) {
    
    if let node = node {
      
      traversal.append(node.value)
      recursiveTraversePreorder(node.left, traversal: &traversal)
      recursiveTraversePreorder(node.right, traversal: &traversal)
    }
  }
  
  private func recursiveTraversePostorder(_ node: SplayTreeNode<T>?, traversal: inout [T]) {
    
    if let node = node {
      
      recursiveTraversePostorder(node.left, traversal: &traversal)
      recursiveTraversePostorder(node.right, traversal: &traversal)
      traversal.append(node.value)
    }
  }
}

//MARK:
fileprivate class SplayTreeNode<T: Comparable>: CustomStringConvertible, Equatable {
  
  var value: T
  
  var left: SplayTreeNode<T>?
  var right: SplayTreeNode<T>?
  var parent: SplayTreeNode<T>?
  
  init(_ value: T) {
    self.value = value
  }
  
  public var description: String {
    
    var desc = "Value: \(value) "
    
    if let left = left {
      desc += "Left: \(left.value) "
    }
    
    if let right = right {
      desc += "Right: \(right.value) "
    }
    
    if let parent = parent {
      desc += "Parent: \(parent.value) "
    }
    
    return desc
  }
  
  static func ==(lhs: SplayTreeNode<T>, rhs: SplayTreeNode<T>) -> Bool {
    return lhs.value == rhs.value
  }
}
