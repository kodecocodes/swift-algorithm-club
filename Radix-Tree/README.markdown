# Radix Tree

A radix tree is a tree where a node can have any number of children. Each edge leading from a node to a child has a label (usually a string). A radix tree is often used to store strings or IP addresses and by traversing from the root to any leaf in the tree, (by concatenating all the labels of edges along the way) you can find any string. This is a radix tree:
![](/Radix-Tree/Images/radixtree.png)

## Implemenation

The RadixTree class itself has one member variable, root, of type Root. The Root is the top of every RadixTree. Every node that is added, removed, looked up, etc. is a child, a child of a child, etc. of that root. The rest of the tree is represented as an Edge, which inherits Root. The different between Edge and Root is that Edges have a label (of type String) and a parent (of type Root?) member variables. This approach is a little different from the conventional way of creating Tree data structures but is easier to wrap your head around (see the picture above).

## Operations

Typical operations on a radix tree include lookup, insertion, deletion, find predecessor, find successor, and find all strings with common prefix. The running time of lookup, insertion, and deletion is O(k) where k is the length of the key. This is different from most trees because these operations usually run in O(logn) time where n is the number of nodes in the tree.

### Find

The find function returns true if the String you are searching for is in the tree and false if it is not. Every RadixTree contains at the very least one String ("") so find("") will always return true. A String is considered "in the tree" if the String you are searching for is a concatenation of Edge labels while traversing downwards or a prefix of that concatenation. For example, if you look at the example tree above, find("roma") will return true because it is a prefix of the traversal "r"->"om"->"an". On the other hand, find("romans") will return false.

### Insert

The insert function returns true if the String you are trying to insert was successfully inserted into the RadixTree and false if the String is already in the tree. Similarly to find(""), insert("") will always return false because an empty RadixTree contains "" by default.

## See Also

[Radix Tree - Wikipedia](https://en.wikipedia.org/wiki/Radix_tree)
