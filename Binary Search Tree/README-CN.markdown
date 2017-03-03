# 二叉搜索树 (BST)

二叉搜索树是[二叉树](../Binary Tree/)（一种最多只有两个子节点的树）的一种特殊类别，用来执行插入和删除操作以使树一直都是有序的。

If you don't know what a tree is or what it is for, then [read this first](../Tree/).
如果你不知道树是什么或者是用来做什么，那么可以看[这里](../Tree/)

## “永久有序” 特性

下面是一个有效的二叉搜索树：

![A binary search tree](Images/Tree1.png)

注意每个左节点是如何比父节点小，并且右节点比父节点大的。这就是二叉搜索树的关键特征。

例如，`2` 比 `7` 小，所以它在左边；`5` 比 `2` 大，所以它在右边。

## 插入新节点

当执行插入的时候，我们先与根节点做比较。如果新的值比跟节点小，我们就走 *左边*的分支，如果大，那就走 *右边* 的分支。沿着这个树一直做这样的比较，直到我们找到一个可以插入薪值的空节点。

假如我们想插入一个薪值 `9`：

- 我们从根节点开始（值为 `7` 的节点），然后将它与 `9` 做对比。
- `9 > 7`，所以我们继续沿着右边的分支进行，但是这次节点的值是 `10`。
- 因为 `9 < 10`，我们现在要沿着左边的分支进行。
- 现在我们到了一个没有节点值可比较的地方，所以在这个地方插入一个新节点 `9`。

现在树看上去就是这样的:

![After adding 9](Images/Tree2.png)

在树中总是会有一个地方可以供我们插入新的值。找到这样一个地方通常是很快的，大概是 **O(h)** 的时间，其中 **h** 是树的高度。

> **注意：** 节点的 *高度* 是从该节点到它的最底层的叶子所经过的步数。树的高度就是从根节点到最底层的叶子节点的距离。许多二叉搜索树的操作都是用树的高度来表示的。

通过遵循这个简单的规则——小的值在左边，大的值在右边——我们保持树一直是有序的以便无论什么时候我们要查询的时候，都可以快速确定一个值是不是在树上。

## 搜索树

为了找到树上的一个值，基本上来说我们要采取和插入一样的步骤：

- 如果值比当前的节点小，我们就沿着左分支进行。
- 如果值比当前节点大，我们就沿着右分支进行。
- 如果值与当前节点相同，我们就找到了！

像其他大部分树的操作一样，这是一个递归操作，最后我们要么找到了想要找的值，要么没找到。

如果我们要在上面的例子中找值 `5`，我们会像下面这样找：

![Searching the tree](Images/Searching.png)

要感谢树结构才能让搜索变得如此之快。大概需要 **O(h)** 的时间。如果有一个比较平衡的树有一百万个节点，只需要大概 20 步就可以找到任何要找的东西（这与[二分搜素](../Binary Search/README-CN.md)非常像).

## 遍历树

有时候我们不仅仅是要查找单个的节点，而是要遍历所有。

有三种方法可以遍历一棵树：

1. *中序* (或 *深度优先*): 先查找左节点，然后是节点本身，最后是右节点。
2. *前序*: 先查找节点本身，然后是左节点和右节点。
3. *后序*: 先查找左节点和右节点，然后是节点本身。

再强调一次，这是一个递归的过程。

如果用中序遍历一棵树，看起来就像是所有的节点按从低到高进行了排序。对于例子中的树来说，会打印出 `1, 2, 5, 7, 9, 10`：

![Traversing the tree](Images/Traversing.png)

## 删除节点

删除一个节点也非常简单。删除一个节点之后，我们要么用左边最大的节点或者右边最小的节点来代替它。这样的话树依然是有序的。在下面的例子中，10 被移除了，然后用 9 （图 2）或者 11 （图 3）来代替它。

![Deleting a node with two children](Images/DeleteTwoChildren.png)

