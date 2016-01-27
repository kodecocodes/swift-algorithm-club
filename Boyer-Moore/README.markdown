# Boyer-Moore String Search

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

Note: The index of the cow is 6, not 3 as you might expect, because the string uses more storage per character for emoji. The actual value of the `String.Index` is not so important, just that it points at the right character in the string.

First, a brute-force solution:

```swift
extension String {
  func indexOf(pattern: String) -> String.Index? {
    for i in self.startIndex ..< self.endIndex {
      var j = i
      var found = true
      for p in pattern.startIndex ..< pattern.endIndex {
        if j == self.endIndex || self[j] != pattern[p] {
          found = false
          break
        } else {
          j = j.successor()
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

The brute-force approach works OK, but it's not very efficient (or pretty). As it turns out, you don't need to look at *every* character from the source string -- you can often skip ahead multiple characters.

That skip-ahead algorithm is called [Boyer-Moore](https://en.wikipedia.org/wiki/Boyer–Moore_string_search_algorithm) and it has been around for a long time. It is considered the benchmark for all string search algorithms.

Here's how you could write it in Swift:

```swift
extension String {
  func indexOf(pattern: String) -> String.Index? {
    // Cache the length of the search pattern because we're going to
    // use it a few times and it's expensive to calculate.
    let patternLength = pattern.characters.count
    assert(patternLength > 0)
    assert(patternLength <= self.characters.count)

    // Make the skip table. This table determines how far we skip ahead
    // when a character from the pattern is found.
    var skipTable = [Character: Int]()
    for (i, c) in pattern.characters.enumerate() {
      skipTable[c] = patternLength - i - 1
    }

    // This points at the last character in the pattern.
    let p = pattern.endIndex.predecessor()
    let lastChar = pattern[p]

    // The pattern is scanned right-to-left, so skip ahead in the string by
    // the length of the pattern. (Minus 1 because startIndex already points
    // at the first character in the source string.)
    var i = self.startIndex.advancedBy(patternLength - 1)

    // This is a helper function that steps backwards through both strings 
    // until we find a character that doesn’t match, or until we’ve reached
    // the beginning of the pattern.
    func backwards() -> String.Index? {
      var q = p
      var j = i
      while q > pattern.startIndex {
        j = j.predecessor()
        q = q.predecessor()
        if self[j] != pattern[q] { return nil }
      }
      return j
    }

    // The main loop. Keep going until the end of the string is reached.
    while i < self.endIndex {
      let c = self[i]

      // Does the current character match the last character from the pattern?
      if c == lastChar {

        // There is a possible match. Do a brute-force search backwards.
        if let k = backwards() { return k }

        // If no match, we can only safely skip one character ahead.
        i = i.successor()
      } else {
        // The characters are not equal, so skip ahead. The amount to skip is
        // determined by the skip table. If the character is not present in the
        // pattern, we can skip ahead by the full pattern length. However, if
        // the character *is* present in the pattern, there may be a match up
        // ahead and we can't skip as far.
        i = i.advancedBy(skipTable[c] ?? patternLength)
      }
    }
    return nil
  }
}
```

The algorithm works as follows. You line up the search pattern with the source string and see what character from the string matches the *last* character of the search pattern:

	source string:  Hello, World
	search pattern: World
	                    ^

There are three possibilities:

1. The two characters are equal. You've found a possible match.

2. The characters are not equal, but the source character does appear in the search pattern elsewhere.

3. The source character does not appear in the search pattern at all.

In the example, the characters `o` and `d` do not match, but `o` does appear in the search pattern. That means we can skip ahead several positions:

	source string:  Hello, World
	search pattern:    World
	                       ^

Note how the two `o` characters line up now. Again you compare the last character of the search pattern with the search text: `W` vs `d`. These are not equal but the `W` does appear in the pattern. So skip ahead again to line up those two `W` characters:

	source string:  Hello, World
	search pattern:        World
	                           ^

This time the two characters are equal and there is a possible match. To verify the match you do a brute-force search, but backwards, from the end of the search pattern to the beginning. And that's all there is to it.

The amount to skip ahead at any given time is determined by the "skip table", which is a dictionary of all the characters in the search pattern and the amount to skip by. The skip table in the example looks like:

	W: 4
	o: 3
	r: 2
	l: 1
	d: 0

The closer a character is to the end of the pattern, the smaller the skip amount. If a character appears more than once in the pattern, the one nearest to the end of the pattern determines the skip value for that character.

A caveat: If the search pattern consists of only a few characters, it's faster to do a brute-force search. There's a trade-off between the time it takes to build the skip table and doing brute-force for short patterns.

Credits: This code is based on the article ["Faster String Searches" by Costas Menico](http://www.drdobbs.com/database/faster-string-searches/184408171) from Dr Dobb's magazine, July 1989 -- Yes, 1989! Sometimes it's useful to keep those old magazines around.
