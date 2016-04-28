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

}

public class Trie {
  private var root: Node
  private var wordList: [String]
  private var wordCount = 0

  init() {
    self.root = Node(c: "", p: nil)
    self.wordList = []
  }

  func find(key: String) -> (key: String, found: Bool) {
    var currentNode = self.root

    for c in key.characters {
      if currentNode.children[String(c)] == nil {
        return(key, false)
      }
      currentNode = currentNode.children[String(c)]!
    }

    return(key, currentNode.isValidWord())
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

  func isPrefix(w: String) -> Bool {
    return true
  }

  func insert(w: String) -> (word: String, inserted: Bool) {

    let word = w.lowercaseString
    var currentNode = self.root
    var length = word.characters.count

    if self.contains(word) {
      return (w, false)
    }

    for c in word.characters {
      if currentNode.children[String(c)] != nil {
        currentNode = currentNode.children[String(c)]!
        length -= 1
      }
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
    var currentNode = self.root

    if(!self.contains(w)) {
      return (w, false)
    }

    for c in word.characters {
      if currentNode.children[String(c)] != nil {
        currentNode = currentNode.children[String(c)]!
      }
    }
    var x = currentNode.char()
    while currentNode.getParent().numChildren() == 1 {
      currentNode = currentNode.getParent()
      currentNode.children[x]!.setParent(nil)
      currentNode.children[x] = nil
      x = currentNode.char()
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



}

print("tests")

/*var x: Node = Node(c: "c")
print(x.char())
print(x.isValidWord())
x.isWord()
print(x.isValidWord())*/


var T: Trie = Trie()
T.insert("Hello")
T.insert("Hey")
T.insert("YOLO")
T.insert("Him")
assert(T.count() == 4, "Count function failed")
assert(T.contains("Hey") == true)
assert(T.contains("Hello")==true)
print("trying remove")
T.remove("Him")
assert(T.count() == 3)
assert(T.contains("Him") == false, "Test failed")
assert(T.wordList.count == 3)