替代的方案要求节点至少有一个子节点。如果没有子节点的话，我们只要断开它与父节点的连接即可：

![Deleting a leaf node](Images/DeleteLeaf.png)


## 代码 (解决方案 1)

讲了这么多理论，我们来看看在 Swift 中如何实现一个二叉搜索树吧。我们才可以很多种方法来实现。首先，我们先展示一个基于类的版本，但是我们也会看看如何用一个枚举来实现。

下面显示第一种 `BinarySearchTree` 类的尝试：

```swift
public class BinarySearchTree<T: Comparable> {
  private(set) public var value: T
  private(set) public var parent: BinarySearchTree?
  private(set) public var left: BinarySearchTree?
  private(set) public var right: BinarySearchTree?

  public init(value: T) {
    self.value = value
  }

  public var isRoot: Bool {
    return parent == nil
  }

  public var isLeaf: Bool {
    return left == nil && right == nil
  }

  public var isLeftChild: Bool {
    return parent?.left === self
  }

  public var isRightChild: Bool {
    return parent?.right === self
  }

  public var hasLeftChild: Bool {
    return left != nil
  }

  public var hasRightChild: Bool {
    return right != nil
  }

  public var hasAnyChild: Bool {
    return hasLeftChild || hasRightChild
  }

  public var hasBothChildren: Bool {
    return hasLeftChild && hasRightChild
  }

  public var count: Int {
    return (left?.count ?? 0) + 1 + (right?.count ?? 0)
  }
}
```

这个类只描述了单个的节点，而不是整个树。这是一个泛型类型，所以节点可以存储任何类型的数据。它也有 `左节点` 和 `右节点` 以及 `父节点` 的引用。

下面让我们来开始看看怎么使用它吧：

```swift
let tree = BinarySearchTree<Int>(value: 7)
```

`count` 表示的是这个节点下面有多少个节点。它不仅仅计算节点自己的子节点，同时也计算他们的子节点以及他们的子节点的子节点。如果这个特殊的节点是根节点的话，那么它计算的是整个树有多少个节点。开始的时候，`count = 0`。

> **注意：** 因为 `left`, `right`, 和 `parent` 是可选的，我们可以很好的利用 Swift 的可选链 （?）以及多层可选链式操作符（??)。也可以使用 `if let` 来完成类似的操作，但是不够简明。

### 插入节点

只有一个节点的树是没有多大用途的，下面是如何往一棵树上添加节点的代码：

```swift
  public func insert(value: T) {
    if value < self.value {
      if let left = left {
        left.insert(value: value)
      } else {
        left = BinarySearchTree(value: value)
        left?.parent = self
      }
    } else {
      if let right = right {
        right.insert(value: value)
      } else {
        right = BinarySearchTree(value: value)
        right?.parent = self
      }
    }
  }
```

像其他的树操作一样，用递归来实现插入是最简单的。先将新的值和当前的节点作比较然后决定是插入到左边还是右边的分支。

如果找不到更多的左节点或者右节点，就创建一个 `BinarySearchTree` 对象来作为新的节点，然后通过设置它的 `parent` 属性来将它连接到树上。

> **注意：** 因为二叉搜索树的重点是在于左边的节点都是小的，右边的节点都是大的，所以每次插入都是从根节点开始，以便确保一直是一个有效的二叉树！

为了构建一颗完整的树，我们还需要再做一些操作：

```swift
let tree = BinarySearchTree<Int>(value: 7)
tree.insert(2)
tree.insert(5)
tree.insert(10)
tree.insert(9)
tree.insert(1)
```

> **注意：** 为了后面会说清楚的原因，最好是以一个随机的顺序插入数字。如果是按顺序插入的话，树有可能没有右边的形状。

为了方便，添加一个叫 `insert()` 的初始化方法来添加数组中的元素：

```swift
  public convenience init(array: [T]) {
    precondition(array.count > 0)
    self.init(value: array.first!)
    for v in array.dropFirst() {
      insert(v, parent: self)
    }
  }
```

