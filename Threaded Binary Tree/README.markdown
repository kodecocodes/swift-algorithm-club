# Threaded Binary Tree

A threaded binary tree is a special kind of [binary tree](../Binary Tree/) (a
tree in which each node has at most two children) that maintains a few extra
pointers to allow cheap and fast **in-order traversal** of the tree.

If you don't know what a tree is or what it is for, then [read this
first](../Tree/).


## In-order traversal

The main motivation behind using a threaded binary tree over a simpler and
smaller standard binary tree is to increase the speed of **in-order traversal**
of the tree.  An in-order traversal of a binary tree visits the nodes in the
order in which they are stored, which matches the underlying ordering of a
[binary search tree](../Binary Search Tree/).  The idea is to visit all the
left children of a node first, then visit the node itself, and visit the left
children last.

In-order traversal of any binary tree generally goes as follows:

```
traverse(n):
	if (n == NULL) return
	else:
		traverse(n->leftChild)
		visit n
		traverse(n->rightChild)
```
Where `n` is a pointer to a node in the tree (or `NULL`), each node stores
pointers to its children as `leftChild` and `rightChild`, and "visiting" a
node can mean performing any action desired on it.

While simple and understandable, this algorithm uses stack space proportional
to the height of the tree due to its recursive nature.  If the tree has **n**
nodes, this usage can range anywhere from **O(log n)** for a fairly balanced
tree, to **O(n)** to a very unbalanced tree.

A threaded binary tree fixes this problem.

> For more information about in-order traversals [see here](../Binary Tree/).


## Predecessors and successors

An in-order traversal of a tree yields a linear ordering of the nodes.  Thus
each node has both a predecessor and a successor (except for the first and last
nodes, which only have a successor or a predecessor respectively).  What makes
a threaded binary tree special is how it keeps track of each node's predecessor
and/or successor.  Just as how nodes keep track of their left and right
children, they also keep track of their predecessor and/or successor.

There are two types of threaded binary trees:  single threaded and double
threaded:
- A single threaded tree keeps track of **either** the in-order predecessor
  **or** successor (left **or** right).
- A double threaded tree keeps track of **both** the in-order predecessor
  **and** successor (left **and** right).

Using a single or double threaded tree depends on what you want to accomplish.
If you only need to traverse the tree in one direction (either forward or
backward), use a single threaded tree.  If you want to traverse in both
directions, use a double threaded tree.


## An example


### Still under construction.

## See also 

[Threaded Binary Tree on Wikipedia](https://en.wikipedia.org/wiki/Threaded_binary_tree).

*Written for the Swift Algorithm Club by Jayson Tung*
