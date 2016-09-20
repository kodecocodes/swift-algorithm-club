# Red-Black Tree

A Red-Black tree is a special version of a [Binary Search  Tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Binary%20Search%20Tree). Binary search trees(BSTs) can become unbalanced after a lot of insertions/deletions. The only difference between a node from a BST and a Red-Black Tree(RBT) is that RBT nodes have a color property added to them which can either be red or black. A RBT rebalances itself by making sure the following properties hold:

## Properties
1. A node is either red or black
2. The root is always black
3. All leaves are black
4. If a node is red, both of its children are black
5. Every path to a leaf contains the same number of black nodes (The amount of black nodes met when going down a RBT is called the black-depth of the tree.)

## Methods
* `insert(_ value: T)` inserts the value into the tree
* `insert(_ values: [T])` inserts an array of values into the tree
* `delete(_ value: T)` deletes the value from the tree
* `find(_ value: T) -> RBTNode<T>` looks for a node in the tree with given value and returns it
* `minimum(n: RBTNode<T>) -> RBTNode<T>` looks for the maximum value of a subtree starting at the given node
* `maximum(n: RBTNode<T>) -> RBTNode<T>` looks for the minimum value of a subtree starting at the given node
* `func verify()` verifies if the tree is still valid. Prints warning messages if this is not the case

## Rotation

In order to rebalance their nodes RBTs use an operation known as rotation. You can either left or right rotate a node and its child. Rotating a node and its child swaps the nodes and interchanges their subtrees. Left rotation swaps the parent node with its right child. while right rotation swaps the parent node with its left child.

Left rotation:
```
before left rotating p       after left rotating p  
     p                         b
   /   \                     /   \
  a     b          ->       p     n
 / \   / \                 / \   
n   n  n  n               a   n
                         / \
                        n   n
```
Right rotation:
```
before right rotating p       after right rotating p  
     p                         a
   /   \                     /   \
  a     b          ->       n     p
 / \   / \                       / \   
n   n  n  n                     n   b
                                   / \
                                  n   n
```

## Insertion

We create a new node with the value to be inserted into the tree. The color of this new node is always red.
We perform a standard BST insert with this node. Now the three might not be a valid RBT anymore.
We now go through several insertion steps in order to make the tree valid again. We call the just inserted node n.
1. We check if n is the rootNode, if so we paint it black and we are done. If not we go to step 2.

We now know that n at least has a parent as it is not the rootNode.

2. We check if the parent of n is black if so we are done. If not we go to step 3.

We now know the parent is also not the root node as the parent is red. Thus n also has a grandparent and thus also an uncle as every node has two children. This uncle may however be a nullLeaf

3. We check if n's uncle is red. If not we go to 4. If n's uncle is indeed red we recolor uncle and parent to black and n's grandparent to red. We now go back to step 1 performing the same logic on n's grandparent.

From here there are four cases:
- **The left left case.** n's parent is the left child of its parent and n is the left child of its parent.
- **The left right case** n's parent is the left child of its parent and n is the right child of its parent.
- **The right right case** n's parent is the right child of its parent and n is the right child of its parent.
- **The right left case** n's parent is the right child of its parent and n is the left child of its parent.

4. Step 4 checks if either the **left right** case or the **right left** case applies to the current situation.
  - If we find the **left right case**, we left rotate n's parent and go to step 5 while setting n to n's parent. (This transforms the **left right** case into the **left left** case)
  - If we find the **right left case**, we right rotate n's parent and go to step 5 while setting n to n's parent. (This transforms the **right left** case into the **right right** case)
  - If we find neither of these two we proceed to step 5.

n's parent is now red, while n's grandparent is black.

5. We swap the colors of n's parent and grandparent.
  - We either right rotate n's grandparent in case of the **left left** case
  - Or we left rotate n's grandparent in case of the **right right** case

Reaching the end we have successfully made the tree valid again.

# Deletion

Deletion is a little more complicated than insertion. In the following we call del the node to be deleted.
First we try and find the node to be deleted using find()
we send the result of find to del.
We now go through the following steps in order to delete the node del.

First we do a few checks:
- Is del the rootNode if so set the root to a nullLeaf and we are done.
- If del has 2 nullLeaf children and is red. We check if del is either a left or a right child and set del's parent left or right to a nullLeaf.
- If del has two non nullLeaf children we look for the maximum value in del's left subtree. We set del's value to this maximum value and continue to instead delete this maximum node. Which we will now call del.

Because of these checks we now know that del has at most 1 non nullLeaf child. It has either two nullLeaf children or one nullLeaf and one regular red child. (The child is red otherwise the black-depth wouldn't be the same for every leaf)

We now call the non nullLeaf child of del, child. If del has two nullLeaf children child will be a nullLeaf. This means child can either be a nullLeaf or a red node.

We now have three options

- If del is red its child is a nullLeaf and we can just delete it as it doesn't change the black-depth of the tree. We are done

- If child is red we recolor it black and child's parent to del's parent. del is now deleted and we are done.

- Both del and child are black we go through

If both del and child are black we introduce a new variable sibling. Which is del's sibling. We also replace del with child and recolor it doubleBlack. del is now deleted and child and sibling are siblings.

We now have to go through a lot of steps in order to remove this doubleBlack color. Which are hard to explain in text without just writing the full code in text. This is due the many possible combination of nodes and colors. The code is commented, but if you don't quite understand please leave me a message. Also part of the deletion is described by the final link in the Also See section.

## Also see

* [Wikipedia](https://en.wikipedia.org/wiki/Red–black_tree)
* [GeeksforGeeks - introduction](http://www.geeksforgeeks.org/red-black-tree-set-1-introduction-2/)
* [GeeksforGeeks - insertion](http://www.geeksforgeeks.org/red-black-tree-set-2-insert/)
* [GeeksforGeeks - deletion](http://www.geeksforgeeks.org/red-black-tree-set-3-delete-2/)

Important to note is that GeeksforGeeks doesn't mention a few deletion cases that do occur. The code however does implement these.

*Written for Swift Algorithm Club by Jaap Wijnen. Updated from Ashwin Raghuraman's contribution.*
