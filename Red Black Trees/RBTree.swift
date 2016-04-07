public class RBTNode {
    var color: Int?
    var left: RBTNode?
    var right: RBTNode?
    var parent: RBTNode?
    var data: Int

    init(data: Int) {
        self.data = data
        self.left = nil
        self.right = nil
        self.parent = nil
        self.color = nil
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
}

extension RBTNode {
  public func insert(value: Int) {
    insert(value, parent: self)
  }
  private func insert(value: Int, parent: RBTNode) {
    if value < self.data {
      if let left = left {
        left.insert(value, parent: left)
      } else {
        left = RBTNode(data: value)
        left?.parent = parent
      }
    } else {
      if let right = right {
        right.insert(value, parent: right)
      } else {
        right = RBTNode(data: value)
        right?.parent = parent
      }
    }
  }
}
extension RBTNode{
  public func inOrder(root: RBTNode?){
    if(root == nil){
      return
    }
    inOrder(root!.left)
    print(root!.data)
    inOrder(root!.right)
  }
}

var me = RBTNode(data: 5)
var me2 = RBTNode(data: 6)

me.insert(4)
me.insert(3)
me.insert(2)
me.insert(1)
me.insert(0)
me.inOrder(me) //stupid way to call this
