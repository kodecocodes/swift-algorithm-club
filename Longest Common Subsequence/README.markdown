# Longest Common Subsequence


The Longest Common Subsequence (LCS) of two strings is the longest sequence of characters that appear in the same order in both strings. Should not be confused with the Longest Common Substring problem, where characters **must** be a substring of both strings (i.e they have to be immediate neighbours).

One way to find what's the LCS of two strings `a` and `b` is using Dynamic Programming and a backtracking strategy. During the explanation, remember that `n` is the length of `a` and `m` the length of `b`.

## Length of LCS - Dynamic Programming 

Dynamic programming is used to determine the length of LCS between all combinations of substrings of `a` and `b`. 


```swift
        // Computes the length of the lcs using dynamic programming
        // Output is a matrix of size (n+1)x(m+1), where matrix[x][y] indicates the length
        // of lcs between substring (0, x-1) of self and substring (0, y-1) of other.
        func lcsLength(other: String) -> [[Int]] {
            
            //Matrix of size (n+1)x(m+1), algorithm needs first row and first line to be filled with 0
            var matrix = [[Int]](count:self.characters.count+1, repeatedValue:[Int](count:other.characters.count+1, repeatedValue:0))
            
            for (i, selfChar) in self.characters.enumerate() {
                for (j, otherChar) in other.characters.enumerate() {
                    if (otherChar == selfChar) {
                        //Common char found, add 1 to highest lcs found so far
                        matrix[i+1][j+1] = (matrix[i][j]) + 1
                    }
                    else {
                        //Not a match, propagates highest lcs length found so far
                        matrix[i+1][j+1] = max(matrix[i][j+1], matrix[i+1][j])
                    }
                }
            }
            
            //Due to propagation, lcs length is at matrix[n][m]
            return matrix;
        }
```

Given strings `"ABCBX"` and `"ABDCAB"` the output matrix of `lcsLength` is the following:

*First row and column added for easier understanding, actual matrix starts on zeros*

```
|   | Ø | A | B | D | C | A | B |
| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |  
| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
| C | 0 | 1 | 2 | 2 | 3 | 3 | 3 |
| B | 0 | 1 | 2 | 2 | 3 | 3 | 4 |
| X | 0 | 1 | 2 | 2 | 3 | 3 | 4 |
```

The content of the matrix indicates that position `(i, j)` contains the length of the LCS between substring `(0, i - 1)` of `a` and substring `(0, j - 1)` of `b`.

Example: `(2, 3)` says that the LCS for `"AB"` and `"ABD"` is 2


## Actual LCS - Backtrack

Having the length of every combination makes it possible to determine *which* characters are part of the LCS itself by using a backtracking strategy.

Backtrack starts at matrix[n + 1][m + 1] and *walks* up and left (in this priority) looking for changes that do not indicate a simple propagation. If the number on the left and above are different than the number in the current cell, no propagation happened, it means that `(i, j)` indicates a common char between `a` and `b`, so char at `a[i - 1]` and `b[j - 1]` are part of the LCS and should be stored in the returned value (`self[i - 1]` was used in the code but could be `other[j - 1]`).

```
|   |  Ø|  A|  B|  D|  C|  A|  B|
| Ø |  0|  0|  0|  0|  0|  0|  0|
| A |  0|↖ 1|  1|  1|  1|  1|  1|  
| B |  0|  1|↖ 2|← 2|  2|  2|  2|
| C |  0|  1|  2|  2|↖ 3|← 3|  3|
| B |  0|  1|  2|  2|  3|  3|↖ 4|
| X |  0|  1|  2|  2|  3|  3|↑ 4|
```
Each `↖` move indicates a character (in row/column header) that is part of the LCS.

One thing to notice is, as it's running backwards, the LCS is built in reverse order. Before returning, the result is reversed to reflect the actual LCS.