现在可以简单的这样做了：

```swift
let tree = BinarySearchTree<Int>(array: [7, 2, 5, 10, 9, 1])
```

数组中的第一个值就变成了树的根节点：

### 调试输出

当和这样复杂的数据结构打交道的时候，有一个对用户来说可读的调试输出是非常有用的：

```swift
extension BinarySearchTree: CustomStringConvertible {
  public var description: String {
    var s = ""
    if let left = left {
      s += "(\(left.description)) <- "
    }
    s += "\(value)"
    if let right = right {
      s += " -> (\(right.description))"
    }
    return s
  }
}
```

当调用 `print(tree)` 的时候，我们会得到下面的东西：

	((1) <- 2 -> (5)) <- 7 -> ((9) <- 10)

根节点在中间。发挥一下想象力，把它想象成下面的一棵树：

![The tree](Images/Tree2.png)

顺便说一下，我们可能想知道如果我们插入一个重复的节点会怎么样？我们总是会在右边插入。不妨试试把！

### 搜索

对于我们树中的值我们要对它们做些什么呢？当时是搜索了。能够快速查找元素是二叉搜索树的重要目的。;-)

下面是 `search()` 的实现：

```swift
  public func search(value: T) -> BinarySearchTree? {
    if value < self.value {
      return left?.search(value)
    } else if value > self.value {
      return right?.search(value)
    } else {
      return self  // found it!
    }
  }
```

希望逻辑是清楚地：从当前节点开始（通常是根节点）然后对比值。如果要找的值比节点的小，我们就继续从左边开始找；如果大于，就从右边继续开始找。

当然，如果没有可以查找的节点了的话——当 `left` 或 `right`为空的时候——我们就返回 `nil` 来表示要找的值不在树中。

> **注意：** 在 Swift 中，用可选链很容易实现这个；当我们写 `left?.search(value)` 的时候，如果 `left` 是空的话 它会自动返回 `nil`。没有必要用 `if` 语句来做明确的检查。

搜索是一个递归的过程，但是也可以用一个简单的循环来实现：

```swift
  public func search(value: T) -> BinarySearchTree? {
    var node: BinarySearchTree? = self
    while case let n? = node {
      if value < n.value {
        node = n.left
      } else if value > n.value {
        node = n.right
      } else {
        return node
      }
    }
    return nil
  }
```

自己证明一下这两种实现是等价的吧。个人来讲，我喜欢迭代的方式胜过递归，但你的想法可能不一样。:-)

下面是如何测试搜索：

```swift
tree.search(5)
tree.search(2)
tree.search(7)
tree.search(6)   // 空
```

前面三个都返回了相应的 `BinaryTreeNode` 对象。最后一个返回了 `nil`，因为没有值为 `6` 的节点。

> **注意：** 如果在树中有相同的元素， `search()` 总是返回 “最高的” 节点。这也说得通，因为我们是从根节点往下搜索的。

### 遍历

记住，有三种不同的方式可以遍历树中的所有节点？如下所示：

```swift
  public func traverseInOrder(process: (T) -> Void) {
    left?.traverseInOrder(process: process)
    process(value)
    right?.traverseInOrder(process: process)
  }

  public func traversePreOrder(process: (T) -> Void) {
    process(value)
    left?.traversePreOrder(process: process)
    right?.traversePreOrder(process: process)
  }

  public func traversePostOrder(process: (T) -> Void) {
    left?.traversePostOrder(process: process)
    right?.traversePostOrder(process: process)
    process(value)
  }
```

他们做的事情都差不多，只不过顺序不一样。所有的工作都是地轨完成。再一次感谢 Swift 的可选链，当没有左节点或者右节点的时候，对于 `traverseInOrder()` 的调用会被忽略。

想要按从低到高的顺序打印树中的所有值的时候，可以这样写：

```swift
tree.traverseInOrder { value in print(value) }
```

