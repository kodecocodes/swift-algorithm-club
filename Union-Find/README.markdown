# Union-Find

Union-Find is a data structure that can keep track of a set of elements partitioned into a number of disjoint (non-overlapping) subsets. It is also known as disjoint-set data structure.

What do we mean by this? For example, the Union-Find data structure could be keeping track of the following sets:

	[ a, b, f, k ]
	[ e ]
	[ g, d, c ]
	[ i, j ]

These sets are disjoint because they have no members in common.

Union-Find supports three basic operations:

1. **Find(A)**: Determine which subset an element **A** is in. For example, `find(d)` would return the subset `[ g, d, c ]`.

2. **Union(A, B)**: Join two subsets that contain **A** and **B** into a single subset. For example, `union(d, j)` would combine `[ g, d, c ]` and `[ i, j ]` into the larger set `[ g, d, c, i, j ]`.

3. **AddSet(A)**: Add a new subset containing just that element **A**. For example, `addSet(h)` would add a new set `[ h ]`.

The most common application of this data structure is keeping track of the connected components of an undirected [graph](../Graph/). It is also used for implementing an efficient version of Kruskal's algorithm to find the minimum spanning tree of a graph.

## Implementation

Union-Find can be implemented in many ways but we'll look at the most efficient.

```swift
public struct UnionFind<T: Hashable> {
  private var index = [T: Int]()
  private var parent = [Int]()
  private var size = [Int]()
}
```

Our Union-Find data structure is actually a forest where each subset is represented by a [tree](../Tree/).

For our purposes we only need to keep track of the parent of each tree node, not the node's children. To do this we use the array `parent` so that `parent[i]` is the index of node `i`'s parent.

Example: If `parent` looks like this,

	parent [ 1, 1, 1, 0, 2, 0, 6, 6, 6 ]
	     i   0  1  2  3  4  5  6  7  8

then the tree structure looks like:

	      1              6
	    /   \           / \
	  0       2        7   8
	 / \     /
	3   5   4

There are two trees in this forest, each of which corresponds to one set of elements. (Note: due to the limitations of ASCII art the trees are shown here as binary trees but that is not necessarily the case.)

We give each subset a unique number to identify it. That number is the index of  the root node of that subset's tree. In the example, node `1` is the root of the first tree and `6` is the root of the second tree.

So in this example we have two subsets, the first with the label `1` and the second with the label `6`. The **Find** operation actually returns the set's label, not its contents.

Note that the `parent[]` of a root node points to itself. So `parent[1] = 1` and `parent[6] = 6`. That's how we can tell something is a root node.

## Add set

Let's look at the implementation of these basic operations, starting with adding a new set.

```swift
public mutating func addSetWith(_ element: T) {
  index[element] = parent.count  // 1
  parent.append(parent.count)    // 2
  size.append(1)                 // 3
}
```

When you add a new element, this actually adds a new subset containing just that element.

1. We save the index of the new element in the `index` dictionary. That lets us look up the element quickly later on.

2. Then we add that index to the `parent` array to build a new tree for this  set. Here, `parent[i]` is pointing to itself because the tree that represents the new set contains only one node, which of course is the root of that tree.

3. `size[i]` is the count of nodes in the tree whose root is at index `i`. For the new set this is 1 because it only contains the one element. We'll be using the `size` array in the Union operation.

## Find

Often we want to determine whether we already have a set that contains a given element. That's what the **Find** operation does. In our `UnionFind` data structure it is called `setOf()`:

```swift
public mutating func setOf(_ element: T) -> Int? {
  if let indexOfElement = index[element] {
    return setByIndex(indexOfElement)
  } else {
    return nil
  }
}
```

This looks up the element's index in the `index` dictionary and then uses a helper method to find the set that this element belongs to:

```swift
private mutating func setByIndex(_ index: Int) -> Int {
  if parent[index] == index {  // 1
    return index
  } else {
    parent[index] = setByIndex(parent[index])  // 2
    return parent[index]       // 3
  }
}
```

Because we're dealing with a tree structure, this is a recursive method.

Recall that each set is represented by a tree and that the index of the root node serves as the number that identifies the set. We're going to find the root node of the tree that the element we're searching for belongs to, and return its index.

1. First, we check if the given index represents a root node (i.e. a node whose `parent` points back to the node itself). If so, we're done.

2. Otherwise we recursively call this method on the parent of the current node. And then we do a **very important thing**: we overwrite the parent of the current node with the index of root node, in effect reconnecting the node directly to the root of the tree. The next time we call this method, it will execute faster because the path to the root of the tree is now much shorter. Without that optimization, this method's complexity is **O(n)** but now in combination with the size optimization (covered in the Union section) it is almost **O(1)**.

3. We return the index of the root node as the result.

Here's illustration of what I mean. Let's say the tree looks like this:

![BeforeFind](Images/BeforeFind.png)

We call `setOf(4)`. To find the root node we have to first go to node `2` and then to node `7`. (The indexes of the elements are marked in red.)

During the call to `setOf(4)`, the tree is reorganized to look like this:

![AfterFind](Images/AfterFind.png)

Now if we need to call `setOf(4)` again, we no longer have to go through node `2` to get to the root. So as you use the Union-Find data structure, it optimizes itself. Pretty cool!

There is also a helper method to check that two elements are in the same set:

```swift
public mutating func inSameSet(_ firstElement: T, and secondElement: T) -> Bool {
  if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
    return firstSet == secondSet
  } else {
    return false
  }
}
```

Since this calls `setOf()` it also optimizes the tree.

## Union

The final operation is **Union**, which combines two sets into one larger set.

```swift
public mutating func unionSetsContaining(_ firstElement: T, and secondElement: T) {
  if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {  // 1
    if firstSet != secondSet {               // 2
      if size[firstSet] < size[secondSet] {  // 3
        parent[firstSet] = secondSet         // 4
        size[secondSet] += size[firstSet]    // 5
      } else {
        parent[secondSet] = firstSet
        size[firstSet] += size[secondSet]
      }
    }
  }
}
```

Here is how it works:

1. We find the sets that each element belongs to. Remember that this gives us two integers: the indices of the root nodes in the `parent` array.

2. Check that the sets are not equal because if they are it makes no sense to union them.

3. This is where the size optimization comes in. We want to keep the trees as shallow as possible so we always attach the smaller tree to the root of the larger tree. To determine which is the smaller tree we compare trees by their sizes.

4. Here we attach the smaller tree to the root of the larger tree.

5. Update the size of larger tree because it just had a bunch of nodes added to it.

An illustration may help to better understand this. Let's say we have these two sets, each with its own tree:

![BeforeUnion](Images/BeforeUnion.png)

Now we call `unionSetsContaining(4, and: 3)`. The smaller tree is attached to the larger one:

![AfterUnion](Images/AfterUnion.png)

Note that, because we call `setOf()` at the start of the method, the larger tree was also optimized in the process -- node `3` now hangs directly off the root.

Union with optimizations also takes almost **O(1)** time.

## See also

See the playground for more examples of how to use this handy data structure.

[Union-Find at Wikipedia](https://en.wikipedia.org/wiki/Disjoint-set_data_structure)

*Written for Swift Algorithm Club by [Artur Antonov](https://github.com/goingreen)*
