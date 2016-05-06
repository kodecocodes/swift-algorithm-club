# Radix Tree

A radix tree is a [tree](../Tree/) where a node can have any number of children. Each edge leading from a node to a child has a label (usually a string). A radix tree is often used to store strings or IP addresses. By traversing from the root to any leaf in the tree, concatenating all the labels of edges along the way, you can find any string.

This is an example of a radix tree (image from wikipedia.org):

![](Images/radixtree.png)

## Implemenation

The radix tree is represented by a `RadixTree` object. This class has one member variable, `root`, of type `Root`. The `Root` is the object at the top of every `RadixTree`. 

Every other node is of type `Edge` and is a child (or child of a child, etc.) of the root. 

The difference between `Edge` and `Root` is that edges have a label (of type `String`) and a reference to a parent node. 

This approach is a little different from the conventional way of creating tree data structures but is easier to wrap your head around (see the picture above).

## Operations

Typical operations on a radix tree are:

- lookup
- insertion
- deletion
- find predecessor
- find successor
- find all strings with common prefix

The running time of lookup, insertion, and deletion is **O(k)** where **k** is the length of the key. This is different from most trees because these operations usually run in **O(log n)** time where **n** is the number of nodes in the tree.

### Lookup

The `find()` function returns true if the string you are searching for is in the tree and false if it is not. 

Every `RadixTree` contains at the very least the empty string `""` so `find("")` will always return true. 

A string is considered "in the tree" if the text you are searching for is a concatenation of `Edge` labels while traversing downwards, or a prefix of that concatenation.

For example, if you look at the example tree above, `find("roma")` will return true because it is a prefix of the traversal `"r" -> "om" -> "an"`. 

On the other hand, `find("romans")` will return false.

### Insertion

The `insert()` function lets you add new strings to the radix tree.

This function returns true if the string you are trying to insert was successfully inserted into the `RadixTree` and false if the string is already in the tree.

### Deletion

The `remove()` removes a string from the tree. When a string is removed, any other strings that have a prefix of the removed string are removed as well. 

For example, `remove("rom")` will also remove `"roman"`, `"rome"`, and `"romulus"` if those strings are in the tree as well. Calling `remove("")` will remove all strings in the tree.

### printTree()

You can use the `printTree()` function to visualize the tree. This function is a little buggy and not perfect yet but gets the job done thus far.

### Helper functions

The `sharedPrefix()` function is a non-member function in the **RadixTree.swift** file. It takes in two `String` objects and returns the shared prefix between them. 

For example, `sharedPrefix("apples", "oranges")` will return `""`, and `sharedPrefix("court", "coral")` will return `"co"`. 

This function is used in the implementation of the `find()`, `insert()`, and `remove()` functions.

## See also

[Radix Tree - Wikipedia](https://en.wikipedia.org/wiki/Radix_tree)

*Written for Swift Algorithm Club by Steven Scally*
