//: Playground - noun: a place where people can play

extension String {
  func indexOf(pattern: String) -> String.Index? {
    let patternLength = pattern.characters.count
    assert(patternLength > 0)
    assert(patternLength <= self.characters.count)

    var skipTable = [Character: Int]()
    for (i, c) in pattern.characters.enumerated() {
      skipTable[c] = patternLength - i - 1
    }

    let p = pattern.index(before: pattern.endIndex)
    let lastChar = pattern[p]
    var i = self.index(startIndex, offsetBy: patternLength - 1)

    func backwards() -> String.Index? {
      var q = p
      var j = i
      while q > pattern.startIndex {
        j = index(before: j)
        q = index(before: q)
        if self[j] != pattern[q] { return nil }
      }
      return j
    }

    while i < self.endIndex {
      let c = self[i]
      if c == lastChar {
        if let k = backwards() { return k }
        i = index(after: i)
      } else {
        i = index(i, offsetBy: skipTable[c] ?? patternLength)
      }
    }
    return nil
  }
}

// A few simple tests

let s = "Hello, World"
s.indexOf(pattern: "World")  // 7

let animals = "🐶🐔🐷🐮🐱"
animals.indexOf(pattern: "🐮")  // 6
