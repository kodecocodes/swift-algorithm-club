# Binary Search Tree (BST)

A binary search tree is a special kind of [binary tree](../Binary Tree/) (a tree in which a node only has two children) that performs insertions in a special way such that the tree is always sorted.

## "Always sorted" property

When performing an insertion, the tree will check the value of the *key* for a node and compare it to the *key* for the soon-to-be-inserted value. It will go down the tree until there's an empty leaf, following the rule that if the new value is smaller than the existant one, it will be inserted to the left of the existant node. Otherwise, it will be to the right of it.

Let's look at an example:

```
      (7)
     /   \
   (2)   (10)
  /   \
(1)   (5)
```

Notice how each left child is smaller than its parent node, and each right child is greater than its parent node. For example, `2` is smaller than `7` so it goes on the left; `5` is greater than `2` so it goes on the right.

Say we want to insert the new value `9`:

- We start at the root of the tree (the node with the value `7`) and compare it to the new value `9`.
- We see that `9 > 7`, so we go down the *right* branch of that node and perform the same procedure: check against the key, but this time `9 < 10`, so we go down the *left* branch.
- We've now arrived to a point in which there are no more values to compare with, so the value `9` is inserted at that location, going first right and then left from the root.

The tree now looks like this:

```
        (7)
      /     \
   (2)      (10)
  /   \      /
(1)   (5)  (9)
```

By following this simple rule, we keep the tree sorted in a way that, whenever we query it, we can quickly check if a value is in the tree or get such value.

## Searching the tree

[TBD: explain how you'd search the tree and why it is fast; compare with the binary search article]

## Deletion

TBD

## The code

[TBD: explain how you've implemented the tree in Swift]

## Disadvantages

If the tree is not *balanced*, that is, one branch is significantly longer than the other, then queries would suffer performance issues, having to check more values on one branch than it would if the tree were optimally balanced.

Balanced trees guarantee that the longest branch of the tree will be at most 1 node longer than the rest, otherwise the tree will balance itself on insertion.

Another issue arises from the insertion of increasing or decreasing values, in which the tree would be massively unbalanced with just one long branch, and all child nodes branching in the same direction.

## See also

[Binary Search Tree on Wikipedia](https://en.wikipedia.org/wiki/Binary_search_tree)

*Written for the Swift Algorithm Club by [Nicolas Ameghino](http://www.github.com/nameghino).*
