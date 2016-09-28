//: Playground - noun: a place where people can play

public indirect enum BinaryTree<T> {
  case Node(BinaryTree<T>, T, BinaryTree<T>)
  case Empty

  public var count: Int {
    switch self {
    case let .Node(left, _, right):
      return left.count + 1 + right.count
    case .Empty:
      return 0
    }
  }
}

extension BinaryTree: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .Node(left, value, right):
      return "value: \(value), left = [" + left.description + "], right = [" + right.description + "]"
    case .Empty:
      return ""
    }
  }
}



// leaf nodes
let node5 = BinaryTree.Node(.Empty, "5", .Empty)
let nodeA = BinaryTree.Node(.Empty, "a", .Empty)
let node10 = BinaryTree.Node(.Empty, "10", .Empty)
let node4 = BinaryTree.Node(.Empty, "4", .Empty)
let node3 = BinaryTree.Node(.Empty, "3", .Empty)
let nodeB = BinaryTree.Node(.Empty, "b", .Empty)

// intermediate nodes on the left
let aMinus10 = BinaryTree.Node(nodeA, "-", node10)
let timesLeft = BinaryTree.Node(node5, "*", aMinus10)

// intermediate nodes on the right
let minus4 = BinaryTree.Node(.Empty, "-", node4)
let divide3andB = BinaryTree.Node(node3, "/", nodeB)
let timesRight = BinaryTree.Node(minus4, "*", divide3andB)

// root node
let tree = BinaryTree.Node(timesLeft, "+", timesRight)

print(tree)
tree.count  // 12



extension BinaryTree {
  public func traverseInOrder(process: (T) -> Void) {
    if case let .Node(left, value, right) = self {
      left.traverseInOrder(process: process)
      process(value)
      right.traverseInOrder(process: process)
    }
  }

  public func traversePreOrder(process: (T) -> Void) {
    if case let .Node(left, value, right) = self {
      process(value)
      left.traversePreOrder(process: process)
      right.traversePreOrder(process: process)
    }
  }

  public func traversePostOrder(process: (T) -> Void) {
    if case let .Node(left, value, right) = self {
      left.traversePostOrder(process: process)
      right.traversePostOrder(process: process)
      process(value)
    }
  }
}

//tree.traverseInOrder { s in print(s) }
//tree.traversePreOrder { s in print(s) }
tree.traversePostOrder { s in print(s) }
