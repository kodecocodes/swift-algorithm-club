# Rabin–Karp

```swift
extension String {
  func indexOf(pattern: String) -> String.Index? {

    let patternLength = pattern.characters.count
    assert(patternLength > 0)
    assert(patternLength <= characters.count)

    for index in 0...characters.count - patternLength {
      let currentIndex = self.startIndex.advancedBy(index)
      let currentSubstring = substringWithRange(currentIndex ..< startIndex.advancedBy(index + patternLength))

      let currentHash = currentSubstring.hashValue

      if currentHash == pattern.hashValue {
        if currentSubstring == pattern {
          return currentIndex
        }
      }
    }
    return nil
  }
}

let data = "the quick brown fox jumps over the lazy dog".indexOf("fox")
```

TODO: Implement rolling hash + lint
