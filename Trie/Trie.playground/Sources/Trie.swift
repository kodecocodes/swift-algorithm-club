/// The Trie class has the following attributes:
///   -root (the root of the trie)
///   -wordList (the words that currently exist in the trie)
///   -wordCount (the number of words in the trie)
public final class Trie {
  typealias Node = TrieNode<Character>
  fileprivate let root: Node
  
  public init() {
    root = TrieNode<Character>()
  }
}

// MARK: - Basic Methods
public extension Trie {
  func insert(word: String) {
    guard !word.isEmpty else { return }
    var currentNode = root
    
    var characters = Array(word.lowercased().characters)
    var currentIndex = 0
    
    while currentIndex < characters.count {
      let character = characters[currentIndex]
      if let child = currentNode.children[character] {
        currentNode = child
      } else {
        currentNode.add(child: character)
        currentNode = currentNode.children[character]!
      }
      
      currentIndex += 1
      if currentIndex == characters.count {
        currentNode.isTerminating = true
      }
    }
  }
  
  func contains(word: String) -> Bool {
    guard !word.isEmpty else { return false }
    var currentNode = root
    
    var characters = Array(word.lowercased().characters)
    var currentIndex = 0
    
    while currentIndex < characters.count, let child = currentNode.children[characters[currentIndex]] {
      currentNode = child
      currentIndex += 1
    }
    
    if currentIndex == characters.count && currentNode.isTerminating {
      return true
    } else {
      return false
    }
  }
  
  func remove(word: String) {
    guard !word.isEmpty else { return }
    var currentNode = root
    
    var characters = Array(word.lowercased().characters)
    var currentIndex = 0
    
    while currentIndex < characters.count {
      let character = characters[currentIndex]
      guard let child = currentNode.children[character] else { return }
      currentNode = child
      currentIndex += 1
    }
    
    if currentNode.children.count > 0 {
      currentNode.isTerminating = false
    } else {
      var character = currentNode.value
      while currentNode.children.count == 0, let parent = currentNode.parent, !parent.isTerminating {
        currentNode = parent
        currentNode.children[character!] = nil
        character = currentNode.value
      }
    }
  }
}
