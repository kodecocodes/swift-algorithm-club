//: Playground - noun: a place where people can play

let bruteForce = BruteForce(["abc", "aaccd", "bce"])
bruteForce.find("a") // ["abc", aaccd"]

let prefixTable = PrefixHashTable(["abc", "aaccd", "bce"])
prefixTable.find("a") // ["abc", aaccd"]

let trie = Trie()
trie.insert(word: "abc")
trie.insert(word: "aaccd")
trie.insert(word: "bce")
trie.findWordsWithPrefix(prefix: "a") // ["abc", aaccd"]


