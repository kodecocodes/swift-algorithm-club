# Union-Find data structure

Union-Find data structure (also known as disjoint-set data structure) is data structure that can keep track of a set of elements partitioned into a number of disjoint (non-overlapping) subsets. It supports three basic operations:
  1. Find(**A**): Determine which subset an element **A** is in
  2. Union(**A**, **B**): Join two subsets that contain **A** and **B** into a single subset
  3. AddSet(**A**): Add a new subset containing just that element **A**

The most common application of this data structure is keeping track of the connected components of an undirected graph. It is also used for implementing efficient version of Kruskal's algorithm to find the minimum spanning tree of a graph.

## Implementation

Union-Find can be implemented in many ways but we'll look at the most efficient.

Every Union-Find data structure is just value of type `UnionFind`

```swift
public struct UnionFind<T: Hashable> {
  private var index = [T:Int]()
  private var parent = [Int]()
  private var size = [Int]()
}
```

Our Union-Find data structure is actually a forest where each subset represented by a [tree](../Tree/). For our purposes we only need to keep parent of each node. To do this we use array `parent` where `parent[i]` is index of parent of node with number **i**. In a that forest, the unique number of each subset is the index of value of root of that subset's tree.

So let's look at the implementation of basic operations:

### Add set

```swift
public mutating func addSetWith(element: T) {
  index[element] = parent.count  // 1
  parent.append(parent.count)  //2
  size.append(1)  // 3
}
```

1. We save index of new element in `index` dictionary because we need `parent` array only containing values in range 0..<parent.count.

2. Then we add that index to `parent` array. It's pointing itself because the tree that represent new set containing only one node which obviously is a root of that tree.

3. `size[i]` is a count of nodes in tree which root is node with number `i` We'll be using that in Union method.


### Find

```swift
private mutating func setByIndex(index: Int) -> Int {
  if parent[index] == index {  // 1
    return index
  } else {
    parent[index] = setByIndex(parent[index])  // 2
    return parent[index]  // 3
  }
}

public mutating func setOf(element: T) -> Int? {
  if let indexOfElement = index[element] {
    return setByIndex(indexOfElement)
  } else {
    return nil
  }
}
```

`setOf(element: T)` is a helper method to get index corresponding to `element` and if it exists we return value of actual method `setByIndex(index: Int)`

1. First, we check if current index represent a node that is root. That means we find number that represent the set of element we search for.

2. Otherwise we recursively call our method on parent of current node. And then we do **very important thing**: we cache index of root node, so when we call this method again it will executed faster because of cached indexes. Without that optimization method's complexity is **O(n)** but now in combination with the size optimization (I'll cover that in Union section) it is almost **O(1)**.

3. We return our cached root as result.

Here's illustration of what I mean

Before first call `setOf(4)`:

![BeforeFind](Images/BeforeFind.png)

After:

![AfterFind](Images/AfterFind.png)

Indexes of elements are marked in red.


### Union

```swift
public mutating func unionSetsContaining(firstElement: T, and secondElement: T) {
  if let firstSet = setOf(firstElement), secondSet = setOf(secondElement) {  // 1
    if firstSet != secondSet {  // 2
      if size[firstSet] < size[secondSet] {  // 3
        parent[firstSet] = secondSet  // 4
        size[secondSet] += size[firstSet]  // 5
      } else {
        parent[secondSet] = firstSet
        size[firstSet] += size[secondSet]
      }
    }
  }
}
```

1. We find sets of each element.

2. Check that sets are not equal because if they are it makes no sense to union them.

3. This is where our size optimization comes in. We want to keep trees as small as possible so we always attach the smaller tree to the root of the larger tree. To determine small tree we compare trees by its sizes.

4. Here we attach the smaller tree to the root of the larger tree.

5. We keep sizes of trees in actual states so we update size of larger tree.

Union with optimizations also takes almost **O(1)** time.

As always, some illustrations for better understanding

Before calling `unionSetsContaining(4, and: 3)`:

![BeforeUnion](Images/BeforeUnion.png)

After:

![AfterUnion](Images/AfterUnion.png)

Note that during union caching optimization was performed because of calling `setOf` in the beginning of method.



There is also helper method to just check that two elements is in the same set:

```swift
public mutating func inSameSet(firstElement: T, and secondElement: T) -> Bool {
  if let firstSet = setOf(firstElement), secondSet = setOf(secondElement) {
    return firstSet == secondSet
  } else {
    return false
  }
}
```


See the playground for more examples of how to use this handy data structure.


## See also

[Union-Find at wikipedia](https://en.wikipedia.org/wiki/Disjoint-set_data_structure)

*Written for Swift Algorithm Club by [Artur Antonov](https://github.com/goingreen)*
