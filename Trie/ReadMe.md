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
  let word be an array of characters of the input key
  let length be the length of the key
  
  
  find(key)
  if the key was found
    return false
  else
    
    for each character in key
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





`

See also [Wikipedia](https://en.wikipedia.org/wiki/Trie).

*Written for the Swift Algorithm Club by Christian Encarnacion*

