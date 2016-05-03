# Threaded Binary Tree

A threaded binary tree is a special kind of [binary tree](../Binary Tree/) (a
tree in which each node has at most two children) that maintains a few extra
variables to allow cheap and fast **in-order traversal** of the tree.

If you don't know what a tree is or what it is for, then
[read this first](../Tree/).


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
Where `n` is a a node in the tree (or `nil`), each node stores its children as
`left` and `right`, and "visiting" a node can mean performing any desired
action on it.  We would call this function by passing to it the root of the
tree we wish to traverse.

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
threaded binary tree, each left child that would normally be `nil` instead
stores the node's predecessor (if it exists), and each right child that would
normally be `nil` instead stores the node's successor (if it exists).  This is
what separates threaded binary trees from standard binary trees.

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

Here is a valid "full" threaded binary tree:

![Full](/Images/Full.png)

While the following threaded binary tree is not "full," it is still valid.  The
structure of the tree does not matter as long as it follows the definition of a
binary search tree:

![Partial](/Images/Partial.png)

The solid lines denote the links between parents and children, while the dotted
lines denote the "threads."  The important thing to note here is how the
children and thread edges interact with each other.  Every node besides the
root has one entering edge (from its parent), and two leaving edges: one to the
left and one to the right.  The left leaving edge goes to the node's left child
if it exists, and to its in-order predecessor if it does not.  The right
leaving edge goes to the node's right child if it exists, and to its in-order
successor if it does not.  The exceptions are the left-most node and the
right-most node, which do not have a predecessor or successor, respectively.


## Representation

Before we go into detail about the methods that we can apply to threaded binary
trees, it might be a good idea to explain how we will be representing the tree.
The core of this data structure is the `ThreadedBinaryTree<T: Comparable>`
class.  Each instance of this class represents a node with six member
variables:  `value`, `parent`, `left`, `right`, `leftThread`, and
`rightThread`.  Of all of these, only `value` is required.  The other five are
Swift *optionals*.
- `value: T` is the value of this node (e.g. 1, 2, A, B, etc.)
- `parent: ThreadedBinaryTree?` is the parent of this node (if it exists)
- `left: ThreadedBinaryTree?` is the left child of this node (if it exists)
- `right: ThreadedBinaryTree?` is the right child of this node (if it exists)
- `leftThread: ThreadedBinaryTree?` is the in-order predecessor of this node
- `rightThread: ThreadedBinaryTree?` is the in-order successor of this node

Now we are ready to go over some of the member functions in our
`ThreadedBinaryTree` class.


## Traversal algorithm

Let's start with the main reason we're using a threaded binary tree.  It is now
very easy to find the in-order predecessor and the in-order successor of any
node in the tree.  If the node has no left/right child, we can simply return
the node's leftThread/rightThread.  Otherwise, it is trivial to move down the
tree and find the correct node.

```swift
  func predecessor() -> ThreadedBinaryTree<T>? {
    if let left = left {
      return left.maximum()
    } else {
      return leftThread
    }
  }

  func successor() -> ThreadedBinaryTree<T>? {
    if let right = right {
      return right.minimum()
    } else {
      return rightThread
    }
  }
```
> Note: `maximum()` and `minimum()` are methods of `ThreadedBinaryTree` which
return the largest/smallest node in a given sub-tree.  See
[the implementation](ThreadedBinaryTree.swift) for more detail.

Because these are `ThreadedBinaryTree` methods, we can call
`node.predecessor()` or `node.successor()` to obtain the predecessor or
successor of any `node`, provided that `node` is a `ThreadedBinaryTree` object.

Because predecessors and/or successors are tracked, an in-order traversal of a
threaded binary tree is much more efficient than the recursive algorithm
outlined above.  We use these predecessor/successor attributes to great effect
in this new algorithm for both forward and backward traversals:

```swift
func traverseInOrderForward(visit: T -> Void) {
  var n: ThreadedBinaryTree
  n = minimum()
  while true {
    visit(n.value)
    if let successor = n.successor() {
      n = successor
    } else {
      break
    }
  }
}

func traverseInOrderBackward(visit: T -> Void) {
  var n: ThreadedBinaryTree
  n = maximum()
  while true {
    visit(n.value)
    if let predecessor = n.predecessor() {
      n = predecessor
    } else {
      break
    }
  }
}
```
Again, this a method of `ThreadedBinaryTree`, so we'd call it like
`node.traverseInorderForward(visitFunction)`.  Note that we are able to specify
a function that executes on each node as they are visited.  This function can
be anything you want, as long as it accepts `T` (the type of the values of the
nodes of the tree) and has no return value.


## Insertion and deletion

The quick in-order traversal that a threaded binary trees gives us comes at a
small cost.  Inserting/deleting nodes becomes more complicated, as we have to
continuously manage the `leftThread` and `rightThread` variables.  It is best
to explain this with an example.  Please note that this requires knowledge of
binary search trees, so make sure you have
[read this first](../Binary Search Tree/).

Base:

![Base](/Images/Base.png)

Insert1:

![Insert1](/Images/Insert1.png)

Insert2:

![Insert2](/Images/Insert2.png)

Insert3:

![Insert3](/Images/Insert3.png)

Remove1:

![Remove1](/Images/Remove1.png)

Remove2:

![Remove2](/Images/Remove2.png)

Remove3:

![Remove3](/Images/Remove3.png)

Remove4:

![Remove4](/Images/Remove4.png)



### Still under construction.

## See also 

[Threaded Binary Tree on Wikipedia](https://en.wikipedia.org/wiki/Threaded_binary_tree).

*Written for the Swift Algorithm Club by
[Jayson Tung](https://github.com/JFTung)*
