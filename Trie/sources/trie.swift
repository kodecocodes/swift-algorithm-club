public class Node {
  private var character: String?
  private var parent: Node?
  private var children: [String:Node]
  private var isAWord: Bool


  init(c: String?, p: Node?){
    self.character = c
    self.children = [String:Node]()
    self.isAWord = false
    self.parent = p
    }

  //Easier getter function, probably will make it more swift like
  func char() -> String {
    return self.character!
  }

  func update(c: String?) -> Void {
    self.character = c
  }

  func isLeaf() -> Bool{
    return self.children.count == 0
  }
  //For Testing purposes
  func getParent() -> Node {
    return parent!
  }

  func setParent(node: Node?) -> Void {
    self.parent = node
  }

  func getChildAt(s: String) -> Node {
    return self.children[s]!
  }
  //Is this node marked as the end of a word?
  func isValidWord() -> Bool{
    return self.isAWord
  }

  //Setters
  func isWord() -> Void {
    self.isAWord = true
  }

  func isNotWord() -> Void {
    self.isAWord = false
  }

  func isRoot() -> Bool {
    return self.character == ""
  }

  func numChildren() -> Int {
    return self.children.count
  }

  func getChildren() -> [String: Node] {
    return self.children
  }


  func printNode(var indent: String, leaf: Bool) -> Void {

    print(indent, terminator: "")
    if(leaf) {
      print("\\-", terminator: "")
      indent += " "
    }
    else {
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

  func merge(other: Trie) -> Trie{
    let newWordList = Set(self.getWords() + other.getWords())
    return Trie(wordList: newWordList)
  }

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

  func isEmpty() -> Bool {
    return wordCount == 0
  }

  func count() -> Int {
    return wordCount
  }

  func getWords() -> [String] {
    return wordList
  }

  func contains(w: String) -> Bool {
    return find(w.lowercaseString).found
  }

  func isPrefix(p: String) -> (node: Node?, found: Bool) {
    let prefixP = p.lowercaseString

    var currentNode = self.root

    for c in prefixP.characters {
      if currentNode.children[String(c)] == nil{
        return (nil, false)
      }

      currentNode = currentNode.children[String(c)]!
    }

    if currentNode.numChildren() > 0 {
      return (currentNode, true)
    }

    return (nil, false)
  }

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

  func remove(w: String) -> (word: String, removed: Bool){
    let word = w.lowercaseString

    if(!self.contains(w)) {
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
      while(currentNode.numChildren() == 0 && !currentNode.isRoot()) {
        currentNode = currentNode.getParent()
        currentNode.children[character]!.setParent(nil)
        currentNode.children[character]!.update(nil)
        currentNode.children[character] = nil
        character = currentNode.char()
      }
    }

    wordCount -= 1

    var index = 0
    for item in wordList{
      if item == w {
        wordList.removeAtIndex(index)
      }
      index += 1
    }

    return (w, true)
  }

  func findPrefix(p: String) -> [String] {

    var q: Queue = Queue<String>()
    return []
  }


  func removeAll()  {
    for word in wordList {
      self.remove(word)
    }
    self.root.update(nil)
  }


  func printTrie() {
    self.root.printNode("", leaf: true)
  }

}
