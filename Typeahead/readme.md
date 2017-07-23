# Typeahead

Given an array contains a lot strings, and given another prefix search string. Return all strings in this array which has this prefix.

For example,

> words = ["abc", "aaccd", "bce"]
>
> prefix = "a"
>
> return ["abc", "aaccd"]

## Solution 1 - Brute Force

Simple is smart. I think 80% problem could be solved by search, in another word, brute force all possible solutions.

We just loop all words to see if the word contains the prefix. The code is also very simple.

```swift
public class BruteForce {
    
    private let words: [String]
    
    public init(_ words: [String]) {
        self.words = words
    }
    
    public func find(_ prefix: String) -> [String] {
        var ret: [String] = []
        
        for word in words {
            if word.hasPrefix(prefix) {
                ret.append(word)
            }
        }
        
        return ret
    }
}
```

How about the time complexity? We loop all words, it cost `O(n)` . Then each word need to one by one characters compare with prefix, let's say the prefix word length is `m`. Then the total time complexity is `O(n * m)`. If the query prefix operation runs `k` times. The time complexity is `O(k * n * m)`.  In the real word, `k` is very large, image how often you go to Google to search. And how many people will do the same thing! So, `O(n * m)` is not enough. Let's see how we can improve this.

## Solution 2 - Hash

The bottle neck in brute force is that each time we need to compare the prefix with each word again and again. That will have a lot of dulicpate works. For the duplicate work, what we can do? Usually, we need extra space to store the state or result. Then, we can easily query it in `O(1)`, right? We can easily figure out we need to use hash table. How to do it?

How about we use prefix as key and words as value to represent all words that have this prefix? The data structure will be like this.

```swift
prefixWords: [String: [String]]
```

And the first time, we need to calcuate all possible solutions. That will cost `O(m * n)` time, `m` is average length of each word. Later, each prefix query cost `O(1)` time, that's huge improvement!

Let's see the code

```swif
public class PrefixHashTable {
    private var prefixWords: [String: [String]] = [:]
    
    public init(_ words: [String]) {
        constructPrefixWords(words)
    }
    
    public func find(_ prefix: String) -> [String]? {
        return prefixWords[prefix]
    }
    
    private func constructPrefixWords(_ words: [String]) {
        for word in words {
            for end in 0..<word.characters.count {
                let endIndex = word.index(word.startIndex, offsetBy: end)
                let prefix = word[word.startIndex...endIndex]
                if prefixWords[prefix] == nil {
                    prefixWords[prefix] = []
                }
                prefixWords[prefix]?.append(word)
            }
        }
    }
}
```



## Solution 3 - Trie

The problem in Solution 2 is that it cost a lot of memory, around `O(n * m)`. Do we have a way to reduce it?

Answer is trie.

You can see more detais in [trie](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Trie)  implement.  It already provide an API to solve this problem. Here is the code.

```swift
let trie = Trie()
trie.insert(word: "abc")
trie.insert(word: "aaccd")
trie.insert(word: "bce")
trie.findWordsWithPrefix(prefix: "a") // ["abc", aaccd"]
```

