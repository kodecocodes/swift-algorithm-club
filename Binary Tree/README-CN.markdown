# 二叉树

二叉树是一棵每个节点只能有 0，1 或者 2 个子节点的[树](../Tree/READMEC-CN.markdown)。这是一颗二叉树：

![A binary tree](Images/BinaryTree.png)

子节点通常叫做 *左* 孩子和 *右* 孩子。如果一个节点没有子节点，它就叫做 *叶子* 节点。*根* 节点是树的最上面的节点（程序员更喜欢树是上下翻转的）。

通常节点都会有一个连接到他们的父节点，但是这不是严格必须的。

二叉树经常用做 [二叉搜索树](../Binary%20Search%20Tree/README-CN.markdown)。这样的话，节点就必须是特定顺序的（小的值在左边，大的值在右边）。但不是所有的二叉树都是这样的。

例如，这是一颗表示算数运算系列的二叉树，`(5 * (a - 10)) + (-4 * (3 / b))`：

![A binary tree](Images/Operations.png)

## 代码

下面是在 Swift 中如何实现一个一般用途的二叉树：

```swift
public indirect enum BinaryTree<T> {
  case node(BinaryTree<T>, T, BinaryTree<T>)
  case empty
}
```

下面是一个如何使用它的例子，然我们来建立一个算术运算的树：

```swift
// leaf nodes
let node5 = BinaryTree.node(.empty, "5", .empty)
let nodeA = BinaryTree.node(.empty, "a", .empty)
let node10 = BinaryTree.node(.empty, "10", .empty)
let node4 = BinaryTree.node(.empty, "4", .empty)
let node3 = BinaryTree.node(.empty, "3", .empty)
let nodeB = BinaryTree.node(.empty, "b", .empty)

// intermediate nodes on the left
let Aminus10 = BinaryTree.node(nodeA, "-", node10)
let timesLeft = BinaryTree.node(node5, "*", Aminus10)

// intermediate nodes on the right
let minus4 = BinaryTree.node(.empty, "-", node4)
let divide3andB = BinaryTree.node(node3, "/", nodeB)
let timesRight = BinaryTree.node(minus4, "*", divide3andB)

// root node
let tree = BinaryTree.node(timesLeft, "+", timesRight)
```

要反着来建立这棵树，从叶子节点开始然后往上到达最上面。


添加一个 `description` 方法来打印树是很有用的：

```swift
extension BinaryTree: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .node(left, value, right):
      return "value: \(value), left = [\(left.description)], right = [\(right.description)]"
    case .empty:
      return ""
    }
  }
}
```

如果 `print(tree)` ，会得到类似这样的东西：

	value: +, left = [value: *, left = [value: 5, left = [], right = []], right = [value: -, left = [value: a, left = [], right = []], right = [value: 10, left = [], right = []]]], right = [value: *, left = [value: -, left = [], right = [value: 4, left = [], right = []]], right = [value: /, left = [value: 3, left = [], right = []], right = [value: b, left = [], right = []]]]

来点想象，你就可以看到树的结构了。:-) 如果缩进成这样可能会有所帮助：

	value: +, 
		left = [value: *, 
			left = [value: 5, left = [], right = []], 
			right = [value: -, 
				left = [value: a, left = [], right = []], 
				right = [value: 10, left = [], right = []]]], 
		right = [value: *, 
			left = [value: -, 
				left = [], 
				right = [value: 4, left = [], right = []]], 
			right = [value: /, 
				left = [value: 3, left = [], right = []], 
				right = [value: b, left = [], right = []]]]

另外一个有用的方法是计算树中的节点的个数：

```swift
  public var count: Int {
    switch self {
    case let .node(left, _, right):
      return left.count + 1 + right.count
    case .empty:
      return 0
    }
  }
```

在上面的树的例子中宏，`tree.count` 是12。

对树经常做的操作是遍历他们，例如，以某种顺序查找所以的节点。有三中方法可以遍历一颗二叉树：

1. *中序遍历* （又称 *深度优先*）：搜索查找节点的左节点，然后是节点自己，最后是右节点。
2. *前序遍历*：首先查找节点，然后是左右节点。
3. *后序遍历*：首先查找左右节点，然后是节点自己。

下面是如何实现的：

```swift
  public func traverseInOrder(process: (T) -> Void) {
    if case let .node(left, value, right) = self {
      left.traverseInOrder(process: process)
      process(value)
      right.traverseInOrder(process: process)
    }
  }
  
  public func traversePreOrder(process: (T) -> Void) {
    if case let .node(left, value, right) = self {
      process(value)
      left.traversePreOrder(process: process)
      right.traversePreOrder(process: process)
    }
  }
  
  public func traversePostOrder(process: (T) -> Void) {
    if case let .node(left, value, right) = self {
      left.traversePostOrder(process: process)
      right.traversePostOrder(process: process)
      process(value)
    }
  }
```

通常与树打交道的时候，这些方法都是递归地调用自己。

例如，如果以后序遍历来遍历算数匀速的树的话，会看到这样的一个顺序：

	5
	a
	10
	-
	*
	4
	-
	3
	b
	/
	*
	+

先看到叶子节点。根节点在最后。

你可以用堆栈机来评估这些表达式，类似下面的伪代码：

```swift
tree.traversePostOrder { s in 
  switch s {
  case this is a numeric literal, such as 5:
    push it onto the stack
  case this is a variable name, such as a:
    look up the value of a and push it onto the stack
  case this is an operator, such as *:
    pop the two top-most items off the stack, multiply them,
    and push the result back onto the stack
  }
  the result is in the top-most item on the stack
}
```

*作者：Matthijs Hollemans 翻译：Daisy*


