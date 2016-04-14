# Radix Tree

A radix tree is a tree where a node can have any number of children. Each edge leading from a node to a child has a label (usually a string). A radix tree is often used to store strings or IP addresses and by traversing from the root to any leaf in the tree, (by concatenating all the labels of edges along the way) you can find any string. This is a radix tree:
![](/Radix-Tree/Images/radixtree.png)

## Operations

Typical operations on a radix tree include lookup, insertion, deletion, find predecessor, find successor, and find all strings with common prefix. The running time of lookup, insertion, and deletion is O(k) where k is the length of the key. This is different from most trees because these operations usually run in O(logn) time where n is the number of nodes in the tree.

## See Also

[Radix Tree - Wikipedia](https://en.wikipedia.org/wiki/Radix_tree)