会输出下面的东西:

	1
	2
	5
	7
	9
	10

我们也可以给树加入像 `map()` 和 `filter()` 这样的方法。例如，下面是一个 map 的实现：

```swift

  public func map(formula: (T) -> T) -> [T] {
    var a = [T]()
    if let left = left { a += left.map(formula: formula) }
    a.append(formula(value))
    if let right = right { a += right.map(formula: formula) }
    return a
  }
```

对树中所有的节点都调用 `formula` 闭包，然后把结果放到一个数组中。`map()` 是通过中序遍历树来工作的。

一个使用 `map()` 的相当简单的例子：

```swift
  public func toArray() -> [T] {
    return map { $0 }
  }
```

上面的调用是将树中的内容以一个有序数组的方式返回。在 playground 中试试吧：

```swift
tree.toArray()   // [1, 2, 5, 7, 9, 10]
```

给你一个作业，看看你能不能实现 filter 和 reduce。

### 删除节点

通过定义一些辅助方法可以让代码看起来更可读：

```swift
  private func reconnectParentToNode(node: BinarySearchTree?) {
    if let parent = parent {
      if isLeftChild {
        parent.left = node
      } else {
        parent.right = node
      }
    }
    node?.parent = parent
  }
```

对树做改变涉及到要改变一堆 `parent` 、 `left` 和 `right` 指针，这个方法帮助我们完成这个工作。先拿到当前节点的父节点——也就是 `self` —— 然后将它和另一个节点连接起来。另一个节点通常是 `self` 的其中一个子节点。

我们还需要一个方法来返回节点的最小和最大节点：

```swift
  public func minimum() -> BinarySearchTree {
    var node = self
    while case let next? = node.left {
      node = next
    }
    return node
  }

  public func maximum() -> BinarySearchTree {
    var node = self
    while case let next? = node.right {
      node = next
    }
    return node
  }

```

剩下的代码就能非常清楚了：

```swift
  @discardableResult public func remove() -> BinarySearchTree? {
    let replacement: BinarySearchTree?

  	  // 代替当前节点的要么是左边最大的或者右边最小的，只要不为空就行。
    if let right = right {
      replacement = right.minimum()
    } else if let left = left {
      replacement = left.maximum()
    } else {
      replacement = nil
    }

    replacement?.remove()

    // 将替代节点放在当前节点的位置
    replacement?.right = right
    replacement?.left = left
    right?.parent = replacement
    left?.parent = replacement
    reconnectParentTo(node:replacement)

    // 当前节点已经不是树的一部分了，所以将它置为空
    parent = nil
    left = nil
    right = nil

    return replacement
  }
```

### 深度和高度

回想一下，节点的高度就是到最底层的叶子节点的距离。我们可以用下面的函数来计算：

```swift
  public func height() -> Int {
    if isLeaf {
      return 0
    } else {
      return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
    }
  }
```

分别结算左边和右边分支的高度，然后取一个最大的。再强调一次，这是一个递归操作。因为要查找所有的节点，所以时间复杂度是 **O(n)**。

> **注意：** Swift 的多层可选链式操作符可以用来方便的处理 `left` 或 `right` 指针为空的问题。可以用 `if let` 来实现，但是就没有那么简洁了。

试试这个:

```swift
tree.height()  // 2
```

我们也可以计算节点的 *深度*，深度是指到根节点的距离。下面是代码：

```swift
  public func depth() -> Int {
    var node = self
    var edges = 0
    while case let parent? = node.parent {
      node = parent
      edges += 1
    }
    return edges
  }
```

跟着 `parent` 指针向上走，直到到达根节点（根节点的 `parent` 为空）。这需要 **O(h)** 的时间。例如：

```swift
if let node9 = tree.search(9) {
  node9.depth()   // returns 2
}
```

### 祖先和后继者

二叉搜索树始终是 “有序的”，但是这并不意味着两个连续的数字正好就在树上是挨着的。

![Example](Images/Tree2.png)

