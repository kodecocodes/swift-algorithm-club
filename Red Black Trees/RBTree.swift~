
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
    self.color = true
    self.left = nil
    self.right = nil
    self.parent = nil
  }
}
public class RBTree {

    private(set) public var root: RBTNode?
    init(rootData: Int) {
      root = RBTNode(rootData: rootData)
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
        print("nil")
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


    private func insertFixup(){}
    public func insert(value: Int) {
      insert(value, parent: root!)
      //insertFixUp()
    }
    private func insert(value: Int, parent: RBTNode) {
        if value < parent.data {
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
}

var tree = RBTree(rootData: 8)
tree.insert(9)
tree.insert(6)
tree.insert(5)
tree.insert(4)
tree.insert(3)
tree.inOrder()
print("_________________________")
let x = tree.root!
print("root: \(tree.root!.data)")
tree.rightRotate(x)
print("root: \(tree.root!.data)")
tree.inOrder()

let t = tree.find(234)
if t == nil{
  print("ASDASD")
}
//how you access certain elements
//let root = tree.root!.left!
//if(root.parent === nil){
//  print("niggs")
//}
//else{
//  print(root.parent.data)
//}

//print(tree.root!.data)
//print(tree.root!.right!.data)
//print(tree.root!.left!.data)
