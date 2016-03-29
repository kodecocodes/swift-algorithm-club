/*
  Boyer-Moore string search

  This code is based on the article "Faster String Searches" by Costas Menico
  from Dr Dobb's magazine, July 1989.
  http://www.drdobbs.com/database/faster-string-searches/184408171
*/
extension String {
  func indexOf(pattern: String) -> String.Index? {
    // Cache the length of the search pattern because we're going to
    // use it a few times and it's expensive to calculate.
    let patternLength = pattern.characters.count
    assert(patternLength > 0)
    assert(patternLength <= self.characters.count)

    // Make the skip table. This table determines how far we skip ahead
    // when a character from the pattern is found.
    var skipTable = [Character: Int]()
    for (i, c) in pattern.characters.enumerate() {
      skipTable[c] = patternLength - i - 1
    }

    // The pattern is scanned right-to-left, so skip ahead in the string by
    // the length of the pattern. (Minus 1 because startIndex already points
    // at the first character in the source string.)
    var i = self.startIndex.advancedBy(patternLength - 1)

    // The main loop. Keep going until the end of the string is reached.
    while i < self.endIndex {

      // This points at the last character in the pattern.
      var p = pattern.endIndex.predecessor()

      while p >= pattern.startIndex {
        let c = self[i]

        if c != pattern[p] {
          // The characters are not equal, so skip ahead. The amount to skip is
          // determined by the skip table. If the character is not present in the
          // pattern, we can skip ahead by the full pattern length. However, if
          // the character *is* present in the pattern, there may be a match up
          // ahead and we can't skip as far.
          i = i.advancedBy(skipTable[c] ?? patternLength)
          break
        }

        if p == pattern.startIndex {
          // All patterns matched.
          return i
        }

        i = i.predecessor()
        p = p.predecessor()
      }
    }

    return nil
  }
}
