/// TODO: - Undergoing refactoring.

/*
  Queue implementation (taken from repository, needed for findPrefix())
*/
public struct Queue<T> {
  private var array = [T?]()
  private var head = 0

  public var isEmpty: Bool {
    return count == 0
  }

  public var count: Int {
    return array.count - head
  }

  public mutating func enqueue(element: T) {
    array.append(element)
  }

  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    let percentage = Double(head)/Double(array.count)
    if array.count > 50 && percentage > 0.25 {
      array.removeFirst(head)
      head = 0
    }

    return element
  }
}
/*
  A Trie (Pre-fix Tree)

  Some of the functionality of the trie makes use of the Queue implementation for this project.


  Every node in the Trie stores a bit of information pertainining to what it references:
    -Character (letter of an inserted word)
    -Parent  (Letter that comes before the current letter in some word)
    -Children (Words that have more letters than available in the prefix)
    -isAWord (Does the current letter mark the end of a known inserted word?)
    -visited (Mainly for the findPrefix() function)
*/
public class Node {
  private var character: String?
  private var parent: Node?
  private var children: [String:Node]
  private var isAWord: Bool
  private var visited: Bool  //only for findPrefix

  init(c: String?, p: Node?) {
    self.character = c
    self.children = [String:Node]()
    self.isAWord = false
    self.parent = p
    self.visited = false
    }

  /*
    Function Name:  char()
    Input:  N/A
    Output:  String
    Functionality: Returns the associated value of the node
  */
  func char() -> String {
    return self.character!
  }

  /*
    Function Name:  update
    Input: String
    Output: N/A
    Functionality: Updates the associated value of the node
  */
  func update(c: String?) {
    self.character = c
  }

  /*
    Function Name:  isLeaf
    Input:  N/A
    Output:  Bool
    Functionality: Returns true if the node is a leaf node, false otherwise
  */
  func isLeaf() -> Bool {
    return self.children.count == 0
  }

  /*
    Function Name:  getParent
    Input:  N/A
    Output:  Node
    Functionality: Returns the parent node of the current node
  */
  func getParent() -> Node {
    return parent!
  }

  /*
    Function Name:  setParent
    Input:  Node
    Output:  N/A
    Functionality: Changes the parent of the current node to the passed node
  */

  func setParent(node: Node?) {
    self.parent = node
  }

  /*
    Function Name:  getChildAt
    Input:  String
    Output:  Node
    Functionality:  returns the child node that holds the specific passed letter
  */
  func getChildAt(s: String) -> Node {
    return self.children[s]!
  }

  /*
    Function Name:  isValidWord
    Input:  N/A
    Output:  Bool
    Functionality: Returns whether or not the current node marks the end of a valid word
  */
  func isValidWord() -> Bool {
    return self.isAWord
  }

  /*
    Function Name:  isWord
    Input:  N/A
    Output:  N/A
    Functionality:  the current node is indeed a word
  */
  func isWord() {
    self.isAWord = true
  }

  /*
    Function Name: isNotWord
    Input:  N/A
    Output:  N/A
    Functionality:  marks the current node as not a word
  */
  func isNotWord() {
    self.isAWord = false
  }

  /*
    Function Name:  isRoot
    Input: N/A
    Output: Bool
    Functionality:  Returns whether or not the current node is the root of the trie
  */
  func isRoot() -> Bool {
    return self.character == ""
  }

  /*
    Function Name:  numChildren
    Input:  N/A
    Output:  Int
    Functionality:  Returns the number of immediate letters that follow the current node
  */
  func numChildren() -> Int {
    return self.children.count
  }

  /*
    Function Name:  getChildren
    Input:  N/A
    Output:  [String: Node]
    Functionality:  Returns the letters that immediately follow the current node's value for possible word segments that follow
  */
  func getChildren() -> [String: Node] {
    return self.children
  }


  /*
    Function Name:  printNode
    Input:  String, Bool
    Output:  N/A
    Functionality:  prints to the console a string representation of the current node in the trie
  */
  func printNode(var indent: String, leaf: Bool) {

    print(indent, terminator: "")
    if leaf {
      print("\\-", terminator: "")
      indent += " "
    } else {
      print("|-", terminator: "")
      indent += "| "
    }

    print(self.char())

    var i = 0
    for (_, node) in self.children {
      node.printNode(indent, leaf: i == self.getChildren().count-1)
      i+=1
    }

  }

}


/*
  The Trie class has the following attributes:
    -root (the root of the trie)
    -wordList (the words that currently exist in the trie)
    -wordCount (the number of words in the trie)
*/
public class Trie {
  private var root: Node
  private var wordList: [String]
  private var wordCount = 0

  init() {
    self.root = Node(c: "", p: nil)
    self.wordList = []
  }

  init(wordList: Set<String>) {

    self.root = Node(c: "", p: nil)
    self.wordList = []

    for word in wordList {
      self.insert(word)
    }
  }

  /*
    Function Name: merge
    Input:  Trie
    Output:  Trie
    Functionality:  Merges two tries into one and returns the merged trie
  */
  func merge(other: Trie) -> Trie {
    let newWordList = Set(self.getWords() + other.getWords())
    return Trie(wordList: newWordList)
  }

  /*
    Function Name:  find
    Input:  String
    Output:  (Node?, Bool)
    Functionality:  Looks for a specific key and returns a tuple that
                    has a reference to the node(if found) and true/false
                    depending on if it was found
  */
  func find(key: String) -> (node: Node?, found: Bool) {
    var currentNode = self.root

    for c in key.characters {
      if currentNode.children[String(c)] == nil {
        return(nil, false)
      }
      currentNode = currentNode.children[String(c)]!
    }

    return(currentNode, currentNode.isValidWord())
  }

