public class Node {
  var character: String?
  var parent: Node?
  var children: [Node?]
  var isAWord: Bool = false

  init(c: String){
    self.character = c
    self.children = [Node?]()
    }

  //Easier getter function, probably will make it more swift like
  func char() -> String {
    return self.character!
  }

  func changeChar(c: String) -> Void {
    self.character = c
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
}

public class Trie {
  var root: Node = Node(c: "")



}

print("tests")

var x: Node = Node(c: "c")
print(x.char())
print(x.isValidWord())
x.isWord()
print(x.isValidWord())
