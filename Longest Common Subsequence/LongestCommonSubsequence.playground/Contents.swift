extension String {
  public func longestCommonSubsequence(other: String) -> String {

    func lcsLength(other: String) -> [[Int]] {
      var matrix = [[Int]](count: self.characters.count+1, repeatedValue: [Int](count: other.characters.count+1, repeatedValue: 0))

      for (i, selfChar) in self.characters.enumerate() {
        for (j, otherChar) in other.characters.enumerate() {
          if otherChar == selfChar {
            matrix[i+1][j+1] = matrix[i][j] + 1
          } else {
            matrix[i+1][j+1] = max(matrix[i][j+1], matrix[i+1][j])
          }
        }
      }
      return matrix
    }

    func backtrack(matrix: [[Int]]) -> String {
      var i = self.characters.count
      var j = other.characters.count
      var charInSequence = self.endIndex

      var lcs = String()

      while i >= 1 && j >= 1 {
        if matrix[i][j] == matrix[i][j - 1] {
          j -= 1
        } else if matrix[i][j] == matrix[i - 1][j] {
          i -= 1
          charInSequence = charInSequence.predecessor()
        } else {
          i -= 1
          j -= 1
          charInSequence = charInSequence.predecessor()
          lcs.append(self[charInSequence])
        }
      }
      return String(lcs.characters.reverse())
    }

    return backtrack(lcsLength(other))
  }
}

// Examples

let a = "ABCBX"
let b = "ABDCAB"
let c = "KLMK"

a.longestCommonSubsequence(c)   // ""
a.longestCommonSubsequence("")  // ""
a.longestCommonSubsequence(b)   // "ABCB"
b.longestCommonSubsequence(a)   // "ABCB"
a.longestCommonSubsequence(a)   // "ABCBX"

"Hello World".longestCommonSubsequence("Bonjour le monde")
