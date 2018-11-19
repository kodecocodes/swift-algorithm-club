# Red-Black Tree

A red-black tree (RBT) is a balanced version of a [Binary Search Tree](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Binary%20Search%20Tree) guaranteeing that the basic operations (search, predecessor, successor, minimum, maximum, insert and delete) have a logarithmic worst case performance.

Binary search trees (BSTs) have the disadvantage that they can become unbalanced after some insert or delete operations. In the worst case, this could lead to a tree where the nodes build a linked list as shown in the following example:

```
a
  \
   b
    \
     c
      \
       d
```
To prevent this issue, RBTs perform rebalancing operations after an insert or delete and store an additional color property at each node which can either be red or black. After each operation a RBT satisfies the following properties:

## Properties

1. Every node is either red or black
2. The root is black
3. Every leaf (nullLeaf) is black
4. If a node is red, then both its children are black
5. For each node, all paths from the node to descendant leaves contain the same number of black nodes

Property 5 includes the definition of the black-height of a node x, bh(x), which is the number of black nodes on a path from this node down to a leaf not counting the node itself.
From [CLRS]

## Methods

Nodes:
* `nodeX.getSuccessor()` Returns the inorder successor of nodeX
* `nodeX.minimum()` Returns the node with the minimum key of the subtree of nodeX
* `nodeX.maximum()` Returns the node with the maximum key of the subtree of nodeX
Tree:
* `search(input:)` Returns the node with the given key value
* `minValue()` Returns the minimum key value of the whole tree
* `maxValue()` Returns the maximum key value of the whole tree
* `insert(key:)` Inserts the key value into the tree
* `delete(key:)` Delete the node with the respective key value from the tree
* `verify()` Verifies that the given tree fulfills the red-black tree properties

The rotation, insertion and deletion algorithms are implemented based on the pseudo-code provided in [CLRS]

## Implementation Details

For convenience, all nil-pointers to children or the parent (except the parent of the root) of a node are exchanged with a nullLeaf. This is an ordinary node object, like all other nodes in the tree, but with a black color, and in this case a nil value for its children, parent and key. Therefore, an empty tree consists of exactly one nullLeaf at the root.

## Rotation

Left rotation (around x):
Assumes that x.rightChild y is not a nullLeaf, rotates around the link from x to y, makes y the new root of the subtree with x as y's left child and y's left child as x's right child, where n = a node, [n] = a subtree
```
      |                |
      x                y
    /   \     ~>     /   \
  [A]    y          x    [C]
        / \        / \
      [B] [C]    [A] [B]
```
Right rotation (around y):
Assumes that y.leftChild x is not a nullLeaf, rotates around the link from y to x, makes x the new root of the subtree with y as x's right child and x's right child as y's left child, where n = a node, [n] = a subtree
```
      |                |
      x                y
    /   \     <~     /   \
  [A]    y          x    [C]
        / \        / \
      [B] [C]    [A] [B]
```
As rotation is a local operation only exchanging pointers it's runtime is O(1).

## Insertion

We create a node with the given key and set its color to red. Then we insert it into the the tree by performing a standard insert into a BST. After this, the tree might not be a valid RBT anymore, so we fix the red-black properties by calling the insertFixup algorithm.
The only violation of the red-black properties occurs at the inserted node z and its parent. Either both are red, or the parent does not exist (so there is a violation since the root must be black).
We have three distinct cases:
**Case 1:** The uncle of z is red. If z.parent is left child, z's uncle is z.grandparent's right child. If this is the case, we recolor and move z to z.grandparent, then we check again for this new z. In the following cases, we denote a red node with (x) and a black node with {x}, p = parent, gp = grandparent and u = uncle
```
         |                   |
        {gp}               (newZ)
       /    \     ~>       /    \
    (p)     (u)         {p}     {u}
    / \     / \         / \     / \
  (z)  [C] [D] [E]    (z) [C] [D] [E]
  / \                 / \
[A] [B]             [A] [B]

```
**Case 2a:** The uncle of z is black and z is right child. Here, we move z upwards, so z's parent is the newZ and then we rotate around this newZ. After this, we have Case 2b.
```
         |                   |
        {gp}                {gp}
       /    \     ~>       /    \
    (p)      {u}         (z)     {u}
    / \      / \         / \     / \
  [A]  (z)  [D] [E]  (newZ) [C] [D] [E]
       / \            / \
     [B] [C]        [A] [B]

```
**Case 2b:** The uncle of z is black and z is left child. In this case, we recolor z.parent to black and z.grandparent to red. Then we rotate around z's grandparent. Afterwards we have valid red-black tree.
```
         |                   |
        {gp}                {p}
       /    \     ~>       /    \
    (p)      {u}         (z)    (gp)
    / \      / \         / \     / \
  (z)  [C] [D] [E]    [A] [B]  [C]  {u}
  / \                               / \
[A] [B]                           [D] [E]

```
Running time of this algorithm: 
* Only case 1 may repeat, but this only h/2 steps, where h is the height of the tree
* Case 2a -> Case 2b -> red-black tree
* Case 2b -> red-black tree
As we perform case 1 at most O(log n) times and all other cases at most once, we have O(log n) recolorings and at most 2 rotations. 
The overall runtime of insert is O(log n).

