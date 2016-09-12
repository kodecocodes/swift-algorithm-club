public final class TrieNode<T: Hashable> {
  public var value: T?
  public weak var parent: TrieNode?
  public var children: [T: TrieNode] = [:]
  public var isTerminating = false
  
  init() {}
  
  init(value: T, parent: TrieNode? = nil) {
    self.value = value
    self.parent = parent
  }
}

// MARK: - Insertion
public extension TrieNode {
  func add(child: T) {
    guard children[child] == nil else { return }
    children[child] = TrieNode(value: child, parent: self)
  }
}
