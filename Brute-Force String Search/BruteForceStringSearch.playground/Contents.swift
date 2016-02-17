//: Playground - noun: a place where people can play

extension String {
  func indexOf(pattern: String) -> String.Index? {
    for i in self.startIndex ..< self.endIndex {
      var j = i
      var found = true
      for p in pattern.startIndex ..< pattern.endIndex {
        if j == self.endIndex || self[j] != pattern[p] {
          found = false
          break
        } else {
          j = j.successor()
        }
      }
      if found {
        return i
      }
    }
    return nil
  }
}



// A few simple tests

let s = "Hello, World"
s.indexOf("World")  // 7

let animals = "🐶🐔🐷🐮🐱"
animals.indexOf("🐮")  // 6
