/*  Z-Algorithm based algorithm for pattern/string matching
 
 The code is based on the book:
 "Algorithms on String, Trees and Sequences: Computer Science and Computational Biology"
 by Dan Gusfield
 Cambridge University Press, 1997
 */

import Foundation

extension String {

  func indexesOf(pattern: String) -> [Int]? {
    let patternLength = pattern.count
    let zeta = ZetaAlgorithm(ptrn: pattern + "💲" + self)

    guard zeta != nil else {
      return nil
    }

    var indexes: [Int] = [Int]()

    /* Scan the zeta array to find matched patterns */
    for i in 0 ..< zeta!.count {
      if zeta![i] == patternLength {
        indexes.append(i - patternLength - 1)
      }
    }

    guard !indexes.isEmpty else {
      return nil
    }

    return indexes
  }
}
