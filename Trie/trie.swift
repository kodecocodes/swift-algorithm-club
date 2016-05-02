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
      let op = self.insert(word)
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

    print("I make it here " + w)
    if currentNode.numChildren() > 0 {
      //print("Hello?")
      currentNode.isNotWord()
    } else {
      var character = currentNode.char()
      var i = 0
      while(currentNode.numChildren() == 0 && !currentNode.isRoot()) {
        print("Do I die here?")
        print(currentNode.getParent().char())
        i+=1
        currentNode = currentNode.getParent()
        currentNode.children[character]!.setParent(nil)
        currentNode.children[character]!.update(nil)
        currentNode.children[character] = nil
        character = currentNode.char()
        print(i)
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

  private func getChildrenWithPrefix(node: Node, var word: String, var words: [String]) -> [String] {

    print(word)

    if node.isLeaf() && node.isValidWord() {
      words.append(word)
      print(words)

    } else {

      for (child, n) in node.getChildren(){
        print(child)
        word += child
        getChildrenWithPrefix(n, word: word, words: words)
      }
    }

    return words
  }

  func findPrefix(p: String) -> [String] {
    print("Entered")


    //var (node, pFound: Bool) = self.isPrefix(p)
    if self.isPrefix(p).found {
      print("I found the prefix!")
      return getChildrenWithPrefix(self.isPrefix(p).node!, word: p.lowercaseString, words: [])
    }

    return ["HE"]
  }


  func removeAll() -> Void {
    for word in wordList {
      self.remove(word)
    }
    self.root.update(nil)
  }


  func printTrie() {
    self.root.printNode("", leaf: true)
  }

}

print("tests")

/*var x: Node = Node(c: "c")
print(x.char())
print(x.isValidWord())
x.isWord()
print(x.isValidWord())*/


var T: Trie = Trie()
T.insert("Hello")
T.insert("Hi")
T.insert("Hey")
T.insert("Hallo")
T.insert("Henry")
var U: Trie = Trie(wordList: Set(["Hey", "HO", "hello", "yolo"]))
var V: Trie = T.merge(U)
//T.printTrie()
//U.printTrie()
//V.printTrie()
print(V.getWords())
V.removeAll()
//V.printTrie()
/*T.insert("Hello")
T.insert("Hey")
T.insert("YOLO")
T.insert("Him")
assert(T.count() == 4, "Count function failed")
assert(T.contains("Hey") == true)
assert(T.contains("Hello") == true)
print("trying remove")
T.remove("Him")
assert(T.count() == 3)
assert(T.contains("Him") == false, "Test failed")
assert(T.wordList.count == 3)*/

//T.printTrie()
//print(T.find(""))
//print(T.findPrefix("H"))
