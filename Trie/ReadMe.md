# Trie

##What is a Trie?
A trie (also known as a prefix tree, or radix tree in some other (but different) implementations) is a special type of tree used to store associative data structures where the key item is normally of type String.  Each node in the trie is typically not associated with a value containing strictly itself, but more so is linked to some common prefix that precedes it in levels above it.  Oftentimes, true key-value pairs are associated with the leaves of the trie, but they are not limited to this.

##Why a Trie?
Tries are very useful simply for the fact that it has some advantages over other data structures, like the binary tree or a hash map.  These advantages include:
* Looking up keys is typically faster in the worst case when compared to other data structures.
* Unlike a hash map, a trie need not worry about key collisions
* No need for hasing, as each key will have a unique path in the trie
* Tries, by implementation, can be by default alphabetically ordered.


##Common Algorithms

###Find (or any general lookup function)
Tries make looking up keys a trivial task, as all one has to do is walk over the nodes until we either hit a null reference or we find the key in question.

The algorithm would be as follows:
```
  let node be the root of the trie
  
  for each character in the key
    if the child of node with value character is null
      return false (key doesn't exist in trie)
    else
      node = child of node with value character  (move to the next node)
  return true (key exists in trie and was found
```

And in swift:
```swift
func find(key: String) -> (node: Node?, found: Bool) {
    var currentNode = self.root

    for c in key.characters {
      if currentNode.children[String(c)] == nil {
        return(nil, false)
      }
      currentNode = currentNode.children[String(c)]!
    }

    return(currentNode, currentNode.isValidWord())
  }
```

###Insertion
Insertion is also a trivial task with a Trie, as all one needs to do is walk over the nodes until we either halt on a node that we must mark as a key, or we reach a point where we need to add extra nodes to represent it.

Let's walk through the algorithm:

```
  let S be the root node of our tree
  let word be the input key
  let length be the length of the key
  
  
  find(word)
  if the word was found
    return false
  else
    
    for each character in word
      if child node with value character does not exist
        break
      else
        node = child node with value character
        decrement length
      
    if length != 0
      let suffix be the remaining characters in the key defined by the shortened length
      
      for each character in suffix
        create a new node with value character and let it be the child of node
        node = newly created child now
      mark node as a valid key
    else
      mark node as valid key
```

And the corresponding swift code:

```swift
  func insert(w: String) -> (word: String, inserted: Bool) {

    let word = w.lowercaseString
    var currentNode = self.root
    var length = word.characters.count

    if self.contains(word) {
      return (w, false)
    }

    var index = 0
    var c = Array(word.characters)[index]

    while let child = currentNode.children[String(c)] {
      currentNode = child
      length -= 1
      index += 1

      if(length == 0) {
        currentNode.isWord()
        wordList.append(w)
        wordCount += 1
        return (w, true)
      }

      c = Array(word.characters)[index]
    }

    let remainingChars = String(word.characters.suffix(length))
    for c in remainingChars.characters {
      currentNode.children[String(c)] = Node(c: String(c), p: currentNode)
      currentNode = currentNode.children[String(c)]!
    }

    currentNode.isWord()
    wordList.append(w)
    wordCount += 1
    return (w, true)
  }

```

###Removal
Removing keys from the trie is a little more tricky, as there a few more cases that we have to take into account the fact that keys may exist that are actually sub-strings of other valid keys.  That being said, it isn't as simple a process to just delete the nodes for a specific key, as we could be deleting references/nodes necessary for already exisitng keys!

The algorithm would be as follows:

```
  
  let word be the key to remove
  let node be the root of the trie
  
  find(word)
  if word was not found
    return false
  else
  
    for each character in word
      node = child node with value character
      
      if node has more than just 1 child node
        Mark node as an invalid key, since removing it would remove nodes still in use
      else
        while node has no valid children and node is not the root node
          let character = node's value
          node = the parent of node
          delete node's child node with value character
        return true
```



and the corresponding swift code:

```swift
  func remove(w: String) -> (word: String, removed: Bool){
    let word = w.lowercaseString

    if(!self.contains(w)) {
      return (w, false)
    }
    var currentNode = self.root

    for c in word.characters {
      currentNode = currentNode.getChildAt(String(c))
    }

    if currentNode.numChildren() > 0 {
      currentNode.isNotWord()
    } else {
      var character = currentNode.char()
      while(currentNode.numChildren() == 0 && !currentNode.isRoot()) {
        currentNode = currentNode.getParent()
        currentNode.children[character]!.setParent(nil)
        currentNode.children[character]!.update(nil)
        currentNode.children[character] = nil
        character = currentNode.char()
      }
    }

    wordCount -= 1

    var index = 0
    for item in wordList{
      if item == w {
        wordList.removeAtIndex(index)
      }
      index += 1
    }

    return (w, true)
  }

```


###Running Times

Let n be the length of some key in the trie

* Find(...) : In the Worst case O(n)
* Insert(...) :  O(n)
* Remove(...) :  O(n)

###Other Notable Operations

* Count:  Returns the number of keys in the trie ( O(1) )
* getWords:  Returns a list containing all keys in the trie ( *O(1) )
* isEmpty:  Returns true f the trie is empty, false otherwise ( *O(1) )
* contains:  Returns true if the trie has a given key, false otherwise ( O(n) )

`* denotes that running time may vary depending on implementation

See also [Wikipedia entry for Trie](https://en.wikipedia.org/wiki/Trie).

*Written for the Swift Algorithm Club by Christian Encarnacion*

