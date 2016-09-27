/*
  Brute-force string search
*/
extension String {
  func indexOf(_ pattern: String) -> String.Index? {
    for i in self.characters.indices {
        var j = i
        var found = true
        for p in pattern.characters.indices{
            if j == self.characters.endIndex || self[j] != pattern[p] {
                found = false
                break
            } else {
                j = self.characters.index(after: j)
            }
        }
        if found {
            return i
        }
    }
    return nil
  }
}
