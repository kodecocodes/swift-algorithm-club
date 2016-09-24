/*  Knuth-Morris-Pratt algorithm for pattern/string matching

    The code is based on the book:
    "Algorithms on String, Trees and Sequences: Computer Science and Computational Biology"
    by Dan Gusfield
    Cambridge University Press, 1997
*/

import Foundation

extension String {
    
    func indexesOf(ptnr: String) -> [Int]? {
        
        let text = Array(self.characters)
        let pattern = Array(ptnr.characters)
        
        let textLength: Int = text.count
        let patternLength: Int = pattern.count
        
        guard patternLength > 0 else {
            return nil
        }
        
        var suffixPrefix: [Int] = [Int](repeating: 0, count: patternLength)
        var textIndex: Int = 0
        var patternIndex: Int = 0
        var indexes: [Int] = [Int]()
        
        /* Pre-processing stage: computing the table for the shifts (through Z-Algorithm) */
        let zeta = ZetaAlgorithm(ptnr: ptnr)
        
        for patternIndex in (1 ..< patternLength).reversed() {
            textIndex = patternIndex + zeta![patternIndex] - 1
            suffixPrefix[textIndex] = zeta![patternIndex]
        }
        
        /* Search stage: scanning the text for pattern matching */
        textIndex = 0
        patternIndex = 0
        
        while textIndex + (patternLength - patternIndex - 1) < textLength {
            
            while patternIndex < patternLength && text[textIndex] == pattern[patternIndex] {
                textIndex = textIndex + 1
                patternIndex = patternIndex + 1
            }
            
            if patternIndex == patternLength {
                indexes.append(textIndex - patternIndex)
            }
            
            if patternIndex == 0 {
                textIndex = textIndex + 1
            } else {
                patternIndex = suffixPrefix[patternIndex - 1]
            }
        }
        
        guard !indexes.isEmpty else {
            return nil
        }
        return indexes
    }
}