```swift
        //Backtracks from matrix[n][m] to matrix[1][1] looking for chars that are common to both strings
        func backtrack(matrix: [[Int]]) -> String {
            var i = self.characters.count
            var j = other.characters.count
            
            //charInSequence is in sync with i so we can get self[i]
            var charInSequence = self.endIndex
            
            var lcs = String()
            
            while (i >= 1 && j >= 1) {
                //Indicates propagation without change, i.e. no new char was added to lcs
                if (matrix[i][j] == matrix[i][j - 1]) {
                    j = j - 1
                }
                //Indicates propagation without change, i.e. no new char was added to lcs
                else if (matrix[i][j] == matrix[i - 1][j]) {
                    i = i - 1
                    //As i was subtracted, move back charInSequence
                    charInSequence = charInSequence.predecessor()
                }
                //Value on the left and above are different than current cell. This means 1 was added to lcs length (line 16)
                else {
                    i = i - 1
                    j = j - 1
                    charInSequence = charInSequence.predecessor()
                    
                    lcs.append(self[charInSequence])
                }
            }
            
            //Due to backtrack, chars were added in reverse order: reverse it back.
            //Append and reverse is faster than inserting at index 0
            return String(lcs.characters.reverse());
        }

```  




## Putting it all together


```swift
extension String {
    func longestCommonSubsequence(other:String) -> String {
        
        // Computes the same of the lcs using dynamic programming
        // Output is a matrix of size (n+1)x(m+1), where matrix[x][y] indicates the length
        // of lcs between substring (0, x-1) of self and substring (0, y-1) of other.
        func lcsLength(other: String) -> [[Int]] {
            
            //Matrix of size (n+1)x(m+1), algorithm needs first row and first line to be filled with 0
            var matrix = [[Int]](count:self.characters.count+1, repeatedValue:[Int](count:other.characters.count+1, repeatedValue:0))
            
            for (i, selfChar) in self.characters.enumerate() {
                for (j, otherChar) in other.characters.enumerate() {
                    if (otherChar == selfChar) {
                        //Common char found, add 1 to highest lcs found so far
                        matrix[i+1][j+1] = (matrix[i][j]) + 1
                    }
                    else {
                        //Not a match, propagates highest lcs length found so far
                        matrix[i+1][j+1] = max(matrix[i][j+1], matrix[i+1][j])
                    }
                }
            }
            
            //Due to propagation, lcs length is at matrix[n][m]
            return matrix;
        }
        
        //Backtracks from matrix[n][m] to matrix[1][1] looking for chars that are common to both strings
        func backtrack(matrix: [[Int]]) -> String {
            var i = self.characters.count
            var j = other.characters.count
            
            //charInSequence is in sync with i so we can get self[i]
            var charInSequence = self.endIndex
            
            var lcs = String()
            
            while (i >= 1 && j >= 1) {
                //Indicates propagation without change, i.e. no new char was added to lcs
                if (matrix[i][j] == matrix[i][j - 1]) {
                    j = j - 1
                }
                //Indicates propagation without change, i.e. no new char was added to lcs
                else if (matrix[i][j] == matrix[i - 1][j]) {
                    i = i - 1
                    //As i was subtracted, move back charInSequence
                    charInSequence = charInSequence.predecessor()
                }
                //Value on the left and above are different than current cell. This means 1 was added to lcs length (line 16)
                else {
                    i = i - 1
                    j = j - 1
                    charInSequence = charInSequence.predecessor()
                    
                    lcs.append(self[charInSequence])
                }
            }
            
            //Due to backtrack, chars were added in reverse order: reverse it back.
            //Append and reverse is faster than inserting at index 0
            return String(lcs.characters.reverse());
        }
        
        //Combine dynamic programming approach with backtrack to find the lcs
        return backtrack(lcsLength(other))
    }
}
```

**Examples:**

```swift
let a = "ABCBX"
let b = "ABDCAB"
let c = "KLMK"

a.longestCommonSubsequence(c) //""
a.longestCommonSubsequence("") //""
a.longestCommonSubsequence(b) //"ABCB"
b.longestCommonSubsequence(a) //"ABCB"
a.longestCommonSubsequence(a) // "ABCBX"
```


*Written for Swift Algorithm Club by Pedro Vereza*