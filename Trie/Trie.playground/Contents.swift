let trie = Trie()

trie.insert(word: "apple")
trie.insert(word: "ap")
trie.insert(word: "a")

trie.contains(word: "apple")
trie.contains(word: "ap")
trie.contains(word: "a")

trie.remove(word: "apple")
trie.contains(word: "a")
trie.contains(word: "apple")

trie.insert(word: "apple")
trie.contains(word: "apple")
