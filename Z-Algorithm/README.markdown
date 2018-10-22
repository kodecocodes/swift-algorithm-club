# Z-Algorithm String Search

Goal: Write a simple linear-time string matching algorithm in Swift that returns the indexes of all the occurrencies of a given pattern. 
 
In other words, we want to implement an `indexesOf(pattern: String)` extension on `String` that returns an array `[Int]` of integers, representing all occurrences' indexes of the search pattern, or `nil` if the pattern could not be found inside the string.
 
For example:

```swift
let str = "Hello, playground!"
str.indexesOf(pattern: "ground")   // Output: [11]

let traffic = "🚗🚙🚌🚕🚑🚐🚗🚒🚚🚎🚛🚐🏎🚜🚗🏍🚒🚲🚕🚓🚌🚑"
traffic.indexesOf(pattern: "🚑") // Output: [4, 21]
```

Many string search algorithms use a pre-processing function to compute a table that will be used in successive stage. This table can save some time during the pattern search stage because it allows to avoid un-needed characters comparisons. The [Z-Algorithm]() is one of these functions. It borns as a pattern pre-processing function (this is its role in the [Knuth-Morris-Pratt algorithm](../Knuth-Morris-Pratt/) and others) but, just like we will show here, it can be used also as a single string search algorithm.

### Z-Algorithm as pattern pre-processor

As we said, the Z-Algorithm is foremost an algorithm that process a pattern in order to calculate a skip-comparisons-table.
The computation of the Z-Algorithm over a pattern `P` produces an array (called `Z` in the literature) of integers in which each element, call it `Z[i]`, represents the length of the longest substring of `P` that starts at `i` and matches a prefix of `P`. In simpler words, `Z[i]` records the longest prefix of `P[i...|P|]` that matches a prefix of `P`. As an example, let's consider `P = "ffgtrhghhffgtggfredg"`. We have that `Z[5] = 0 (f...h...)`, `Z[9] = 4 (ffgtr...ffgtg...)` and `Z[15] = 1 (ff...fr...)`.

But how do we compute `Z`? Before we describe the algorithm we must indroduce the concept of Z-box. A Z-box is a pair `(left, right)` used during the computation that records the substring of maximal length that occurs also as a prefix of `P`. The two indices `left` and `right` represent, respectively, the left-end index and the right-end index of this substring. 
The definition of the Z-Algorithm is inductive and it computes the elements of the array for every position `k` in the pattern, starting from `k = 1`. The following values (`Z[k + 1]`, `Z[k + 2]`, ...) are computed after `Z[k]`. The idea behind the algorithm is that previously computed values can speed up the calculus of `Z[k + 1]`, avoiding some character comparisons that were already done before. Consider this example: suppose we are at iteration `k = 100`, so we are analyzing position `100` of the pattern. All the values between `Z[1]` and `Z[99]` were correctly computed and `left = 70` and `right = 120`. This means that there is a substring of length `51` starting at position `70` and ending at position `120` that matches the prefix of the pattern/string we are considering. Reasoning on it a little bit we can say that the substring of length `21` starting at position `100` matches the substring of length `21` starting at position `30` of the pattern (because we are inside a substring that matches a prefix of the pattern). So we can use `Z[30]` to compute `Z[100]` without additional character comparisons.
This a simple description of the idea that is behind this algorithm. There are a few cases to manage when the use of pre-computed values cannot be directly applied and some comparisons are to be made.

Here is the code of the function that computes the Z-array:
```swift
func ZetaAlgorithm(ptrn: String) -> [Int]? {
    let pattern = Array(ptrn)
    let patternLength: Int = pattern.count

    guard patternLength > 0 else {
        return nil
    }

    var zeta: [Int] = [Int](repeating: 0, count: patternLength)

    var left: Int = 0
    var right: Int = 0
    var k_1: Int = 0
    var betaLength: Int = 0
    var textIndex: Int = 0
    var patternIndex: Int = 0

    for k in 1 ..< patternLength {
        if k > right {  // Outside a Z-box: compare the characters until mismatch
            patternIndex = 0

            while k + patternIndex < patternLength  &&
                pattern[k + patternIndex] == pattern[patternIndex] {
                patternIndex = patternIndex + 1
            }

            zeta[k] = patternIndex

            if zeta[k] > 0 {
                left = k
                right = k + zeta[k] - 1
            }
        } else {  // Inside a Z-box
            k_1 = k - left + 1
            betaLength = right - k + 1

            if zeta[k_1 - 1] < betaLength { // Entirely inside a Z-box: we can use the values computed before
                zeta[k] = zeta[k_1 - 1]
            } else if zeta[k_1 - 1] >= betaLength { // Not entirely inside a Z-box: we must proceed with comparisons too
                textIndex = betaLength
                patternIndex = right + 1

                while patternIndex < patternLength && pattern[textIndex] == pattern[patternIndex] {
                    textIndex = textIndex + 1
                    patternIndex = patternIndex + 1
                }

                zeta[k] = patternIndex - k
                left = k
                right = patternIndex - 1
            }
        }
    }
    return zeta
}
```

