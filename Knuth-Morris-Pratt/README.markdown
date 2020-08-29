# Knuth-Morris-Pratt String Search

Goal: Write a linear-time string matching algorithm in Swift that returns the indexes of all the occurrencies of a given pattern.

In other words, we want to implement an `indexesOf(pattern: String)` extension on `String` that returns an array `[Int]` of integers, representing all occurrences' indexes of the search pattern, or `nil` if the pattern could not be found inside the string.

For example:

```swift
let dna = "ACCCGGTTTTAAAGAACCACCATAAGATATAGACAGATATAGGACAGATATAGAGACAAAACCCCATACCCCAATATTTTTTTGGGGAGAAAAACACCACAGATAGATACACAGACTACACGAGATACGACATACAGCAGCATAACGACAACAGCAGATAGACGATCATAACAGCAATCAGACCGAGCGCAGCAGCTTTTAAGCACCAGCCCCACAAAAAACGACAATFATCATCATATACAGACGACGACACGACATATCACACGACAGCATA"
dna.indexesOf(ptnr: "CATA")   // Output: [20, 64, 130, 140, 166, 234, 255, 270]

let concert = "🎼🎹🎹🎸🎸🎻🎻🎷🎺🎤👏👏👏"
concert.indexesOf(ptnr: "🎻🎷")   // Output: [6]
```

