public class Node {
  var character: Character?
  var parent: Node?
  var children: [Node?]
  var isAWord: Bool = false

  init(c: Character){
    self.character = c
    self.children = [Node?]()
    }

  //Easier getter function, probably will make it more swift like
  func char() -> Character {
    return self.character!
  }

  func changeChar(c: Character) -> Void {
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



print("tests")

var x: Node = Node(c: "c")
print(x.char())
print(x.isValidWord())
x.isWord()
print(x.isValidWord())
