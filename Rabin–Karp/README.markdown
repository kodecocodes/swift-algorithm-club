# Rabin–Karp

Rabin-Karp is a string algorithm that uses hashing to find a pattern in a text.

## Example

Text: `abdabc`
Pattern: `abc`

Start by calculating the hash for the pattern `abc`. The hash function we will use is: `first character` + `second character` x `prime number`<sup>`1`</sup> + `third character` x `prime number`<sup>`2`</sup>

We will use the prime number `3` and the ASCII value of each character for our hash function.

| Character   | ASCII Value |
| ----------- | -----------:|
| a           | 97          |
| b           | 98          |
| c           | 99          |
| d           | 100         |

Calculating the hash value of the pattern `abc`:

| Character   | Hash                      |
| ----------- | -------------------------:|
| a           | 97 = 97                   |
| b           | 98 x 3<sup>1</sup> = 294  |
| c           | 99 x 3<sup>2</sup> = 891  |
|             | **1282**                  |


Now we will break up the text into successive substrings matching the length of the pattern `abd` `bda` `dab` `abc` and calculate the hash value of each substring:

Hash for `abd`:

| Character   | Hash                      |
| ----------- | -------------------------:|
| a           | 97 = 97                   |
| b           | 98 x 3<sup>1</sup> = 294  |
| d           | 100 x 3<sup>2</sup> = 900 |
|             | **1291**                  |

Hash for `bda`:

| Character   | Hash                      |
| ----------- | -------------------------:|
| b           | 98 = 98                   |
| d           | 100 x 3<sup>1</sup> = 300 |
| a           | 97 x 3<sup>2</sup> = 873  |
|             | **1271**                  |

Continue to calculate the rest of the hash values:

| Substring   | Hash |
| ----------- | ----:|
| `abd`       | 1291 |
| `bda`       | 1271 |
| `dab`       | 1273 |
| `abc`       | 1282 |

Now we can compare the hash values for each substring to the hash value of the pattern `1282`:

* `abd` has a hash of `1291` which is not a match
* `bda` has a hash of `1271` which is not a match
* `dab` has a hash of `1273` which is not a match
* `abc` has a hash of `1282` which is a match
  * When the hash values match we need to compare the substring `abc` with the pattern `abc`. Since the strings match we have found a pattern match at index `3`

### Rolling hash

Calculating the hash for each substring is not efficient. The performance of the algorithm can be improved by using a more sophisticated rolling hash function. Lets calculate the hash for `bda` using a rolling hash:

* Subtract the value of the first character `a` in the previous substring `abd` from the previous hash `1291`
  * `1291` - `97` = `1194`
* Divide this value by the prime number
  * `1194` / `3` = `398`
* Add the hash value of the new character `a`
 * `398` + `97` x `3`<sup>`2`</sup> = `398` + `873` = `1271`

## The code

```swift
extension String {
  func indexOf(pattern: String) -> String.Index? {

    let patternLength = pattern.characters.count
    assert(patternLength > 0)
    assert(patternLength <= characters.count)

    for index in 0...characters.count - patternLength {
      let currentIndex = self.startIndex.advancedBy(index)
      let currentSubstring = substringWithRange(currentIndex ..< startIndex.advancedBy(index + patternLength))

      let currentHash = currentSubstring.hashValue

      if currentHash == pattern.hashValue {
        if currentSubstring == pattern {
          return currentIndex
        }
      }
    }
    return nil
  }
}

let data = "the quick brown fox jumps over the lazy dog".indexOf("fox")
```

## Multiple pattern search

The Rabin–Karp algorithm is inferior for single pattern searching to [Boyer–Moore string search algorithm](../Boyer-Moore/) and other faster single pattern string searching algorithms because of its slow worst case behavior. However, it is an algorithm of choice for multiple pattern search.

```swift
TODO: Show multiple pattern search
```

TODO: Implement rolling hash + lint
