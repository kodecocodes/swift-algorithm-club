# 树

树代表的是对象之间的层级关系。这是一棵树：

![A tree](Images/Tree.png)

树是由节点组成，节点之间互相连接。

节点和子节点之间有链接，一般也与父节点有连接。子节点是在给定节点下面的节点；父节点是上面的节点。一个节点可以有多个子节点但是只能有一个父节点。

![A tree](Images/ParentChildren.png)

没有父节点的节点称为 *根* 节点。没有子节点的节点叫做 *叶子* 节点。

树中的节点是不会形成循环的。这不是一棵树：

![Not a tree](Images/Cycles.png)

这样的结构叫做 [图](../Graph/README-CN.markdown) 。树是一种非常简单的图。（类似的，[链表](../Linked%20List/README-CN.markdown)是一种简单的树。自己想想看！）

这篇文章讨论的是通用目的的树。它不限制子节点的个数，也不限制节点在树中的顺序。

下面是 Swift 中的一个基本实现：

```swift
public class TreeNode<T> {
  public var value: T

  public weak var parent: TreeNode?
  public var children = [TreeNode<T>]()

  public init(value: T) {
    self.value = value
  }

  public func addChild(_ node: TreeNode<T>) {
    children.append(node)
    node.parent = self
  }
}
```

这描述了树中的单个节点。它有是一个泛型类型 `T`，一个 `parent` 节点的引用，以及一个子节点的数组。

添加一个 `description` 方法方便得打印一棵树：

```swift
extension TreeNode: CustomStringConvertible {
  public var description: String {
    var s = "\(value)"
    if !children.isEmpty {
      s += " {" + children.map { $0.description }.joined(separator: ", ") + "}"
    }
    return s
  }
}
```

在 playground 中看看这些行为吧：

```swift
let tree = TreeNode<String>(value: "beverages")

let hotNode = TreeNode<String>(value: "hot")
let coldNode = TreeNode<String>(value: "cold")

let teaNode = TreeNode<String>(value: "tea")
let coffeeNode = TreeNode<String>(value: "coffee")
let chocolateNode = TreeNode<String>(value: "cocoa")

let blackTeaNode = TreeNode<String>(value: "black")
let greenTeaNode = TreeNode<String>(value: "green")
let chaiTeaNode = TreeNode<String>(value: "chai")

let sodaNode = TreeNode<String>(value: "soda")
let milkNode = TreeNode<String>(value: "milk")

let gingerAleNode = TreeNode<String>(value: "ginger ale")
let bitterLemonNode = TreeNode<String>(value: "bitter lemon")

tree.addChild(hotNode)
tree.addChild(coldNode)

hotNode.addChild(teaNode)
hotNode.addChild(coffeeNode)
hotNode.addChild(chocolateNode)

coldNode.addChild(sodaNode)
coldNode.addChild(milkNode)

teaNode.addChild(blackTeaNode)
teaNode.addChild(greenTeaNode)
teaNode.addChild(chaiTeaNode)

sodaNode.addChild(gingerAleNode)
sodaNode.addChild(bitterLemonNode)
```

如果你打印 `tree` 的值，会得到：

	beverages {hot {tea {black, green, chai}, coffee, cocoa}, cold {soda {ginger ale, bitter lemon}, milk}}

跟下面的这个结构是一致的：

![Example tree](Images/Example.png)

beverages 节点是根节点，因为它没有父节点。叶子节点是 `black`, `green`, `chai`, `coffee`, `cocoa`, `ginger ale`, `bitter lemon`, `milk`，因额外i他们没有任何子节点。

对于任何节点来说都可以根据 `parent` 属性来往上找到根节点：

```swift
teaNode.parent           // this is the "hot" node
teaNode.parent!.parent   // this is the root
```

当谈论树的时候，我们经常使用下面的这些定义：

- **树的高度** 根节点和最下面的叶子节点之间的连接数。在我们的例子中宏，树的高度是 3，因为从根节点到下面需要三跳。

- **节点的深度** 节点到根节点的连接数。例如，`tea` 的深度是 2，因为需要两跳才可以到达根节点。（根节点自己的深度是 0）

有许多方法可以构建一棵树。例如，有时候根本不需要 `parent` 属性。或者你可以规定每个节点最多只能有两个子节点 —— 这样的树叫做 [二叉树](../Binary%20Tree/README-CN.markdown)。一个常用的树类型是 [二叉搜索树](../Binary%20Search%20Tree/README-CN.markdown)（或叫做 BST），它是一种特殊版本的二叉树，节点必须以特定方法进行排序来加快搜索速度。

我们这里展示的一般用途的树对于描述层级关系的数据非常好，但是它真正取决于你的应用需要什么额外的功能。

下面是一个如何使用 `TreeNode` 类来决定树是否包含一个特定值的例子。首先查找根节点自己的 `value` 属性。如果没有匹配，那么就按顺序查找所有的子节点。当然，这些子节点也是 `TreeNode`，这样就可以递归地重复这个过程：首先查找他们自己的值，然后是他们的子节点。他们的子节点也做同样的操作，等等...递归和树携手并进。

下面是代码：

```swift
extension TreeNode where T: Equatable {
  func search(_ value: T) -> TreeNode? {
    if value == self.value {
      return self
    }
    for child in children {
      if let found = child.search(value) {
        return found
      }
    }
    return nil
  }
}
```

如何使用的例子：

```swift
tree.search("cocoa")    // returns the "cocoa" node
tree.search("chai")     // returns the "chai" node
tree.search("bubbly")   // nil
```

用数组来描述一棵树也是可能的。数组中的索引用来创建不同节点之间的连接。例如：假如我们有：

	0 = beverage	5 = cocoa		9  = green
	1 = hot			6 = soda		10 = chai
	2 = cold		7 = milk		11 = ginger ale
	3 = tea			8 = black		12 = bitter lemon
	4 = coffee				

可以用下面的数组来描述这棵树：

	[ -1, 0, 0, 1, 1, 1, 2, 2, 3, 3, 3, 6, 6 ]

数组中的每个项都是一个指向父节点的指针。在索引 3 的元素 `tea` 的值是 1，因为它的父节点是 `hot`。根节点指向的是 -1，因为它没有父节点。可以从一个节点遍历到根节点，但是反过来就不行。

顺便说一下，有时在算法里会用到术语 *forest*。没什么好奇怪的，这是不同树对象的集合的名称。一个例子就是 [联合查找](../Union-Find/README-CN.markdown)。

*作者：Matthijs Hollemans 翻译：Daisy*


