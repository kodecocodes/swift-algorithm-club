/*
  Binary search tree using value types

  The tree is immutable. Any insertions or deletions will create a new tree.
*/
public enum BinarySearchTree<T: Comparable> {
  case Empty
  case Leaf(T)
  indirect case Node(BinarySearchTree, T, BinarySearchTree)

  /* How many nodes are in this subtree. Performance: O(n). */
  public var count: Int {
    switch self {
    case .Empty: return 0
    case .Leaf: return 1
    case let .Node(left, _, right): return left.count + 1 + right.count
    }
  }

  /* Distance of this node to its lowest leaf. Performance: O(n). */
  public var height: Int {
    switch self {
    case .Empty: return 0
    case .Leaf: return 1
    case let .Node(left, _, right): return 1 + max(left.height, right.height)
    }
  }

  /*
    Inserts a new element into the tree.
    Performance: runs in O(h) time, where h is the height of the tree.
  */
  public func insert(newValue: T) -> BinarySearchTree {
    switch self {
    case .Empty:
      return .Leaf(newValue)

    case .Leaf(let value):
      if newValue < value {
        return .Node(.Leaf(newValue), value, .Empty)
      } else {
        return .Node(.Empty, value, .Leaf(newValue))
      }

    case .Node(let left, let value, let right):
      if newValue < value {
        return .Node(left.insert(newValue), value, right)
      } else {
        return .Node(left, value, right.insert(newValue))
      }
    }
  }

  /*
    Finds the "highest" node with the specified value.
    Performance: runs in O(h) time, where h is the height of the tree.
  */
  public func search(x: T) -> BinarySearchTree? {
    switch self {
    case .Empty:
      return nil
    case .Leaf(let y):
      return (x == y) ? self : nil
    case let .Node(left, y, right):
      if x < y {
        return left.search(x)
      } else if y < x {
        return right.search(x)
      } else {
        return self
      }
    }
  }

  public func contains(x: T) -> Bool {
    return search(x) != nil
  }

  /*
    Returns the leftmost descendent. O(h) time.
  */
  public func minimum() -> BinarySearchTree {
    var node = self
    var prev = node
    while case let .Node(next, _, _) = node {
      prev = node
      node = next
    }
    if case .Leaf = node {
      return node
    }
    return prev
  }

  /*
    Returns the rightmost descendent. O(h) time.
  */
  public func maximum() -> BinarySearchTree {
    var node = self
    var prev = node
    while case let .Node(_, _, next) = node {
      prev = node
      node = next
    }
    if case .Leaf = node {
      return node
    }
    return prev
  }
}

extension BinarySearchTree: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .Empty: return "."
    case .Leaf(let value): return "\(value)"
    case .Node(let left, let value, let right):
      return "(\(left.debugDescription) <- \(value) -> \(right.debugDescription))"
    }
  }
}
