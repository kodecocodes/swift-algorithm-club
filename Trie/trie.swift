public class Node {
  var character: String?
  var parent: Node?
  var children: [String:Node]
  var isAWord: Bool

  init(c: String){
    self.character = c
    self.children = [String:Node]()
    self.isAWord = false
    }

  //Easier getter function, probably will make it more swift like
  func char() -> String {
    return self.character!
  }

  func changeChar(c: String) -> Void {
    self.character = c
  }

  func isLeaf() -> Bool{
    return self.children.count == 0
  }
  //For Testing purposes
  func getParent() -> Node {
    return parent!
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
}

public class Trie {
  var root = Node(c: "")
  var nodes: [Node]
  var wordList: [String]
  var wordCount = 0

  init() {
    self.root = Node(c: "")
    self.nodes = []
    self.nodes.append(self.root)
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

  func insert(w: String) -> (word: String, inserted: Bool) {

    var currentNode = self.root
    var length = w.characters.count

    for c in w.characters {
      if currentNode.children[String(c)] != nil {
        currentNode = currentNode.children[String(c)]!
        length -= 1
      }
    }

    if length == 0 {
      if(currentNode.isValidWord()) {
        return (w, false)
      }

      currentNode.isWord()
      wordList.append(w)
      wordCount += 1
      return (w, true)
    }

    let choppedWord = String(w.characters.suffix(length))

    for c in choppedWord.characters {
      currentNode.children[String(c)] = Node(c: String(c))
      currentNode = currentNode.children[String(c)]!
    }

    currentNode.isWord()
    wordList.append(w)
    wordCount += 1
    return (w, true)
  }

  func remove(w: String) -> (word: String, removed: Bool){
    var currentNode = self.root

    for c in w.characters {
      if(currentNode.children[String(c)]) == nil{
        return (w, false)
      }

      currentNode = currentNode.children[String(c)]!

    }

    return (w, false)


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
    return find(w).found
  }

  func isPrefix(w: String) -> Bool {
    return true
  }

  func findPrefix(w: String) -> (key: String, found: Bool) {
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
print(T.insert("Hello"))
print(T.find("Hello"))
