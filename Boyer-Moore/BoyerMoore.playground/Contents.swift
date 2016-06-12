//: Playground - noun: a place where people can play

extension String {
  func indexOf(pattern: String) -> String.Index? {
    let patternLength = pattern.characters.count
    assert(patternLength > 0)
    assert(patternLength <= self.characters.count)

    var skipTable = [Character: Int]()
    for (i, c) in pattern.characters.enumerate() {
      skipTable[c] = patternLength - i - 1
    }

    let p = pattern.endIndex.predecessor()
    let lastChar = pattern[p]
    var i = self.startIndex.advancedBy(patternLength - 1)

    func backwards() -> String.Index? {
      var q = p
      var j = i
      while q > pattern.startIndex {
        j = j.predecessor()
        q = q.predecessor()
        if self[j] != pattern[q] { return nil }
      }
      return j
    }

    while i < self.endIndex {
      let c = self[i]
      if c == lastChar {
        if let k = backwards() { return k }
        i = i.successor()
      } else {
        i = i.advancedBy(skipTable[c] ?? patternLength)
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