不能通过只搜索左边的子节点来找到值为 `7` 的节点。左节点是 `2`，不是 `5`。找 `7` 之后的数字也是一样的。

`predecessor()` 函数返回在排序时正好在当前值前面的节点：

```swift
  public func predecessor() -> BinarySearchTree<T>? {
    if let left = left {
      return left.maximum()
    } else {
      var node = self
      while case let parent? = node.parent {
        if parent.value < value { return parent }
        node = parent
      }
      return nil
    }
  }
```

如果有左分支的话就很简单了。在这种情况下，最直接的祖先就是左树的最大值了。可以用上面的图来验证一下，`5` 确实是 `7` 的左分支上的最大值。

然而，如果没有左树的话，我们就要找父节点了，直到找到一个更小的值为止。如果我们想直到节点 `9` 的祖先是谁，我们就一直往上找，我们发现第一个父节点有一个更小的值，就是 `7`.

`successor()` 也是一样的道理，但是是相反的：

```swift
  public func successor() -> BinarySearchTree<T>? {
    if let right = right {
      return right.minimum()
    } else {
      var node = self
      while case let parent? = node.parent {
        if parent.value > value { return parent }
        node = parent
      }
      return nil
    }
  }
```

这两个方法的时间复杂度都是 **O(h)**。

> **注意：** 有一个非常酷的变种叫做 ["线索"二叉树](../Thread Binary Tree)。没有用到的左节点或者右节点的指针重新用来指向祖先或者继承者，非常聪明！

### 搜索树是有效的吗？

如果想要破坏一颗二叉搜索树的话可以通过在非根节点上调用 `insert()` 方法，像这样：

```swift
if let node1 = tree.search(1) {
  node1.insert(100)
}
```

根节点的值是 `7`，所以一个值为 `100` 的节点本来应该在右树上。然而，我们没有将它插入在根节点，而是插入到了左树上的一个叶子。所以这个新的 `100` 的节点现在就在不正确的位置了。

结果就是，`tree.search(100)` 会返回空。

可以用下面的方法来检查一个二叉搜索树是不是有效的：

```swift
  public func isBST(minValue minValue: T, maxValue: T) -> Bool {
    if value < minValue || value > maxValue { return false }
    let leftBST = left?.isBST(minValue: minValue, maxValue: value) ?? true
    let rightBST = right?.isBST(minValue: value, maxValue: maxValue) ?? true
    return leftBST && rightBST
  }
```

检验方法就是左树上的确只有比当前节点小的值，并且右树上只有比当前节点大的值。

像下面这样：

```swift
if let node1 = tree.search(1) {
  tree.isBST(minValue: Int.min, maxValue: Int.max)  // true
  node1.insert(100)                                 // EVIL!!!
  tree.search(100)                                  // nil
  tree.isBST(minValue: Int.min, maxValue: Int.max)  // false
}
```

## 节点 (解决方案 2)

我们已经用类实现了一颗二叉树的节点，我们也可以用枚举来实现。

不同在于引用和符号的语义。对基于类的树做改变的话会立马在内存中体现。但是基于枚举的树是不可改变的——任何插入或删除操作都会返回一个全新的树的副本。要有哪一个完全取决于你用它来做什么。

下面是告诉你如何用枚举来实现一颗二叉搜索树：

```swift
public enum BinarySearchTree<T: Comparable> {
  case Empty
  case Leaf(T)
  indirect case Node(BinarySearchTree, T, BinarySearchTree)
}
```

枚举有三种情况：

- `Empty` 用来代表分支的结束 （基于类的版本用 `nil` 引用）
- `Leaf` 表示一个没有子节点的叶子
- `Node` 表示有一个或者两个子节点的节点。将它标记为 `indirect`，这样它就可以持有 `BinarySearchTree` 的值。没有 `indirect` 关键字就不能递归枚举。

> **注意：** 这个二叉树里的节点没有指向父节点的引用。这不是主要问题，但是它会使某些特定操作变得实现起来比较复杂。

