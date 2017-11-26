# Rabin-Karp string search algorithm

The Rabin-Karp string search algorithm is used to search text for a pattern.

A practical application of the algorithm is detecting plagiarism. Given source material, the algorithm can rapidly search through a paper for instances of sentences from the source material, ignoring details such as case and punctuation. Because of the abundance of the sought strings, single-string searching algorithms are impractical.

## Example

Given a text of "The big dog jumped over the fox" and a search pattern of "ump" this will return 13.
It starts by hashing "ump" then hashing "The".  If hashed don't match then it slides the window a character
at a time (e.g. "he ") and subtracts out the previous hash from the "T".

## Algorithm

The Rabin-Karp algorithm uses a sliding window the size of the search pattern.  It starts by hashing the search pattern, then
hashing the first x characters of the text string where x is the length of the search pattern.  It then slides the window one character over and uses
the previous hash value to calculate the new hash faster.  Only when it finds a hash that matches the hash of the search pattern will it compare
the two strings it see if they are the same (to prevent a hash collision from producing a false positive).

## The code

The major search method is next.  More implementation details are in rabin-karp.swift

```swift
public func search(text: String , pattern: String) -> Int {
    // convert to array of ints
    let patternArray = pattern.flatMap { $0.asInt }
    let textArray = text.flatMap { $0.asInt }

    if textArray.count < patternArray.count {
        return -1
    }

    let patternHash = hash(array: patternArray)
    var endIdx = patternArray.count - 1
    let firstChars = Array(textArray[0...endIdx])
    let firstHash = hash(array: firstChars)

    if (patternHash == firstHash) {
        // Verify this was not a hash collision
        if firstChars == patternArray {
            return 0
        }
    }

    var prevHash = firstHash
    // Now slide the window across the text to be searched
    for idx in 1...(textArray.count - patternArray.count) {
        endIdx = idx + (patternArray.count - 1)
        let window = Array(textArray[idx...endIdx])
        let windowHash = nextHash(prevHash: prevHash, dropped: textArray[idx - 1], added: textArray[endIdx], patternSize: patternArray.count - 1)

        if windowHash == patternHash {
            if patternArray == window {
                return idx
            }
        }

        prevHash = windowHash
    }

    return -1
}
```

This code can be tested in a playground using the following:

```swift
  search(text: "The big dog jumped"", "ump")
```

This will return 13 since ump is in the 13 position of the zero based string.

## Additional Resources

[Rabin-Karp Wikipedia](https://en.wikipedia.org/wiki/Rabin%E2%80%93Karp_algorithm)


*Written by [Bill Barbour](https://github.com/brbatwork)*