  /*
    Function Name: isEmpty
    Input:  N/A
    Output:  Bool
    Functionality:  returns true if the trie is empty, false otherwise
  */
  func isEmpty() -> Bool {
    return wordCount == 0
  }

  /*
    Function Name:  count
    Input:  N/A
    Output:  Int
    Functionality:  returns the number of words in the trie
  */
  func count() -> Int {
    return wordCount
  }

  /*
    Function Name:  getWords
    Input:  N/A
    Output:  [String]
    Functionality:  returns the list of words that exist in the trie
  */
  func getWords() -> [String] {
    return wordList
  }

  /*
    Function Name:  contains
    Input:  String
    Output:  Bool
    Functionality:  returns true if the tries has the word passed, false otherwise
  */
  func contains(w: String) -> Bool {
    return find(w.lowercaseString).found
  }

  /*
    Function Name:  isPrefix
    Input:  String
    Output: (Node?, Bool)
    Functionality:  returns a tuple containing a reference to the final
                    node in the prefix (if it exists) and true/false
                    depending on whether or not the prefix exists in the trie
  */
  func isPrefix(p: String) -> (node: Node?, found: Bool) {
    let prefixP = p.lowercaseString

    var currentNode = self.root

    for c in prefixP.characters {
      if currentNode.children[String(c)] == nil {
        return (nil, false)
      }

      currentNode = currentNode.children[String(c)]!
    }

    if currentNode.numChildren() > 0 {
      return (currentNode, true)
    }

    return (nil, false)
  }

  /*
    Function Name:  insert
    Input:  String
    Output:  (String, Bool)
    Functionality:  Inserts a word int othe trie.  Returns a tuple containing
                    the word attempted to be added, and true/false depending on
                    whether or not the insertion was successful
  */
  func insert(w: String) -> (word: String, inserted: Bool) {

    let word = w.lowercaseString
    var currentNode = self.root
    var length = word.characters.count

    if self.contains(word) {
      return (w, false)
    }

    var index = 0
    var c = Array(word.characters)[index]

    while let child = currentNode.children[String(c)] {
      currentNode = child
      length -= 1
      index += 1

      if length == 0 {
        currentNode.isWord()
        wordList.append(w)
        wordCount += 1
        return (w, true)
      }

      c = Array(word.characters)[index]
    }

    let remainingChars = String(word.characters.suffix(length))
    for c in remainingChars.characters {
      currentNode.children[String(c)] = Node(c: String(c), p: currentNode)
      currentNode = currentNode.children[String(c)]!
    }

    currentNode.isWord()
    wordList.append(w)
    wordCount += 1
    return (w, true)
  }

  /*
    Function Name:  insertWords
    Input:  [String]
    Output:  ([String], Bool)
    Functionality:  attempts to insert all words from input array.  returns a tuple
                    containing the input array and true if some of the words were
                    succesffuly added, false if none were added
  */

  func insertWords(wordList: [String]) -> (wordList: [String], inserted: Bool) {

    var succesful: Bool = false
    for word in wordList {
      succesful = self.insert(word).inserted || succesful
    }

    return(wordList, succesful)
  }

  /*
    Function Name:  remove
    Input:  String
    Output:  (String, Bool)
    Functionality:  Removes the specified key from the trie if it exists, returns
                    tuple containing the word attempted to be removed and true/false
                    if the removal was succesful
  */
  func remove(w: String) -> (word: String, removed: Bool) {
    let word = w.lowercaseString

    if !self.contains(w) {
      return (w, false)
    }
    var currentNode = self.root

    for c in word.characters {
      currentNode = currentNode.getChildAt(String(c))
    }

    if currentNode.numChildren() > 0 {
      currentNode.isNotWord()
    } else {
      var character = currentNode.char()
      while currentNode.numChildren() == 0 && !currentNode.isRoot() {
        currentNode = currentNode.getParent()
        currentNode.children[character]!.setParent(nil)
        currentNode.children[character]!.update(nil)
        currentNode.children[character] = nil
        character = currentNode.char()
      }
    }

    wordCount -= 1

    var index = 0
    for item in wordList {
      if item == w {
        wordList.removeAtIndex(index)
      }
      index += 1
    }

    return (w, true)
  }

  /*
    Function Name: findPrefix
    Input:  String
    Output:  [String]
    Functionality:  returns a list containing all words in the trie that have the specified prefix
  */
  func findPrefix(p: String) -> [String] {

    if !self.isPrefix(p).found {
      return []
    }

    var q: Queue = Queue<Node>()
    var n: Node = self.isPrefix(p).node!

    var wordsWithPrefix: [String] = []
    var word = p
    var tmp = ""
    q.enqueue(n)

    while let current = q.dequeue() {
      for (char, child) in current.getChildren() {
        if !child.visited {
          q.enqueue(child)
          child.visited = true
          if child.isValidWord() {
            var currentNode = child
            while currentNode !== n {
              tmp += currentNode.char()
              currentNode = currentNode.getParent()
            }
            tmp = String(tmp.characters.reverse())
            wordsWithPrefix.append(word + tmp)
            tmp = ""
          }
        }
      }
    }


    return wordsWithPrefix
  }


  /*
    Function Name:  removeAll
    Input:  N/A
    Output:  N/A
    Functionality:  removes all nodes in the trie using remove as a subroutine
  */
  func removeAll() {
    for word in wordList {
      self.remove(word)
    }
  }


  /*
    Function Name:  printTrie
    Input:  N/A
    Output:  N/A
    Functionality:  prints all the nodes of the trie to console in a nice and easy to understand format
  */
  func printTrie() {
    self.root.printNode("", leaf: true)
  }

}
