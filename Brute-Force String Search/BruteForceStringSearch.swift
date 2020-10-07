/*
  Brute-force string search
*/
extension String {
    /// Searches the string for the pattern provided, returning the index of ocurrency. This algorithm uses a brute force approach.
    /// - Parameter pattern: The stering patter to be searched.
    /// - Returns: where the pattern starts to occur.
  func indexOf(_ pattern: String) -> String.Index? {
    for i in self.characters.indices {
        var j = i
        var found = true
        for p in pattern.characters.indices {
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
