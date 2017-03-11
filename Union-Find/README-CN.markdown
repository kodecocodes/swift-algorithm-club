# 联合查找

联合查找是一种可以追踪一组被分成一些不相交（没有重叠）的子集的数据结构。也叫做不相交集数据结构。

我们说的是什么意思呢？例如，联合查找的数据结构可以是追踪下面这些集合：

	[ a, b, f, k ]
	[ e ]
	[ g, d, c ]
	[ i, j ]

这些集合是不相交的，因为他们没有共同的成员。

联合查找支持三个基本的操作：

1. **Find(A)**：找到 **A** 在哪个子集里面。例如，`find(d)` 会返回子集 `[ g, d, c ]`。

2. **Union(A, B)**：将包含 **A** 和 **B** 的子集合并成一个。例如，union(d, j) 会将 `[ g, d, c ]` 和 `[ i, j ]` 合并成一个大的集合 `[ g, d, c, i, j ]`

3. **AddSet(A)**：添加一个只包含元素 **A** 的子集。例如，`addSet(h)` 会添加一个新的集合 `[ h ]`

这个数据结构的最普遍应用是追踪一个无向[图](../Graph/README-CN.markdown) 相连接的部分。它也可以用来实现 Kruskal 算法的一个高效版本，用来找到图的最小生成树。

## 实现

联合查找可以通过多种方式实现，但是我们将看看最有效的。

```swift
public struct UnionFind<T: Hashable> {
  private var index = [T: Int]()
  private var parent = [Int]()
  private var size = [Int]()
}
```

我们的联合查找数据结构实际上是一片森林，每个子集都是由一颗[树](../Tree/README-CN.markdown) 来表示。

对于我们的目的来说，只需要追踪每个树节点的父节点即可，而不需要追踪子节点。我们用了数组 `parent`，`parent[i]` 是节点 `i` 的父节点的索引。

例如：如果 `parent` 是下面这样的：

	parent [ 1, 1, 1, 0, 2, 0, 6, 6, 6 ]
	     i   0  1  2  3  4  5  6  7  8

树的结构就是这样的：

	      1              6
	    /   \           / \
	  0       2        7   8
	 / \     /
	3   5   4

在这个森林里有两棵树，每棵树各自对应一个元素的集合。（注意：由于 ASCII 的局限性，树是以二叉树的形式展示的，但这不一定非得是这样的。）

给定一个唯一的数字来表示每个子集。这个数字就是子集树的根节点的索引。在上面的例子中，节点 `1` 是第一棵树的根节点，`6` 是第二棵树的根节点。

所以在例子中，我们有两个子集，第一个的标签是 `1`，第二个的标签是 `6`。**Find** 操作实际上是返回集合的标签，而不是它的内容。

根节点的 `parent()` 指向的是自己。所以 `parent[1] = 1` 和 `parent[6] = 6`。这就是为什么我们能把它叫做根节点的原因。

## 添加集合

Let's look at the implementation of these basic operations, starting with adding a new set.
让我们从添加一个新的结合开始来看看这些基本操作的实现吧。

```swift
public mutating func addSetWith(_ element: T) {
  index[element] = parent.count  // 1
  parent.append(parent.count)    // 2
  size.append(1)                 // 3
}
```

当添加一个元素的时候，实际上是添加了一个只包含这个元素的集合。

1. 在 `index` 字典中保存新元素的索引。这可以让我们再后面更快的找到这个元素。

2. 然后将这个索引添加到 `parent` 数组中来为这个集合建立一棵新的树。在这里，`parent[i]` 指向的是自己，因为代表集合的树只包含一个节点，那么这个节点当然就是树的根节点啦。

3. `size[i]` 是根节点的索引在 `i` 的树的节点的个数。对于这个新的集合来说，它就是 1，因为它只有一个元素。在联合操作中会经常用到 `size` 数组。

## 查找

我们会经常想要知道是否已经有集合包含了某个元素。这就是 **Find** 操作要做的。在我们的 `UnionFind` 数据结构里叫做 `setOf()`：

```swift
public mutating func setOf(_ element: T) -> Int? {
  if let indexOfElement = index[element] {
    return setByIndex(indexOfElement)
  } else {
    return nil
  }
}
```
在 `index` 字典中查找元素的索引，然后使用一个辅助方法来找到这个元素所在的集合：

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

因为我们处理的是树结构，所以这是一个递归方法。

回忆一下，每个集合都是由一棵树来表示的，并且根节点的索引是作为数字来标识集合的。我们先找到要查找的元素所属的树的根节点，然后返回索引。

1. 首先，检查给定的索引是不是一个根节点（例如，节点的 `parent` 指回了节点本身）。如果是的话，我们就完成了。

2. 如果不是的话，我们就对当前节点的父节点递归地调用这个方法 。然后我们就要做一件**非常重要的事**：用根节点的索引覆盖掉当前节点的父节点，实际上是将节点和根节点重新建立一个直接的连接。下次我们调用这个方法的时候，它就会执行的更快，因为到根节点的路径比之前短多了。没有这个优化的话，这个方法的时间复杂度是 **O(n)**，但是现在有了大小优化（在联合部分有介绍），它就接近 **O(1)**了。

3. 将根节点的索引作为结果返回。

下面解释了上面我说的是什么意思。加入树是这样的：

![BeforeFind](Images/BeforeFind.png)

调用 `setOf(4)`。为了找到根节点，我们先要到节点 `2`，然后是 节点 `7`.（元素的索引用红色的标记了）

在调用 `setOf(4)` 的过程中，树会重新被组织成：

![AfterFind](Images/AfterFind.png)

现在加入我们还要再调用 `setOf(4)` 的时候，我们不需要再经过节点 `2` 来到达根节点。所以，当你使用联合查找数据结构的时候，它会自己优化，非常酷！

还有一个辅助方法用来检查两个元素在同一个集合里：

```swift
public mutating func inSameSet(_ firstElement: T, and secondElement: T) -> Bool {
  if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
    return firstSet == secondSet
  } else {
    return false
  }
}
```

因为它调用了 `setOf()`，所以它还会优化这棵树。

## 联合

最后一个操作是 **Union**，联合就是讲两个集合合并成一个大的集合。

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

下面是它如何工作：

1. 先找到每个元素所在的集合。记住，这是给我们提供了两个整数：根节点在 `parent` 数组中的索引。

2. 检查集合是否相等，如果相等的话就没有必要再将它们联合起来了。

3. 这里就是大小优化的地方了。我们想要保持树尽可能的浅，所以我们将小树放到大树的根节点上。我们通过比较两棵树的大小来决定小树是哪个。

4. 将小树放到大树的根节点上。

5. 更新大树的大小，因为有一对节点添加到树上了。

有一个说明可能会帮助我们更好的理解。假如有这样两个集合，每个的树是这样的：

![BeforeUnion](Images/BeforeUnion.png)

现在我们调用 `unionSetsContaining(4, and: 3)`。小树会被加到大树上：

![AfterUnion](Images/AfterUnion.png)

注意到，因为我们在方法开始的时候调用了 `setOf()`，大树在这个过程中也被优化了 —— 节点 `3` 现在直接挨着根节点。

Union with optimizations also takes almost **O(1)** time.

## 参考

看看 playground 获得更多如何使用这么方便的数据结构的例子。

[联合查找 维基百科](https://en.wikipedia.org/wiki/Disjoint-set_data_structure)

*作者： [Artur Antonov](https://github.com/goingreen) 翻译：Daisy*


