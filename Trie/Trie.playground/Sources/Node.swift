/// A Trie (prefix tree)
///
/// Some of the functionality of the trie makes use of the Queue implementation for this project
///
/// Every node in the Trie stores a bit of information pertaining to what it references:
///   -Character (letter of an inserted word)
///   -Parent (Letter that comes before the current letter in some word)
///   -Children (Words that have more letters than available in the prefix)
///   -isAWord (Does the current letter mark the end of a known inserted word?)
///   -visited (Mainly for the findPrefix() function)
public class Node {
  public var character: String
  public var parent: Node?
  public var children: [String: Node]
  public var isAWord: Bool
  public var visited: Bool // only for findPrefix
  
  init(character: String, parent: Node?) {
    self.character = character
    self.children = [:]
    self.isAWord = false
    self.parent = parent
    self.visited = false
  }
  
  /// Returns `true` if the node is a leaf node, false otherwise.
  var isLeaf: Bool {
    return children.count == 0
  }
  
  /// Changes the parent of the current node to the passed in node.
  ///
  /// - parameter node: A `Node` object.
  func setParent(node: Node) {
    parent = node
  }
  
  /// Returns the child node that holds the specific passed letter.
  ///
  /// - parameter character: A `String`
  ///
  /// - returns: The `Node` object that contains the `character`.
  func getChildAt(character: String) -> Node {
    return children[character]!
  }
  
  /// Returns whether or not the current node marks the end of a valid word.
  var isValidWord: Bool {
    return isAWord
  }
  
  
  /// Returns whether or not the current node is the root of the trie.
  var isRoot: Bool {
    return character == ""
  }
}

// MARK: - CustomStringConvertible
extension Node: CustomStringConvertible {
  public var description: String {
    return ""
  }
}
