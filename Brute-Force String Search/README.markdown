# Brute-Force String Search

How would you go about writing a string search algorithm in pure Swift if you were not allowed to import Foundation and could not use `NSString`'s `rangeOfString()` method?

The goal is to implement an `indexOf(pattern: String)` extension on `String` that returns the `String.Index` of the first occurrence of the search pattern, or `nil` if the pattern could not be found inside the string.
 
For example:

```swift
// Input: 
let s = "Hello, World"
s.indexOf("World")

// Output:
<String.Index?> 7

// Input:
let animals = "🐶🐔🐷🐮🐱"
animals.indexOf("🐮")

// Output:
<String.Index?> 6
```

> **Note:** The index of the cow is 6, not 3 as you might expect, because the string uses more storage per character for emoji. The actual value of the `String.Index` is not so important, just that it points at the right character in the string.

Here is a brute-force solution:

```swift
extension String {
  func indexOf(_ pattern: String) -> String.Index? {
    for i in self.characters.indices {
        var j = i
        var found = true
        for p in pattern.characters.indices{
            if j == self.characters.endIndex || self[j] != pattern[p] {
                found = false
                break
            } else {
                j = self.characters.index(after: j)
            }
        }
        if found {
            return i
        }
    }
    return nil
  }
}
```

This looks at each character in the source string in turn. If the character equals the first character of the search pattern, then the inner loop checks whether the rest of the pattern matches. If no match is found, the outer loop continues where it left off. This repeats until a complete match is found or the end of the source string is reached.

The brute-force approach works OK, but it's not very efficient (or pretty). It should work fine on small strings, though. For a smarter algorithm that works better with large chunks of text, check out [Boyer-Moore](../Boyer-Moore/) string search.

*Written for Swift Algorithm Club by Matthijs Hollemans*
