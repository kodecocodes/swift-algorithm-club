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

```swift
func traverse(n: Node?) {
	if (n == nil) { return
	} else {
		traverse(n.left)
		visit(n)
		traverse(n.right)
	}
}
```
Where `n` is a a node in the tree (or `nil`), each node stores
its children as `left` and `right`, and "visiting" a node can mean
performing any desired action on it.  We would call this function by passing to
it the root of the tree we wish to traverse.

While simple and understandable, this algorithm uses stack space proportional
to the height of the tree due to its recursive nature.  If the tree has **n**
nodes, this usage can range anywhere from **O(log n)** for a fairly balanced
tree, to **O(n)** to a very unbalanced tree.

A threaded binary tree fixes this problem.

> For more information about in-order traversals [see here](../Binary Tree/).


## Predecessors and successors

An in-order traversal of a tree yields a linear ordering of the nodes.  Thus
each node has both a predecessor and a successor (except for the first and last
nodes, which only have a successor or a predecessor respectively).  In a
threaded binary tree, each left child pointer that would normally be `nil`
instead points to the node's predecessor (if it exists), and each right child
pointer that would normally be `nil` instead points to the node's successor
(if it exists).  This is what separates threaded binary trees from standard
binary trees.

There are two types of threaded binary trees:  single threaded and double
threaded:
- A single threaded tree keeps track of **either** the in-order predecessor
  **or** successor (left **or** right).
- A double threaded tree keeps track of **both** the in-order predecessor
  **and** successor (left **and** right).

Using a single or double threaded tree depends on what we want to accomplish.
If we only need to traverse the tree in one direction (either forward or
backward), use a single threaded tree.  If we want to traverse in both
directions, use a double threaded tree.

It is important to note that each node stores either its predecessor or its
left child, and either its successor or its right child.  The nodes do not
need to keep track of both.  For example, in a double threaded tree, if a node
has a right child but no left child, it will track its predecessor in place of
its left child.


## Traversal algorithm

Because predecessors and/or successors are tracked, an in-order traversal of a
threaded binary tree is much more efficient than the recursive algorithm
outlined above.  We use these predecessor/successor attributes to great effect
in this new algorithm (note that this is for a forward traversal):

```swift
traverse(root):
	if (root == nil) return
 
    // Find the leftmost Node
    Node n = root
	while (n.left != nil):
		n = n.left
 
    while (n != nil):
		visit n

        // If this Node is a thread Node, then go to its in-order successor
        if (n.rightThread):
            n = n.right
 
		// Else go to the leftmost Node in its right subtree
        else:
            n = n.right
			while (n.left != nil):
				n = n.left
```
Where:
- `root` is the root of the tree (or `nil`).
- Each node stores its children or predecessor/successor as `left`
  and `right`.
- "Visiting" a node can mean performing any desired action on it.
- The booleans `leftThread` and `rightThread` keep track of whether `left` and
  `right` point to a child or a predecessor/successor.
	- They are `true` for predecessors/successors, and `false` for children.
	- While `leftThread` is not used here, it would be used in a backwards
	  traversal in a double threaded tree or a single threaded tree "pointing"
	  the other direction.
- The first node in the traversal has `leftThread = true` and `left = nil`
- The last node in the traversal has `rightThread = true` and `right = nil`


## An example


### Still under construction.

## See also 

[Threaded Binary Tree on Wikipedia](https://en.wikipedia.org/wiki/Threaded_binary_tree).

*Written for the Swift Algorithm Club by Jayson Tung*
