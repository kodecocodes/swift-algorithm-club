/// The Trie class has the following attributes:
///   -root (the root of the trie)
///   -wordList (the words that currently exist in the trie)
///   -wordCount (the number of words in the trie)
public class Trie {
  private var root = Node(character: "", parent: nil)
  private(set) var wordList: [String] = []
  private(set) var wordCount = 0
  
  init(words: Set<String>) {
    words.forEach { insert(word: $0) }
  }
  
  /// Merge two `Trie` objects into one and returns the merged `Trie`
  ///
  /// - parameter other: Another `Trie`
  ///
  /// - returns: The newly unioned `Trie`.
  func merge(other: Trie) -> Trie {
    let newWordList = Set(wordList + other.wordList)
    return Trie(words: newWordList)
  }
  
  /// Looks for a specific key and returns a tuple that has a reference to the node (if found) and true/false depending on if it was found.
  ///
  /// - parameter key: A `String` that you would like to find.
  ///
  /// - returns: A tuple containing the an optional `Node`. If the key is found, it will return a non-nil `Node`. The second part of the tuple contains a bool indicating whether it was found or not.
  func find(key: String) -> (node: Node?, found: Bool) {
    var currentNode = root
    
    for character in key.characters {
      if currentNode.children["\(character)"] == nil {
        return (nil, false)
      }
      currentNode = currentNode.children["\(character)"]!
    }
    return (currentNode, currentNode.isValidWord)
  }
  
  /// Returns true if the `Trie` is empty, false otherwise.
  var isEmpty: Bool {
    return wordCount == 0
  }
  
  /// Checks if the a word is currently in the `Trie`.
  ///
  /// - parameter word: A `String` you want to check.
  ///
  /// - returns: Returns `true` if the word exists in the `Trie`. False otherwise.
  func contains(word: String) -> Bool {
    return find(key: word.lowercased()).found
  }
  
  func isPrefix(_ prefix: String) -> (node: Node?, found: Bool) {
    let prefix = prefix.lowercased()
    var currentNode = root
    
    for character in prefix.characters {
      if currentNode.children["\(character)"] == nil {
        return (nil, false)
      }
      
      currentNode = currentNode.children["\(character)"]!
    }
    
    if currentNode.children.count > 0 {
      return (currentNode, true)
    }
    
    return (nil, false)
  }
  
  /// Inserts a word into the trie. Returns a tuple containing the word attempted to tbe added, and true/false depending on whether or not the insertion was successful.
  ///
  /// - parameter word: A `String`.
  ///
  /// - returns: A tuple containing the word attempted to be added, and whether it was successful.
  @discardableResult func insert(word: String) -> (word: String, inserted: Bool) {
    let word = word.lowercased()
    guard !contains(word: word), !word.isEmpty else { return (word, false) }
    
    var currentNode = root
    var length = word.characters.count
    
    var index = 0
    var character = word.characters.first!
    
    while let child = currentNode.children["\(character)"] {
      currentNode = child
      length -= 1
      index += 1
      
      if length == 0 {
        currentNode.isAWord = true
        wordList.append(word)
        wordCount += 1
        return (word, true)
      }
      
      character = Array(word.characters)[index]
    }
    
    let remainingCharacters = String(word.characters.suffix(length))
    for character in remainingCharacters.characters {
      currentNode.children["\(character)"] = Node(character: "\(character)", parent: currentNode)
      currentNode = currentNode.children["\(character)"]!
    }
    
    currentNode.isAWord = true
    wordList.append(word)
    wordCount += 1
    return (word, true)
  }
  
  /// Attempts to insert all words from input array. Returns a tuple containing the input array and true if some of the words were successfully added, false if none were added.
  ///
  /// - parameter words: An array of `String` objects.
  ///
  /// - returns: A tuple stating whether all the words were inserted.
  func insert(words: [String]) -> (wordList: [String], inserted: Bool) {
    var successful: Bool = false
    for word in wordList {
      successful = insert(word: word).inserted || successful
    }
    
    return (wordList, successful)
  }
  
  /// Removes the specified key from the `Trie` if it exists, returns tuple containing the word attempted to be removed and true/false if the removal was successful.
  ///
  /// - parameter word: A `String` to be removed.
  ///
  /// - returns: A tuple containing the word to be removed, and a `Bool` indicating whether removal was successful or not.
  @discardableResult func remove(word: String) -> (word: String, removed: Bool) {
    let word = word.lowercased()
    
    guard contains(word: word) else { return (word, false) }
    var currentNode = root
    
    for character in word.characters {
      currentNode = currentNode.getChildAt(character: "\(character)")
    }
    
    if currentNode.children.count > 0 {
      currentNode.isAWord = false
    } else {
      var character = currentNode.character
      while currentNode.children.count == 0 && !currentNode.isRoot {
        currentNode = currentNode.parent!
        currentNode.children[character]!.parent = nil
        character = currentNode.character
      }
    }
    
    wordCount -= 1
    
    var index = 0
    for item in wordList {
      if item == word {
        wordList.remove(at: index)
      }
      index += 1
    }
    
    return (word, true)
  }
  
  func find(prefix: String) -> [String] {
    guard isPrefix(prefix).found else { return [] }
    var queue = Queue<Node>()
    let node = isPrefix(prefix).node!
    
    var wordsWithPrefix: [String] = []
    let word = prefix
    var tmp = ""
    queue.enqueue(element: node)
    
    while let current = queue.dequeue() {
      for (_, child) in current.children {
        if !child.visited {
          queue.enqueue(element: child)
          child.visited = true
          if child.isValidWord {
            var currentNode = child
            while currentNode !== node {
              tmp += currentNode.character
              currentNode = currentNode.parent!
            }
            tmp = "\(tmp.characters.reversed())"
            wordsWithPrefix.append(word + tmp)
            tmp = ""
          }
        }
      }
    }
    
    return wordsWithPrefix
  }
  
  func removeAll() {
    for word in wordList {
      remove(word: word)
    }
  }
}

extension Trie: CustomStringConvertible {
  public var description: String {
    return ""
  }
}