The [Knuth-Morris-Pratt algorithm](https://en.wikipedia.org/wiki/Knuth–Morris–Pratt_algorithm) is considered one of the best algorithms for solving the pattern matching problem. Although in practice [Boyer-Moore](../Boyer-Moore-Horspool/) is usually preferred, the algorithm that we will introduce is simpler, and has the same (linear) running time.

The idea behind the algorithm is not too different from the [naive string search](../Brute-Force%20String%20Search/) procedure. As it, Knuth-Morris-Pratt aligns the text with the pattern and goes with character comparisons from left to right. But, instead of making a shift of one character when a mismatch occurs, it uses a more intelligent way to move the pattern along the text. In fact, the algorithm features a pattern pre-processing stage where it acquires all the informations that will make the algorithm skip redundant comparisons, resulting in larger shifts.

The pre-processing stage produces an array (called `suffixPrefix` in the code) of integers in which every element `suffixPrefix[i]` records the length of the longest proper suffix of `P[0...i]` (where `P` is the pattern) that matches a prefix of `P`. In other words, `suffixPrefix[i]` is the longest proper substring of `P` that ends at position `i` and that is a prefix of `P`. Just a quick example. Consider `P = "abadfryaabsabadffg"`, then `suffixPrefix[4] = 0`, `suffixPrefix[9] = 2`, `suffixPrefix[14] = 4`.
There are different ways to obtain the values of `SuffixPrefix` array. We will use the method based on the [Z-Algorithm](../Z-Algorithm/). This function takes in input the pattern and produces an array of integers. Each element represents the length of the longest substring starting at position `i` of `P` and that matches a prefix of `P`. You can notice that the two arrays are similar, they record the same informations but on the different places. We only have to find a method to map `Z[i]` to `suffixPrefix[j]`. It is not that difficult and this is the code that will do for us:

```swift
for patternIndex in (1 ..< patternLength).reversed() {
    textIndex = patternIndex + zeta![patternIndex] - 1
    suffixPrefix[textIndex] = zeta![patternIndex]
}
```

We are simply computing the index of the end of the substring starting at position `i` (as we know matches a prefix of `P`). The element of `suffixPrefix` at that index then it will be set with the length of the substring.

Once the shift-array `suffixPrefix` is ready we can begin with pattern search stage. The algorithm first attempts to compare the characters of the text with those of the pattern. If it succeeds, it goes on until a mismatch occurs. When it happens, it checks if an occurrence of the pattern is present (and reports it). Otherwise, if no comparisons are made then the text cursor is moved forward, else the pattern is shifted to the right. The shift's amount is based on the `suffixPrefix` array, and it guarantees that the prefix `P[0...suffixPrefix[i]]` will match its opposing substring in the text. In this way, shifts of more than one character are often made and lot of comparisons can be avoided, saving a lot of time.

Here is the code of the Knuth-Morris-Pratt algorithm:

```swift
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
```

Let's make an example reasoning with the code above. Let's consider the string `P = ACTGACTA"`, the consequentially obtained `suffixPrefix` array equal to `[0, 0, 0, 0, 0, 0, 3, 1]`, and the text `T = "GCACTGACTGACTGACTAG"`. The algorithm begins with the text and the pattern aligned like below. We have to compare `T[0]` with `P[0]`.  

                              1       
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:      ^
    pattern:        ACTGACTA
    patternIndex:   ^
                    x
    suffixPrefix:   00000031

We have a mismatch and we move on comparing `T[1]` and `P[0]`. We have to check if a pattern occurrence is present but there is not. So, we have to shift the pattern right and by doing so we have to check `suffixPrefix[1 - 1]`. Its value is `0` and we restart by comparing `T[1]` with `P[0]`. Again a mismath occurs, so we go on with `T[2]` and `P[0]`.

                              1      
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:        ^
    pattern:          ACTGACTA
    patternIndex:     ^
    suffixPrefix:     00000031

This time we have a match. And it continues until position `8`. Unfortunately the length of the match is not equal to the pattern length, we cannot report an occurrence. But we are still lucky because we can use the values computed in the `suffixPrefix` array now. In fact, the length of the match is `7`, and if we look at the element `suffixPrefix[7 - 1]` we discover that is `3`. This information tell us that that the prefix of `P` matches the suffix of the susbtring `T[0...8]`. So the `suffixPrefix` array guarantees us that the two substring match and that we do not have to compare their characters, so we can shift right the pattern for more than one character!
The comparisons restart from `T[9]` and `P[3]`.  

                              1       
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:               ^
    pattern:              ACTGACTA
    patternIndex:            ^
    suffixPrefix:         00000031

They match so we continue the compares until position `13` where a misatch occurs beetwen charcter `G` and `A`. Just like before, we are lucky and we can use the `suffixPrefix` array to shift right the pattern.

                              1       
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:                   ^
    pattern:                  ACTGACTA
    patternIndex:                ^
    suffixPrefix:             00000031

Again, we have to compare. But this time the comparisons finally take us to an occurrence, at position `17 - 7 = 10`.

                              1       
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:                       ^
    pattern:                  ACTGACTA
    patternIndex:                    ^
    suffixPrefix:             00000031

The algorithm than tries to compare `T[18]` with `P[1]` (because we used the element `suffixPrefix[8 - 1] = 1`) but it fails and at the next iteration it ends its work.


The pre-processing stage involves only the pattern. The running time of the Z-Algorithm is linear and takes `O(n)`, where `n` is the length of the pattern `P`. After that, the search stage does not "overshoot" the length of the text `T` (call it `m`). It can be be proved that number of comparisons of the search stage is bounded by `2 * m`. The final running time of the Knuth-Morris-Pratt algorithm is `O(n + m)`.


> **Note:** To execute the code in the [KnuthMorrisPratt.swift](./KnuthMorrisPratt.swift) you have to copy the [ZAlgorithm.swift](../Z-Algorithm/ZAlgorithm.swift) file contained in the [Z-Algorithm](../Z-Algorithm/) folder. The [KnuthMorrisPratt.playground](./KnuthMorrisPratt.playground) already includes the definition of the `Zeta` function.

Credits: This code is based on the handbook ["Algorithm on String, Trees and Sequences: Computer Science and Computational Biology"](https://books.google.it/books/about/Algorithms_on_Strings_Trees_and_Sequence.html?id=Ofw5w1yuD8kC&redir_esc=y) by Dan Gusfield, Cambridge University Press, 1997.

*Written for Swift Algorithm Club by Matteo Dunnhofer*
