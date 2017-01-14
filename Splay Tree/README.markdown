# Splay Tree

A splay tree is a type of balanced binary search tree.  Structurally, it is identical to an ordinary binary search tree; the only difference is in the algorithms for finding, inserting, and deleting entries.

All splay tree operations run in O(log n) amortized time, where n is the number of entries in the tree.

Splay trees are designed to give especially fast access to entries that have been accessed recently, so they really excel in applications where a small fraction of the entries are the targets of most of the find operations.

## Advantages

Whenever an element is looked up in the tree, the splay tree reorganizes to move that element to the root of the tree, without breaking the binary search tree invariant. If the next lookup request is for the same element, it can be returned immediately. In general, if a small number of elements are being heavily used, they will tend to be found near the top of the tree and are thus found quickly.

## Disadvantages

The most significant disadvantage of splay trees is that the height of a splay tree can be linear. For example, this will be the case after accessing all n elements in non-decreasing order. Since the height of a tree corresponds to the worst-case access time, this means that the actual cost of an operation can be high.

The representation of splay trees can change even when they are accessed in a 'read-only' manner (i.e. by find operations). This complicates the use of such splay trees in a multi-threaded environment.

## Operations

#### Rotations
Like many types of balanced search trees, splay trees are kept balanced with the help of structural changes called _rotations_. There are two types

- Left Rotation
- Right Rotation

```
e.g.
     Y                             X     
    / \        rotate left        / \    
   X   ^      <------------      ^   Y   
  / \ /C\                       /A\ / \  
 ^  ^         ------------>         ^  ^
/A\/B\         rotate right        /B\/C\

```

Each is the other's reverse. Suppose that X and Y are binary tree nodes, and A, B, and C are subtrees.  A rotation transforms either of the configurations illustrated above to the other.  Observe that the binary search tree invariant is preserved:  keys in A are less than or equal to X; keys in C are greater than or equal to Y; and keys in B are >= X and <= Y.

Splay trees are not kept perfectly balanced, but they tend to stay reasonably well-balanced most of the time, thereby averaging O(log n) time per operation in the worst case (and sometimes achieving O(1) average running time in special cases).

#### Splay

The _find_ operation in a splay tree begins just like the _find_ operation in an ordinary binary search tree:  we walk down the tree until we find the entry with key k, or reach a dead end (a node from which the next logical step leads to a null pointer).

We _splay_ X up the tree
through a sequence of rotations, so that X becomes the root of the tree.  Why?
One reason is so that recently accessed entries are near the root of the tree,
and if we access the same few entries repeatedly, accesses will be very fast.
Another reason is because if X lies deeply down an unbalanced branch of the
tree, the splay operation will improve the balance along that branch.

When we splay a node to the root of the tree, there are three cases that determine the rotations we use.

###### 1 - X is the right child of a left child (or the left child of a right child):
Let P be the parent of X, and let G be the grandparent of X. We first rotate X and P left, and then rotate X and G right, as illustrated below. This is called the Zig-Zag case.

```
Zig-Zag

     G               G               X     
    / \             / \             / \    
   P   ^           X   ^           P   G   
  / \ /D\  ==>    / \ /D\  ==>    / \ / \  
 ^  X            P  ^            ^  ^ ^  ^
/A\/ \          / \/C\          /A\/BVC\/D\
   ^  ^        ^  ^                        
  /B\/C\      /A\/B\
```
The mirror image of this case--
where X is a left child and P is a right child uses the same rotations in mirror image:  rotate X and P right, then X and G left.  Both the case illustrated above and its mirror image are called the "zig-zag" case.

###### 2 - X is the left child of a left child (or the right child of a right child):
The ORDER of the rotations is REVERSED from case 1.
We start with the grandparent, and rotate G and P right. Then, we rotate P and X right.
```
Zig-Zig

       G               P               X       
      / \             / \             / \      
     P   ^           X   G           ^   P     
    / \ /D\  ==>    / \ / \    ==>  /A\ / \    
   X  ^            ^  ^ ^  ^            ^  G   
  / \/C\          /A\/BVC\/D\          /B\/ \  
 ^  ^                                     ^  ^
/A\/B\                                   /C\/D\

```
The mirror image of this case--
where X and P are both right children--uses the same rotations in mirror image:
rotate G and P left, then P and X left.  Both the case illustrated above and
its mirror image are called the "zig-zig" case.

We repeatedly apply zig-zag and zig-zig rotations to X; each pair of rotations
raises X two levels higher in the tree.  Eventually, either X will reach the
root (and we're done), or X will become the child of
the root.  One more case handles the latter circumstance.

###### 3 - X's parent P is the root:  
We rotate X and P so that X becomes the root.
This is called the "zig" case.
```
Zig
     P             X     
    / \           / \    
   X   ^         ^   P   
  / \ /C\  ==>  /A\ / \  
 ^  ^               ^  ^
/A\/B\             /B\/C\

```

```
Here's an example of "find(7)".
Note how the tree's balance improves.

    11                     11                      11                  [7]     
   /  \                   /  \                    /  \                 / \     
  1    12                1    12                [7]   12              1   11   
 / \                    / \                     / \                  /\   / \  
0   9                  0   9                   1   9                0 5   9  12
   / \                    / \                 / \ / \                / \ / \   
  3   10  =zig-zig=>    [7]  10  =zig-zag=>  0  5 8  10   =zig=>    3  6 8  10
 / \                    / \                    / \                 / \         
2   5                  5   8                  3   6               2   4        
   / \                / \                    / \                 
  4  [7]             3   6                  2   4                
     / \            / \                                                      
    6   8          2   4                                                     

```
#### Find
The find operation in a splay tree begins just like the find operation in an ordinary binary search tree: we walk down the tree until we find the entry with key k, or reach a dead end. Let X be the node where the search ended. Then we _splay_ the tree at X, so that X becomes the root of the tree.

#### Join
Given two trees S and T such that all elements of S are smaller than the elements of T, the following steps can be used to join them to a single tree:

1. Splay the largest item in S. Now this item is in the root of S and has a null right child.
2. Set the right child of the new root to T.

#### Deletion
1. The node to be deleted is first splayed, i.e. brought to the root of the tree and then deleted. This leaves the tree with two sub trees.
2. The two sub-trees are then joined using a "join" operation.

## See also
[Splay Tree Visualization](https://www.cs.usfca.edu/~galles/visualization/SplayTree.html)
