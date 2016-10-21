extension String {
  public func longestCommonSubsequence(_ other: String) -> String {

    // Computes the length of the lcs using dynamic programming.
    // Output is a matrix of size (n+1)x(m+1), where matrix[x][y] is the length
    // of lcs between substring (0, x-1) of self and substring (0, y-1) of other.
    func lcsLength(_ other: String) -> [[Int]] {

      // Create matrix of size (n+1)x(m+1). The algorithm needs first row and
      // first column to be filled with 0.
      var matrix = [[Int]](repeating: [Int](repeating: 0, count: other.characters.count+1), count: self.characters.count+1)

      for (i, selfChar) in self.characters.enumerated() {
        for (j, otherChar) in other.characters.enumerated() {
          if otherChar == selfChar {
            // Common char found, add 1 to highest lcs found so far.
            matrix[i+1][j+1] = matrix[i][j] + 1
          } else {
            // Not a match, propagates highest lcs length found so far.
            matrix[i+1][j+1] = max(matrix[i][j+1], matrix[i+1][j])
          }
        }
      }

      // Due to propagation, lcs length is at matrix[n][m].
      return matrix
    }

    // Backtracks from matrix[n][m] to matrix[1][1] looking for chars that are
    // common to both strings.
    func backtrack(_ matrix: [[Int]]) -> String {
      var i = self.characters.count
      var j = other.characters.count

      // charInSequence is in sync with i so we can get self[i]
      var charInSequence = self.endIndex

      var lcs = String()

      while i >= 1 && j >= 1 {
        // Indicates propagation without change: no new char was added to lcs.
        if matrix[i][j] == matrix[i][j - 1] {
          j -= 1
        }
        // Indicates propagation without change: no new char was added to lcs.
        else if matrix[i][j] == matrix[i - 1][j] {
          i -= 1
          // As i was decremented, move back charInSequence.
          charInSequence = self.index(before: charInSequence)
        }
        // Value on the left and above are different than current cell.
        // This means 1 was added to lcs length (line 17).
        else {
          i -= 1
          j -= 1
            charInSequence = self.index(before: charInSequence)

          lcs.append(self[charInSequence])
        }
      }

      // Due to backtrack, chars were added in reverse order: reverse it back.
      // Append and reverse is faster than inserting at index 0.
      return String(lcs.characters.reversed())
    }

    // Combine dynamic programming approach with backtrack to find the lcs.
    return backtrack(lcsLength(other))
  }
}
