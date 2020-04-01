/*  Knuth-Morris-Pratt algorithm for pattern/string matching
 
 The code is based on the book:
 "Algorithms on String, Trees and Sequences: Computer Science and Computational Biology"
 by Dan Gusfield
 Cambridge University Press, 1997
 */

import Foundation

func indents(_ pattern: [String.Element]) -> [Int]? {
  guard pattern.count > 0 else { return nil }
  let length = pattern.count
  
  var indents = Array(repeating: 0, count: length)
  var i = 1
  var j = 0
  
  while i < length {
    if pattern[i] == pattern[j] {
      indents[i] = j + 1
      i += 1
      j += 1
      
    } else if j == 0 {
      indents[i] = 0
      i += 1
      
    } else {
      j = indents[j - 1]
    }
  }
  
  return indents
}

extension String {
  
  func indices(of pattern: String) -> [Index] {
    let ptrn = Array(pattern)
    let str = Array(self)
    guard let indents = indents(ptrn) else { return [] }
    
    var indices = [Index]()
    var k = 0
    var l = 0
    
    while k < str.count {
      
      if str[k] == ptrn[l] {
        k += 1
        l += 1
        if l == ptrn.count {
          let index = self.index(startIndex, offsetBy: k - ptrn.count)
          indices.append(index)
          l = 0
        }
        
      } else if l == 0 {
        k += 1
      } else {
        l = indents[l - 1]
      }
    }
    
    return indices
  }
}
