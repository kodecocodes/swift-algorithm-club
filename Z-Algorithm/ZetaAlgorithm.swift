/*  Z-Algorithm based algorithm for pattern/string matching

    The code is based on the book:
    "Algorithms on String, Trees and Sequences: Computer Science and Computational Biology"
    by Dan Gusfield
    Cambridge University Press, 1997
*/

import Foundation

extension String {

    func indexesOf(pattern: String) -> [Int]? {
        let patternLength: Int = pattern.characters.count
        let zeta = ZetaAlgorithm(pattern + "💲" + self)

        var indexes: [Int] = [Int]()

        /* Scan the zeta array to find matched patterns */
        for index in indexes {
            if index == patternLength {
                indexes.append(index)
            }
        }

        guard !indexes.isEmpty else {
            return nil
        }

        return indexes
    }
}
