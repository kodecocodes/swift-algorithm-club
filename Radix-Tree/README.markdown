# Radix Tree

A radix tree is a tree where a node can have any number of children. Each edge leading from a node to a child has a label (usually a string). A radix tree is often used to store strings or IP addresses and by traversing from the root to any leaf in the tree, (by concatenating all the labels of edges along the way) you can find any string. This is a radix tree:
![](/Radix-Tree/Images/radixtree.png)

## Implemenation

The RadixTree class itself has one member variable, root, of type Root. The Root is the top of every RadixTree. Every node that is added, removed, looked up, etc. is a child, a child of a child, etc. of that root. The rest of the tree is represented as an Edge, which inherits Root. The different between Edge and Root is that Edges have a label (of type String) and a parent (of type Root?) member variables. This approach is a little different from the conventional way of creating Tree data structures but is easier to wrap your head around (see the picture above).

## Operations

Typical operations on a radix tree include lookup, insertion, deletion, find predecessor, find successor, and find all strings with common prefix. The running time of lookup, insertion, and deletion is O(k) where k is the length of the key. This is different from most trees because these operations usually run in O(logn) time where n is the number of nodes in the tree.

### RadixTree.find(_ str: String) -> Bool

The find function returns true if the String you are searching for is in the tree and false if it is not. Every RadixTree contains at the very least one String ("") so find("") will always return true. A String is considered "in the tree" if the String you are searching for is a concatenation of Edge labels while traversing downwards or a prefix of that concatenation. For example, if you look at the example tree above, find("roma") will return true because it is a prefix of the traversal "r"->"om"->"an". On the other hand, find("romans") will return false.

### RadixTree.insert(_ str: String) -> Bool

The insert function returns true if the String you are trying to insert was successfully inserted into the RadixTree and false if the String is already in the tree. Similarly to find(""), insert("") will always return false because an empty RadixTree contains "" by default.

### RadixTree.remove(_ str: String) -> Bool

The remove function returns true if the String is removed and false if the String is not in the tree. When a string is removed, any other Strings that have a prefix of the removed String are removed as well. For example, remove("rom") will also remove "roman", "rome", and "romulus" if those Strings are in the tree as well. Calling remove("") will remove all Strings in the tree.

### Root.level() -> Int

The level function returns how far down in the tree the Root or Edge in question is. A Root object will always return 0. A child of the Root will return 1, a child of a child of the root will return 2, etc.

### RadixTree.height() -> Int

The height function returns an Int equal to the highest level in the Tree. An empty tree will return 0.

### RadixTree.printTree()

The printTree function was used to visualize the tree itself. This function is a little buggy and not perfect yet but gets the job done thus far.

### sharedPrefix(_ str1: String, _ str2: String) -> String

The sharedPrefix function is a non-member function in the RadixTree.swift file. It takes in two String objects and returns the shared prefix between them. For example,
sharedPrefix("apples", "oranges") will return "" and sharedPrefix("court", "coral") will return "co". This function is used in the implementation of the find, insert, and remove functions.

## See Also

[Radix Tree - Wikipedia](https://en.wikipedia.org/wiki/Radix_tree)