通常，我们是通过递归来实现大部分功能的。对于美爵个每个情况我们要有一些不同。例如，下面是如何结算树上节点个数和树的高度的代码：

```swift
  public var count: Int {
    switch self {
    case .Empty: return 0
    case .Leaf: return 1
    case let .Node(left, _, right): return left.count + 1 + right.count
    }
  }

  public var height: Int {
    switch self {
    case .Empty: return 0
    case .Leaf: return 1
    case let .Node(left, _, right): return 1 + max(left.height, right.height)
    }
  }
```

像这样插入新的节点：

```swift
  public func insert(newValue: T) -> BinarySearchTree {
    switch self {
    case .Empty:
      return .Leaf(newValue)

    case .Leaf(let value):
      if newValue < value {
        return .Node(.Leaf(newValue), value, .Empty)
      } else {
        return .Node(.Empty, value, .Leaf(newValue))
      }

    case .Node(let left, let value, let right):
      if newValue < value {
        return .Node(left.insert(newValue), value, right)
      } else {
        return .Node(left, value, right.insert(newValue))
      }
    }
  }
```

在 playground 里试试吧：

```swift
var tree = BinarySearchTree.Leaf(7)
tree = tree.insert(2)
tree = tree.insert(5)
tree = tree.insert(10)
tree = tree.insert(9)
tree = tree.insert(1)
```

注意到每次插入东西的时候，每次都会返回一个完全的新树对象。这就是为什么要将返回结果重新赋值给 `tree` 变量。

下面是所以重要的搜索方法：

```swift
  public func search(x: T) -> BinarySearchTree? {
    switch self {
    case .Empty:
      return nil
    case .Leaf(let y):
      return (x == y) ? self : nil
    case let .Node(left, y, right):
      if x < y {
        return left.search(x)
      } else if y < x {
        return right.search(x)
      } else {
        return self
      }
    }
  }
```

正如我们所看到的，大部分方法的结构都是差不多的：

在 playground 里试试吧：

```swift
tree.search(10)
tree.search(1)
tree.search(11)   // nil
```

可以用下面的方法来打印树中的节点以便调试：

```swift
extension BinarySearchTree: CustomDebugStringConvertible {
  public var debugDescription: String {
    switch self {
    case .Empty: return "."
    case .Leaf(let value): return "\(value)"
    case .Node(let left, let value, let right):
      return "(\(left.debugDescription) <- \(value) -> \(right.debugDescription))"
    }
  }
}
```

当调用 `print(tree)` 的时候，会打印出下面的东西：

	((1 <- 2 -> 5) <- 7 -> (9 <- 10 -> .))

根节点在中间；点意味着在这个位置没有子节点。

## 当树变得不平衡……

当左右子树有大概相同的节点数的时候，二叉搜索树就是 *平衡*。这样的话，树的高度就是 *log(n)*，*n* 是节点的个数。这是最理想的情况。

然而，如果一个分支比另一个要大很多，搜索就变得非常慢。最终我们会比理想情况下要查找更多的值。在最糟糕的情况下，树的高度可能是 *n*。这样的树更像是一个[链表](../Linked List)而不是一棵二叉搜索树，性能降到了 **O(n)**，非常不好！

保持二叉树的一个方法就是随机地插入节点。平均情况下，这会时保持一个平衡。但是并不保证成功，也并不总是很实用。

另外一个解决方法就是使用 *self-balancing* 的二叉树。这种类型的数据结构会在插入或者删除节点之后调整树的结构来保持平衡。参考[平衡二叉查找树](../AVL Tree) 和 [红黑树](../Red-Black Tree)。

## 延伸阅读

[二叉搜索树 维基百科](https://en.wikipedia.org/wiki/Binary_search_tree)

*作者 [Nicolas Ameghino](http://www.github.com/nameghino) 和 Matthijs Hollemans 翻译：Daisy*


