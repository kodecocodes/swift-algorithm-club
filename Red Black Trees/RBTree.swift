public class  RBTNode{
  private(set) public var color: Bool
  private(set) public var left: RBTNode!
  private(set) public var right: RBTNode!
  private(set) public var parent: RBTNode!
  private(set) public var data: Int
  init(){
    self.data = -1
    self.color = true
    self.left = nil
    self.right = nil
    self.parent = nil
  }
  init(rootData: Int){
    self.data = rootData
    self.color = true //0 is black 1 is red
    self.left = nil
    self.right = nil
    self.parent = nil
  }
  deinit{
    print("Node: \(self.data) is bein deinitialized")
  }
  public func grandparent()->RBTNode?{
    if(self.parent === nil || self.parent.parent === nil){
      return nil
    }
    else{
      return self.parent.parent
    }
  }
  public func sibling()->RBTNode?{
      if(self.parent === nil || self.parent.right === nil || self.parent.left === nil){
        return nil
      }
      if(self === self.parent!.left!){
        return self.parent!.right!
      }
      else{
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
    init(){
      root = nil
    }
    public func depth()->Int{
      let n = depth(root!)
      return n
    }
    private func depth(rooty:RBTNode?)->Int{
      if(rooty == nil){
        return 0
      }
      else{
        return 1+(max(depth(root!.left),depth(root!.right)))
      }
    }

    public func inOrder(){
      inOrder(root)
    }
    private func inOrder(root: RBTNode?){
      if(root == nil){
        return
      }
      inOrder(root!.left)
      print("Data: \(root!.data) Color: \(root!.color)")
      inOrder(root!.right)
    }

    private func leftRotate(x: RBTNode) {
        let newRoot = x.right
        x.right = newRoot.left
          if (newRoot.left !== nil) {
            newRoot.left.parent = x
          }
          newRoot.parent = x.parent
          if(x.parent === nil) {
            root = newRoot
          } else if (x === x.parent.left) {
            x.parent.left = newRoot
          } else {
            x.parent.right = newRoot
          }
          newRoot.left = x
          x.parent = newRoot
  }
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

public func insertFixup(value: Int){
  let inserted = find(value)

  if(inserted == nil){
    print("INSERTEDNILLLLLLLL")
  }
  print("inserted: ")
  print(inserted!.data)
  insertCase1(inserted)
}
private func insertCase1(inserted: RBTNode?){
  let myroot = self.root!
  if myroot === inserted!{
    self.root!.color = false
    print("ITS THE ROOT")
    print("insert case 1: The root was nil and we inserted a black node at root")
  }
  insertCase2(inserted!)
}
private func insertCase2(inserted: RBTNode?){
  if inserted!.parent!.color == false{
      print("Insert case 2: parent is black so nothing to change")
      return
  }
  insertCase3(inserted!)
}
private func insertCase3(inserted: RBTNode?){
  if(inserted!.parent!.sibling() != nil && inserted!.parent!.sibling()!.color == true){
    print("insert case3: If both the parent P and the uncle U are red, then both of them can be repainted black and the grandparent G ")
    inserted!.parent!.color = false
    inserted!.parent!.sibling()!.color = false
    let g = inserted!.grandparent
    g()!.color = true
    if(g()!.parent == nil){
      g()!.color = false
    }
  }
  insertCase4(inserted)
}

private func insertCase4(var inserted: RBTNode?){
  if((inserted! === inserted!.parent!.right) && (inserted!.grandparent()!.left === inserted!.parent!)){
    print("case 4")
    leftRotate(inserted!.parent)
    inserted! = inserted!.left
  }
  else if((inserted! === inserted!.parent!.left) && (inserted!.grandparent()!.right === inserted!.parent!)){
     print("case 4")
    rightRotate(inserted!.parent)
    inserted! = inserted!.right
  }
  insertCase5(inserted)
}
private func insertCase5(inserted: RBTNode?){
  if((inserted!.parent!.color == true && (inserted!.parent!.sibling()?.color == false || inserted!.parent!.sibling() == nil ))){
      if(inserted! === inserted!.parent!.left && inserted!.grandparent()!.left === inserted!.parent!){
        print("insert case 5: The parent P is red but the uncle U is black/nil, the current node N is the left child of P, and P is the left child of its parent G")
        inserted!.parent.color = false
        inserted!.grandparent()?.color = true
        if(inserted! === inserted!.parent!.left){
          print("its on the left")
          rightRotate(inserted!.grandparent()!)
        }
      }
      else if(inserted! === inserted!.parent!.right && inserted!.grandparent()!.right === inserted!.parent!){
        print("insert case 5: RIGHT RIGHT")
        inserted!.parent.color = false
        inserted!.grandparent()?.color = true

          print("Its on the right")
          leftRotate(inserted!.grandparent()!)
      }
  }
  print("weve reached the end boys")
}

    public func insert(value: Int) {
      insert(value, parent: root!)
      insertFixup(value)
    }
    private func insert(value: Int, parent: RBTNode) {
        if self.root == nil{
          self.root = RBTNode(rootData: value)
          return
        }
        else if value < parent.data {
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
      public func find(data: Int)->RBTNode?{
        return find(root!,data: data)
      }

      private func find(root: RBTNode, data: Int)->RBTNode?{
          if data == root.data{
            return root
          }
          if root.data != data && root.right == nil && root.left == nil {
            return nil
          }
          else if data > root.data{
            return find(root.right, data: data)
          }
          else if data < root.data{
            return find(root.left, data: data)
          }
          else{
            return nil
          }
      }

      //DELETION HELPER FUNCTIONS
      public func remove(value: Int){
          let toRemove = find(value)
          if(toRemove == nil){
            return
          }
      }
      public func replaceNode(n1: RBTNode, n2: RBTNode){
        var temp = n1.data
        var temp_color = n1.color
        n1.data = n2.data
        n1.color = n2.color
        n2.data = temp
        n2.color = temp_color
      }
      public func minimum(var node: RBTNode)->RBTNode {
        while node.left !== nil{
          node = node.left
        }
        return node
      }
      public func successor(var node: RBTNode) -> RBTNode? {
        if node.right !== nil {
          return minimum(node.right)
        }
        var successor = node.parent
        while successor !== nil && node === successor.right {
          node = successor
          successor = successor.parent
        }
        return successor
      }
      public func predecessor(var node: RBTNode) -> RBTNode{
        if node.left !== nil {
          return minimum(node.left)
        }
        var successor = node.parent
        while successor !== nil && node === successor.left {
          node = successor
          successor = successor.parent
        }
        return successor
      }
      public func maximum(var rootNode: RBTNode) -> RBTNode{
        while rootNode.right !== nil {
          rootNode = rootNode.right
        }
        return rootNode
      }
  private func deletionFixup(x: RBTNode) {}

  public func delete(x: Int){
    let toDel = find(x)
    deleteNode(toDel!)
  }
  private func deleteNode(var toDel: RBTNode?){
    print("DELETE CASE 0")
    if(toDel!.left == nil && toDel!.right == nil && toDel!.color == true){
      print("IM IN HERE")
      //DEINIT NOT BEING CALLED AGAIN?
      toDel = nil
      return
    }
    if(toDel!.left !== nil && toDel!.right !== nil){
      var pred = maximum(toDel!.left!)
      toDel!.data = pred.data
      toDel! = pred
    }
    var child: RBTNode? = nil

    if(toDel!.right === nil){
      child = toDel!.left
    }
    else{
       child = toDel!.right
    }

    if(toDel!.color == false){
      toDel!.color = child!.color
      deleteCase1(toDel!)
    }

    if(child !== nil){
      replaceNode(toDel!, n2: child!)

      if(toDel!.parent === nil && child !== nil){
        child!.color = false
      }
    }
    print("This statement isnt actually deleting the object??? V")
    toDel = nil
  }
  private func deleteCase1(var toDel: RBTNode?){
      print("DELETE CASE 1")
      if(toDel?.parent === nil){
        return
      }
      else{
        deleteCase2(toDel)
      }
  }
  private func deleteCase2(var toDel: RBTNode?){
    print("DELETE CASE 2")
    var sibling = toDel!.sibling()
    if(sibling?.color == true){
       toDel!.parent.color = true;
       sibling?.color = false
       if(toDel! === toDel!.parent.left){
         leftRotate(toDel!.parent)
       }
       else{
         rightRotate(toDel!.parent)
       }
       deleteCase3(toDel!)
    }
  }
  private func deleteCase3(var toDel: RBTNode?){
    print("DELETE CASE 3")
    if(toDel!.parent?.color == false && toDel!.sibling()?.color == false && toDel!.sibling()?.left!.color == false && toDel!.sibling()?.right!.color == false){
        toDel!.sibling()?.color = true
        toDel!.parent?.color = false
    }
    else{
      deleteCase4(toDel)
    }
  }
  private func deleteCase4(var toDel: RBTNode?){
    print("DELETE CASE 4")
    if(toDel!.parent?.color == true && toDel!.sibling()?.color == false && toDel!.sibling()?.left!.color == false && toDel!.sibling()?.right!.color == false){
        toDel!.sibling()?.color = true
        toDel!.parent.color = false
    }
    else{
      deleteCase5(toDel)
    }
  }
  private func deleteCase5(var toDel:RBTNode?){
    print("DELETE CASE 5")
    if(toDel! === toDel!.parent?.left && toDel!.sibling()?.color == false && toDel!.sibling()?.left.color == true && toDel!.sibling()?.right.color == false){
      toDel!.sibling()?.color = true
      toDel!.sibling()?.left?.color = false
      rightRotate(toDel!.sibling()!)
    }
    else if(toDel! === toDel!.parent?.right && toDel!.sibling()?.color == false && toDel!.sibling()?.left.color == false && toDel!.sibling()?.right.color == true){
      toDel!.sibling()?.color = true
      toDel!.sibling()?.right?.color = false
      leftRotate(toDel!.sibling()!)
    }
  }
  private func deleteCase6(var toDel: RBTNode?){
    print("DELETE CASE 6")
    let color = toDel!.sibling()?.color
    toDel!.parent?.color = color!
    toDel!.parent?.color = false
    if(toDel! === toDel!.parent.left){
        toDel!.sibling()?.right?.color = false
        leftRotate(toDel!.parent!)
    }
    else{
      toDel!.sibling()?.left?.color = false
      rightRotate(toDel!.parent!)
    }
  }
}



var tree = RBTree(rootData: 8)

tree.insert(6)
tree.delete(6)
tree.inOrder()
print("_______")



//print("_________________________")
//let x = tree.root!
//print("sibling: \(tree.root!.left!.sibling()!.data)")
//print("root: \(tree.root!.data)")
//tree.rightRotate(x)
//print("root: \(tree.root!.data)")
//tree.inOrder()

//let l = tree.root!.left!
//let r = tree.root!.right!
//print(l.data)
//print(r.data)
//if tree.root!.parent == nil{
//  print("ASDASD")
//}

//how you access certain elements
//let root = tree.root!.left!
//if(root.parent === nil){
//  print("nil")
//}
//else{
//  print(root.parent.data)
//}

//print(tree.root!.data)
//print(tree.root!.right!.data)
//print(tree.root!.left!.data)

