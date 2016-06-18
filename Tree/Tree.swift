public class TreeNode<T> {
  public var value: T

  public var parent: TreeNode?
  public var children = [TreeNode<T>]()

  public init(value: T) {
    self.value = value
  }

  public func addChild(node: TreeNode<T>) {
    children.append(node)
    node.parent = self
  }
}

extension TreeNode: CustomStringConvertible {
  public var description: String {
    var s = "\(value)"
    if !children.isEmpty {
      s += " {" + children.map { $0.description }.joinWithSeparator(", ") + "}"
    }
    return s
  }
}

extension TreeNode where T: Equatable {
  func search(value: T) -> TreeNode? {
    if value == self.value {
      return self
    }
    for child in children {
      if let found = child.search(value) {
        return found
      }
    }
    return nil
  }
}