Let's make an example reasoning with the code above. Let's consider the string `P = “abababbb"`. The algorithm begins with `k = 1`, `left = right = 0`. So, no Z-box is "active" and thus, because `k > right` we start with the character comparisons beetwen `P[1]` and `P[0]`.
  
    
       01234567
    k:  x
       abababbb
       x
    Z: 00000000
    left:  0
    right: 0

We have a mismatch at the first comparison and so the substring starting at `P[1]` does not match a prefix of `P`. So, we put `Z[1] = 0` and let `left` and `right` untouched. We begin another iteration with `k = 2`, we have `2 > 0` and again we start comparing characters `P[2]` with `P[0]`. This time the characters match and so we continue the comparisons until a mismatch occurs. It happens at position `6`. The characters matched are `4`, so we put `Z[2] = 4` and set `left = k = 2` and `right = k + Z[k] - 1 = 5`. We have our first Z-box that is the substring `"abab"` (notice that it matches a prefix of `P`) starting at position `left = 2`.

       01234567
    k:   x
       abababbb
       x
    Z: 00400000
    left:  2
    right: 5

We then proceed with `k = 3`. We have `3 <= 5`. We are inside the Z-box previously found and inside a prefix of `P`. So we can look for a position that has a previously computed value. We calculate `k_1 = k - left = 1` that is the index of the prefix's character equal to `P[k]`. We check `Z[1] = 0` and `0 < (right - k + 1 = 3)` and we find that we are exactly inside the Z-box. We can use the previously computed value, so we put `Z[3] = Z[1] = 0`, `left` and `right` remain unchanged.
At iteration `k = 4` we initially execute the `else` branch of the outer `if`. Then in the inner `if` we have that `k_1 = 2` and `(Z[2] = 4) >= 5 - 4 + 1`. So, the substring `P[k...r]` matches for `right - k + 1 = 2` chars the prefix of `P` but it could not for the following characters. We must then compare the characters starting at `r + 1 = 6` with those starting at `right - k + 1 = 2`. We have `P[6] != P[2]` and so we have to set `Z[k] = 6 - 4 = 2`, `left = 4` and `right = 5`.

       01234567
    k:     x
       abababbb
       x
    Z: 00402000
    left:  4
    right: 5

With iteration `k = 5` we have `k <= right` and then `(Z[k_1] = 0) < (right - k + 1 = 1)` and so we set `z[k] = 0`. In iteration `6` and `7` we execute the first branch of the outer `if` but we only have mismatches, so the algorithms terminates returning the Z-array as `Z = [0, 0, 4, 0, 2, 0, 0, 0]`.

The Z-Algorithm runs in linear time. More specifically, the Z-Algorithm for a string `P` of size `n` has a running time of `O(n)`.

The implementation of Z-Algorithm as string pre-processor is contained in the [ZAlgorithm.swift](./ZAlgorithm.swift) file.

### Z-Algorithm as string search algorithm 

The Z-Algorithm discussed above leads to the simplest linear-time string matching algorithm. To obtain it, we have to simply concatenate the pattern `P` and text `T` in a string `S = P$T` where `$` is a character that does not appear neither in `P` nor `T`. Then we run the algorithm on `S` obtaining the Z-array. All we have to do now is scan the Z-array looking for elements equal to `n` (which is the pattern length). When we find such value we can report an occurrence.

```swift
extension String {

    func indexesOf(pattern: String) -> [Int]? {
        let patternLength: Int = pattern.count
        /* Let's calculate the Z-Algorithm on the concatenation of pattern and text */
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
```

Let's make an example. Let `P = “CATA“` and `T = "GAGAACATACATGACCAT"` be the pattern and the text. Let's concatenate them with the character `$`. We have the string `S = "CATA$GAGAACATACATGACCAT"`. After computing the Z-Algorithm on `S` we obtain:

                1         2
      01234567890123456789012
      CATA$GAGAACATACATGACCAT
    Z 00000000004000300001300
                ^

We scan the Z-array and at position `10` we find `Z[10] = 4 = n`. So we can report a match occuring at text position `10 - n - 1 = 5`.

As said before, the complexity of this algorithm is linear. Defining `n` and `m` as pattern and text lengths, the final complexity we obtain is `O(n + m + 1) = O(n + m)`.


Credits: This code is based on the handbook ["Algorithm on String, Trees and Sequences: Computer Science and Computational Biology"](https://books.google.it/books/about/Algorithms_on_Strings_Trees_and_Sequence.html?id=Ofw5w1yuD8kC&redir_esc=y) by Dan Gusfield, Cambridge University Press, 1997. 

*Written for Swift Algorithm Club by Matteo Dunnhofer*
