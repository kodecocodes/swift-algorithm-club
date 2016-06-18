public class  RBTNode {
  private(set) public var color: Bool
  private(set) public var left: RBTNode!
  private(set) public var right: RBTNode!
  private(set) public var parent: RBTNode!
  private(set) public var data: Int
  init() {
    self.data = -1
    self.color = true
    self.left = nil
    self.right = nil
    self.parent = nil
  }
  init(rootData: Int) {
    self.data = rootData
    self.color = true //0 is black 1 is red
    self.left = nil
    self.right = nil
    self.parent = nil
  }
  deinit {
    print("Node: \(self.data) is bein deinitialized")
  }

  public func grandparent() -> RBTNode? {
    if self.parent === nil || self.parent.parent === nil {
      return nil
    } else {
      return self.parent.parent
    }
  }
  public func sibling() -> RBTNode? {
    if self.parent === nil || self.parent.right === nil || self.parent.left === nil {
        return nil
      }
      if self === self.parent!.left! {
        return self.parent!.right!
      } else {
        return self.parent!.left!
      }
  }
}
public class RBTree {
  private(set) public var root: RBTNode?
  init(rootData: Int) {
    root = RBTNode(rootData: rootData)
    root!.color = false
  }
  init() {
    root = nil
  }
  public func depth() -> Int {
    let n = depth(root!)
    return n
  }
  //return the max depth of the tree
  private func depth(rooty: RBTNode?) -> Int {
    if rooty == nil {
      return 0
    } else {
      return 1+(max(depth(root!.left), depth(root!.right)))
    }
  }

  public func inOrder() {
    inOrder(root)
  }
  //Prints the in order traversal of the current tree
  private func inOrder(root: RBTNode?) {
    if self.root == nil {
      print("The tree is empty.")
    }
    if root == nil {
      return
    }
    inOrder(root!.left)
    print("Data: \(root!.data) Color: \(root!.color)")
    inOrder(root!.right)
  }
   /*
   Basic Algorithm:
     Let Q be P's right child.
     Set P's right child to be Q's left child.
     [Set Q's left-child's parent to P]
     Set Q's left child to be P.
     [Set P's parent to Q]
  */
  private func leftRotate(x: RBTNode) {
      let newRoot = x.right
      x.right = newRoot.left
        if newRoot.left !== nil {
          newRoot.left.parent = x
        }
        newRoot.parent = x.parent
        if x.parent === nil {
          root = newRoot
        } else if x === x.parent.left {
          x.parent.left = newRoot
        } else {
          x.parent.right = newRoot
        }
        newRoot.left = x
        x.parent = newRoot
  }
  /*
   Basic Algorithm:
     Let P be Q's left child.
     Set Q's left child to be P's right child.
     [Set P's right-child's parent to Q]
     Set P's right child to be Q.
     [Set Q's parent to P]
  */
  private func rightRotate(x: RBTNode) {
    let newRoot = x.left
    x.left = newRoot.right
    if newRoot.right !== nil {
      newRoot.right.parent = x
    }
    newRoot.parent = x.parent
    if x.parent === nil {
      root = newRoot
    } else if x === x.parent.right {
      x.parent.right = newRoot
    } else {
      x.parent.left = newRoot
    }
    newRoot.right = x
    x.parent = newRoot
  }
  public func insertFixup(value: Int) {
    let inserted = find(value)
    print("Inserted Node: \(inserted!.data)")
    insertCase1(inserted)
    }
  //Case where root is the only node
  private func insertCase1(inserted: RBTNode?) {
    let myroot = self.root!
    if myroot === inserted! {
      self.root!.color = false
    }
    insertCase2(inserted!)
    }
  //Case for inserting a node as a child of a black node
  private func insertCase2(inserted: RBTNode?) {
    if inserted!.parent!.color == false {
        return
    }
    insertCase3(inserted!)
    }
  //Insert case for if the parent is black and parent's siblng is black
  private func insertCase3(inserted: RBTNode?) {
    if inserted!.parent!.sibling() != nil &&
        inserted!.parent!.sibling()!.color == true {
        inserted!.parent!.color = false
        inserted!.parent!.sibling()!.color = false
        let g = inserted!.grandparent
        g()!.color = true
        if g()!.parent == nil {
          g()!.color = false
        }
    }
  insertCase4(inserted)
  }
  //Insert case for Node N is left of parent and parent is right of grandparent
  private func insertCase4( insert: RBTNode?) {
    var inserted = insert
    if (inserted! === inserted!.parent!.right) &&
      (inserted!.grandparent()!.left === inserted!.parent!) {

      leftRotate(inserted!.parent)
      inserted! = inserted!.left
    } else if (inserted! === inserted!.parent!.left) &&
            (inserted!.grandparent()!.right === inserted!.parent!) {

      rightRotate(inserted!.parent)
      inserted! = inserted!.right
    }
    insertCase5(inserted)
  }
  //Insert case for Node n where parent is red and parent's sibling is black
  private func insertCase5(inserted: RBTNode?) {
    if inserted!.parent!.color == true &&
       (inserted!.parent!.sibling()?.color == false ||
        inserted!.parent!.sibling() == nil) {

        if inserted! === inserted!.parent!.left && inserted!.grandparent()!.left === inserted!.parent! {
          inserted!.parent.color = false
          inserted!.grandparent()?.color = true
          if inserted! === inserted!.parent!.left {
            rightRotate(inserted!.grandparent()!)
          }
        } else if inserted! === inserted!.parent!.right && inserted!.grandparent()!.right === inserted!.parent! {
          inserted!.parent.color = false
          inserted!.grandparent()?.color = true
          leftRotate(inserted!.grandparent()!)
        }
    }
  }

