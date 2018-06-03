/*
  Binary search tree using value types

  The tree is immutable. Any insertions or deletions will create a new tree.
*/
public enum BinarySearchTree<T: Comparable> {
  case empty
  case leaf(T)
  indirect case node(BinarySearchTree, T, BinarySearchTree)

  /* How many nodes are in this subtree. Performance: O(n). */
  public var count: Int {
    switch self {
    case .empty: return 0
    case .leaf: return 1
    case let .node(left, _, right): return left.count + 1 + right.count
    }
  }

  /* Distance of this node to its lowest leaf. Performance: O(n). */
  public var height: Int {
    switch self {
    case .empty: return -1
    case .leaf: return 0
    case let .node(left, _, right): return 1 + max(left.height, right.height)
    }
  }

  /*
    Inserts a new element into the tree.
    Performance: runs in O(h) time, where h is the height of the tree.
  */
  public func insert(newValue: T) -> BinarySearchTree {
    switch self {
    case .empty:
      return .leaf(newValue)

    case .leaf(let value):
      if newValue < value {
        return .node(.leaf(newValue), value, .empty)
      } else {
        return .node(.empty, value, .leaf(newValue))
      }

    case .node(let left, let value, let right):
      if newValue < value {
        return .node(left.insert(newValue), value, right)
      } else {
        return .node(left, value, right.insert(newValue))
      }
    }
  }

  /*
    Finds the "highest" node with the specified value.
    Performance: runs in O(h) time, where h is the height of the tree.
  */
  public func search(x: T) -> BinarySearchTree? {
    switch self {
    case .empty:
      return nil
    case .leaf(let y):
      return (x == y) ? self : nil
    case let .node(left, y, right):
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
    while case let .node(next, _, _) = node {
      prev = node
      node = next
    }
    if case .leaf = node {
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
    while case let .node(_, _, next) = node {
      prev = node
      node = next
    }
    if case .leaf = node {
      return node
    }
    return prev
  }
}

extension BinarySearchTree: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .empty: return "."
    case .leaf(let value): return "\(value)"
    case .node(let left, let value, let right):
      return "(\(left.debugDescription) <- \(value) -> \(right.debugDescription))"
    }
  }
}
