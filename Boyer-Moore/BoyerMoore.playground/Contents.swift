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

    var i = self.startIndex.advancedBy(patternLength - 1)

    while i < self.endIndex {

      var p = pattern.endIndex.predecessor()

      while p >= pattern.startIndex {
        let c = self[i]

        if c != pattern[p] {
          i = i.advancedBy(skipTable[c] ?? patternLength, limit: self.endIndex)
          break
        }

        if p == pattern.startIndex {
          return i
        }

        i = i.predecessor()
        p = p.predecessor()
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