  public func insert(value: Int) {
    insert(value, parent: root!)
    insertFixup(value)
  }
  //Basic BST insert implementation
  private func insert(value: Int, parent: RBTNode) {
      if self.root == nil {
        self.root = RBTNode(rootData: value)
        return
      } else if value < parent.data {
        if let left = parent.left {
          insert(value, parent: left)
        } else {
          parent.left = RBTNode(rootData: value)
          parent.left?.parent = parent
        }
      } else {
        if let right = parent.right {
          insert(value, parent: right)
        } else {
          parent.right = RBTNode(rootData: value)
          parent.right?.parent = parent
        }
      }
    }
    public func find(data: Int) -> RBTNode? {
      return find(root!, data: data)
    }
    //Returns the reference to the RBTNode whos data was requested
    private func find(root: RBTNode, data: Int) -> RBTNode? {
        if data == root.data {
          return root
        }
        if root.data != data && root.right == nil && root.left == nil {
          return nil
        } else if data > root.data {
          return find(root.right, data: data)
        } else if data < root.data {
          return find(root.left, data: data)
        } else {
          return nil
        }
    }

    //DELETION HELPER FUNCTIONS
    public func remove(value: Int) {
        let toRemove = find(value)
        if toRemove == nil {
          return
        }
    }
    //Transplant the positions of two nodes in the RBTree
    public func replaceNode(n1: RBTNode, n2: RBTNode) {
      let temp = n1.data
      let temp_color = n1.color
      n1.data = n2.data
      n1.color = n2.color
      n2.data = temp
      n2.color = temp_color
    }
    //returns the node with the minimum value in the subtree
    public func minimum(node: RBTNode) -> RBTNode {
      var minimumNode = node
      while minimumNode.left !== nil {
        minimumNode = minimumNode.left
      }
      return minimumNode
    }
    //Returns the next largest node in the tree
    public func successor(node: RBTNode) -> RBTNode? {
      var nextLargestNode = node
      if nextLargestNode.right !== nil {
        return minimum(nextLargestNode.right)
      }
      var successor = nextLargestNode.parent
      while successor !== nil && nextLargestNode === successor.right {
        nextLargestNode = successor
        successor = successor.parent
      }
      return successor
    }
    //Returns the next smallest node in the tree
    public func predecessor(node: RBTNode) -> RBTNode {
      var nextSmallestNode = node
      if nextSmallestNode.left !== nil {
        return minimum(nextSmallestNode.left)
      }
      var successor = nextSmallestNode.parent
      while successor !== nil && nextSmallestNode === successor.left {
        nextSmallestNode = successor
        successor = successor.parent
      }
      return successor
    }
    //Returns the node with the largest value in the subtree
    public func maximum(rootnode: RBTNode) -> RBTNode {
      var rootNode = rootnode
      while rootNode.right !== nil {
        rootNode = rootNode.right
      }
      return rootNode
    }
  //call to remove a node from the tree
  public func delete(x: Int) {
    let toDel = find(x)
    deleteNode(toDel!)
  }
  //Function call for removing a node
  private func deleteNode(todel: RBTNode?) {
    var toDel = todel
    //case for if todel is the only node in the tree
    if toDel!.left === nil && toDel!.right === nil && toDel!.parent === nil {
      toDel = nil
      self.root = nil
      return
    }
    //case for if toDell is a red node w/ no children
    if toDel!.left === nil && toDel!.right === nil && toDel!.color == true {
      if toDel!.parent.left === toDel! {
        toDel!.parent.left = nil
        toDel = nil
      } else if toDel!.parent === nil {
        toDel = nil
      } else {
        toDel?.parent.right = nil
        toDel = nil
      }
      return
    }
    //case for toDel having two children
    if toDel!.left !== nil && toDel!.right !== nil {
      let pred = maximum(toDel!.left!)
      toDel!.data = pred.data
      toDel! = pred
    }
    //case for toDel having one child
    var child: RBTNode? = nil
    if toDel!.right === nil {
      child = toDel!.left
    } else {
       child = toDel!.right
    }
    if toDel!.color == false && child !== nil {
      toDel!.color = child!.color
      deleteCase1(toDel!)
    }

    if child !== nil {
      replaceNode(toDel!, n2: child!)
      if toDel!.parent === nil && child !== nil {
        child!.color = false
      }
    }
    if toDel!.parent.left === toDel! {
      toDel!.parent.left = nil
      toDel = nil
      return
    } else if toDel!.parent === nil {
      toDel = nil
      return
    } else {
      toDel?.parent.right = nil
      toDel = nil
      return
    }
  }
  //delete case for if parent is nil after deletion
  private func deleteCase1( toDel: RBTNode?) {
      if toDel?.parent === nil {
        return
      } else {
        deleteCase2(toDel)
      }
  }
  //case to fix tree after deletion and sibling is red
  private func deleteCase2(toDel: RBTNode?) {
    let sibling = toDel!.sibling()
    if sibling?.color == true {
       toDel!.parent.color = true
       sibling?.color = false
       if toDel! === toDel!.parent.left {
         leftRotate(toDel!.parent)
       } else {
         rightRotate(toDel!.parent)
       }
       deleteCase3(toDel!)
    }
  }
  //delete case for fixing tree when parnet is black and sibling is black and sibling.children are also black
  private func deleteCase3(toDel: RBTNode?) {
    if toDel!.parent?.color == false &&
       toDel!.sibling()?.color == false &&
       toDel!.sibling()?.left!.color == false &&
       toDel!.sibling()?.right!.color == false {

        toDel!.sibling()?.color = true
        toDel!.parent?.color = false
    } else {
      deleteCase4(toDel)
    }
  }
  private func deleteCase4(toDel: RBTNode?) {
    if toDel!.parent?.color == true &&
       toDel!.sibling()?.color == false &&
       toDel!.sibling()?.left!.color == false &&
       toDel!.sibling()?.right!.color == false {

       toDel!.sibling()?.color = true
       toDel!.parent.color = false
    } else {
      deleteCase5(toDel)
    }
  }
  //delete case for fixing tree if toDel is a left child and sibling(n) is black and children of sibling(n) are black and white respectibely
  private func deleteCase5(toDel: RBTNode?) {
    if toDel! === toDel!.parent?.left &&
       toDel!.sibling()?.color == false &&
       toDel!.sibling()?.left.color == true &&
       toDel!.sibling()?.right.color == false {

       toDel!.sibling()?.color = true
       toDel!.sibling()?.left?.color = false
       rightRotate(toDel!.sibling()!)
    }
    //opposite case
    else if toDel! === toDel!.parent?.right &&
            toDel!.sibling()?.color == false &&
            toDel!.sibling()?.left.color == false &&
            toDel!.sibling()?.right.color == true {

            toDel!.sibling()?.color = true
            toDel!.sibling()?.right?.color = false
            leftRotate(toDel!.sibling()!)
    }
  }
  //final rotations to be done after deleting a black node from the tree
  private func deleteCase6(toDel: RBTNode?) {
    let color = toDel!.sibling()?.color
    toDel!.parent?.color = color!
    toDel!.parent?.color = false
    if toDel! === toDel!.parent.left {
        toDel!.sibling()?.right?.color = false
        leftRotate(toDel!.parent!)
    } else {
      toDel!.sibling()?.left?.color = false
      rightRotate(toDel!.parent!)
    }
  }
}

var tree = RBTree(rootData: 8)
tree.insert(5)
tree.insert(4)
tree.insert(9)
tree.delete(9)
tree.insert(3)
tree.insert(10)
tree.delete(3)
var x = tree.find(5)
tree.inOrder()