## Deletion

We search for the node with the given key, and if it exists we delete it by performing a standard delete from a BST. If the deleted nodes' color was red everything is fine, otherwise red-black properties may be violated so we call the fixup procedure deleteFixup.
Violations can be that the parent and child of the deleted node x where red, so we now have two adjacent red nodes, or if we deleted the root, the root could now be red, or the black height property is violated.
We have 4 cases: We call deleteFixup on node x
**Case 1:** The sibling of x is red. The sibling is the other child of x's parent, which is not x itself. In this case, we recolor the parent of x and x.sibling then we left rotate around x's parent. In the following cases s = sibling of x, (x) = red, {x} = black, |x| = red/black.
```
        |                   |
       {p}                 {s}
      /    \     ~>       /    \
    {x}    (s)         (p)     [D]
    / \    / \         / \     
  [A] [B] [C] [D]    {x} [C]
                     / \  
                   [A] [B]

```
**Case 2:** The sibling of x is black and has two black children. Here, we recolor x.sibling to red, move x upwards to x.parent and check again for this newX.
```
        |                    |
       |p|                 |newX|
      /    \     ~>       /     \
    {x}     {s}          {x}     (s)
    / \    /   \          / \   /   \
  [A] [B] {l}  {r}     [A] [B] {l}  {r}
          / \  / \             / \  / \
        [C][D][E][F]         [C][D][E][F]

```
**Case 3:** The sibling of x is black with one black child to the right. In this case, we recolor the sibling to red and sibling.leftChild to black, then we right rotate around the sibling. After this we have case 4.
```
        |                    |
       |p|                  |p|
      /    \     ~>       /     \
    {x}     {s}          {x}     {l}
    / \    /   \         / \    /   \
  [A] [B] (l)  {r}     [A] [B] [C]  (s)
          / \  / \                  / \
        [C][D][E][F]               [D]{e}
                                      / \
                                    [E] [F]

```
**Case 4:** The sibling of x is black with one red child to the right. Here, we recolor the sibling to the color of x.parent and x.parent and sibling.rightChild to black. Then we left rotate around x.parent. After this operation we have a valid red-black tree. Here, ||x|| denotes that x can have either color red or black, but that this can be different to |x| color. This is important, as s gets the same color as p.
```
        |                        |
       ||p||                   ||s||
      /    \     ~>           /     \
    {x}     {s}              {p}     {r}
    / \    /   \            /  \     /  \
  [A] [B] |l|  (r)        {x}  |l|  [E] [F]
          / \  / \        / \  / \
        [C][D][E][F]    [A][B][C][D]

```
Running time of this algorithm:
* Only case 2 can repeat, but this only h many times, where h is the height of the tree
* Case 1 -> case 2 -> red-black tree
  Case 1 -> case 3 -> case 4 -> red-black tree
  Case 1 -> case 4 -> red-black tree
* Case 3 -> case 4 -> red-black tree
* Case 4 -> red-black tree
As we perform case 2 at most O(log n) times and all other steps at most once, we have O(log n) recolorings and at most 3 rotations.
The overall runtime of delete is O(log n).

## Resources:
[CLRS]  T. Cormen, C. Leiserson, R. Rivest, and C. Stein. "Introduction to Algorithms", Third Edition. 2009

*Written for Swift Algorithm Club by Ute Schiehlen. Updated from Jaap Wijnen and Ashwin Raghuraman's contributions. Swift 4.2 check by Bruno Scheele.*
