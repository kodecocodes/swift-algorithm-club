# 线索二叉树

线索二叉树是一种通过维护一些额外的变量来方便快捷地 **顺序遍历** 树的特殊类型的 [二叉树](../Binary%20Tree/README-CN.markdown)（一种每个节点最多有两个子节点的树）。接下来我们要探索线段二叉树的一般结构以及完整的 [Swift 实现](ThreadedBinaryTree.swift)

如果你不知道树是什么以及它是干什么的，参考[这里](../Tree/README-CN.markdown)。


## 顺序遍历

使用线索二叉树而不是更简单和小的标准二叉树的动机是提高树的顺序遍历的速度。顺序遍历二叉树是指以他们存储的顺序来遍历二叉树，与[二叉搜索树](../Binary%20Search%20Tree/README-CN.markdown)的顺序相匹配。也就是说大部分的线索二叉树也是二叉搜索树。思想就是先访问节点的左节点，然后是节点本身，最后是右节点。


顺序遍历任何二叉树一般是下面这样的（使用 Swift 语法）：

```swift
func traverse(n: Node?) {
  if (n == nil) { return
  } else {
    traverse(n.left)
    visit(n)
    traverse(n.right)
  }
}
```
其中 `n` 是树的节点（或者 `nil`），每个节点将它的子节点存储为 `left` 和 `right`，访问 一个节点的意思可以是对它执行操作。我们会将要遍历的树的根节点传入这个方法。

虽然简单易懂，但由于递归的原因，这个算法使用的栈空间是与树的高度成比例的。如果树有 **n** 个节点，那么空间的使用可以从 **O(log n)** （一颗非常平衡的树）到 **O(n)** （一个非常不平衡的树）。

线索二叉树可以解决这个问题。

> 关于更多顺序遍历的信息可以看[这里](../Binary%20Tree/README-CN.markdown)。


## 前任和后继者

树的顺序遍历会产生节点的线性排序。因此每个节点都有一个 **前任** 和 一个 **后继者** （除了第一个和最后一个节点，它们分别只有后继者或者前任）。在线索二叉树中，每个通常为 `nil` 的左节点会存储节点的前任（如果存在的话），每个通常为 `nil` 的右节点会存储节点的后继者（如果存在的话）。这就是标准二叉树和线索二叉树的不同。

有两种类型的线索二叉树：**单线索** 和 **双线索**：
- 单线索树追踪的是前任 **或者** 后继者 （左 **或者** 右）
- 双线索树同时追踪前任 **和** 后继者 （左 **和** 右）

用单线索还是双线索树取决于我们要达到的目的。如果我们只再一个方向上（要么往前要么往后）上遍历树，那么我们就用单线索树。如果要在两个方向上遍历，就用双线索树。

知道每个节点要么存储它的前任要么存储它的左节点，并且要么存储它的后继者要么存储它的右节点是很重要的。节点不需要两个都存储。例如，在双线索树中，如果一个节点有右节点但是没有左节点，它就会用前任代替左节点的位置。

下面是一个有效的 “满” 线索二叉树：

![Full](Images/Full.png)

下面的线索二叉树不是 “满” 的，但它还是有效的。树的结构不重要，只要它满足二叉搜索树的定义就可以。

![Partial](Images/Partial.png)

实线表示的是父节点和子节点之间的连接，虚线表示的是 “线索”。知道子节点和线索边之间是如何交换的很重要。根节点两边的节点都有一个进入的边（来自父节点），以及两个出去的边：一个通向左边，一个通向右边。左边出去的线指向的是左节点，如果存在的话，如果没有左节点就通向顺序里的前任。右边出去的线指向的是右节点，如果存在的话，如果没有右节点就指向顺序里的后继者。最左边和最右边的节点是例外，它们分别没有前任和后继者。


## 表示法

在进入线索二叉树方法的细节之前，我们要先解释一下是如何表示树本身的。这个数据结构的核心是 `ThreadedBinaryTree<T: Comparable>` 类。每个这个类的实例都达标的是一个有六个变量的节点：`value`, `parent`, `left`, `right`, `leftThread`, 和 `rightThread`。在这些变量中，只有 `value` 是必须的。另外五个在 Swift 中是 *可选的* （他们可能为 `nil`）。
- `value: T` 是节点的值(例如 1, 2, A, B, 等等)
- `parent: ThreadedBinaryTree?` 是节点的父节点
- `left: ThreadedBinaryTree?` 是节点的左节点
- `right: ThreadedBinaryTree?` 是节点的右节点
- `leftThread: ThreadedBinaryTree?` 是节点的顺序前任
- `rightThread: ThreadedBinaryTree?` 是节点的顺序后继者

因为我们同时保存了 `leftThread` 和 `rightThread`，这是一个双线索树。现在我们准备好进入我们`ThreadedBinaryTree` 类的成员函数了。


## 遍历算法

来看看我们使用线索二叉树的主要原因吧。现在很容易就找到树中节点的顺序前任和后继者。如果节点没有 `left`/`right` 子节点，就可以简单地返回 `leftThread`/`rightThread`。否则的话，就继续往下探索树并且查找正确的节点。

```swift
  func predecessor() -> ThreadedBinaryTree<T>? {
    if let left = left {
      return left.maximum()
    } else {
      return leftThread
    }
  }

  func successor() -> ThreadedBinaryTree<T>? {
    if let right = right {
      return right.minimum()
    } else {
      return rightThread
    }
  }
```
> 注意： `maximum()` 和 `minimum()` 是用来返回给定子树的最大/最小值的 `ThreadedBinaryTree` 的方法。查看[实现](ThreadedBinaryTree.swift)获得更多细节。

因为这些是 `ThreadedBinaryTree` 的方法，可以调用 `node.predecessor()` 或 `node.successor()` 来获得任何 `node` 的前任和后继者，假如 `node` 是 `ThreadedBinaryTree` 对象的话。

由于追踪了前任和/或后继者，线索二叉树的顺序遍历就比上面的递归算法要高效地多。在新的算法中，用这些前任/后继者属性对往前和往后遍历树都会产生极大的影响。

```swift
    public func traverseInOrderForward(_ visit: (T) -> Void) {
        var n: ThreadedBinaryTree
        n = minimum()
        while true {
            visit(n.value)
            if let successor = n.successor() {
                n = successor
            } else {
                break
            }
        }
    }

    public func traverseInOrderBackward(_ visit: (T) -> Void) {
        var n: ThreadedBinaryTree
        n = maximum()
        while true {
            visit(n.value)
            if let predecessor = n.predecessor() {
                n = predecessor
            } else {
                break
            }
        }
    }
```
同样的，这是一个 `ThreadedBinaryTree` 的方法，可以通过 `node.traverseInorderForward(visitFunction)` 来调用。可以指定一个要在每个节点被访问时执行的函数。这个函数可以是任何你想做的事，只要它接收 `T` （树的节点的是）作为参数并且没有返回值。

现在让我们手动向前遍历一棵树来更好的理解计算机是如何做这个事情的。拿这棵线索树来举例子：

![Base](Images/Base.png)

从树的根节点开始，**9**。注意，现在我们还没有 `visit(9)`。从这里开始我们要先到树的 `minimum()` 节点，在这个例子中是 **2**。然后 `visit(2)` 并且发现它有 `rightThread`，因此我们就立即知道它的 `successor()` 是什么。跟着这个线索到了 **5**，它没有留下任何线索。因此，在 `visit(5)` 之后，我们就到了它的 `right` 子树的 `minimum()` 节点，跟着这个我们就回到了 **9**。*现在* 我们 `visit(9)`，之后我们发现它没有 `rightThread`，因此我们就继续它的 `right` 子树的 `minimum()` 节点，也就是 **12**。这个节点有一个 `rightThread` 指向的是 `nil`，这就表示我们完成了遍历！最后访问节点的顺序就是 **2，5，7，9，12**，直观上看这能说得通，因为这是他们自然的递增顺序。

A backward traversal would be very similar, but you would replace `right`,
`rightThread`, `minimum()`, and `successor()` with `left`, `leftThread`,
`maximum()`, and `predecessor()`.


## 插入和删除

只要付出很少的代价线索二叉树就可以有快速顺序遍历。插入/删除节点就变得更复杂了，因为我们还要继续维护 `leftThread` 和 `rightThread` 变量。与其用看无聊的代码，不如直接用一个例子（如果想要了解更多细节的话，也可以看看这个[实现](ThreadedBinaryTree.swift)，）来解释。需要注意的是，这需要知道二叉搜索树的知识，所以请先先读[这个](../Binary%20Search%20Tree/README-CN.markdown)。

> 注意：在这个线索二叉树的实现中，我们允许相同的节点出现。默认将它插入到右边。

用和上面的遍历的例子相同的树开始吧：

![Base](Images/Base.png)

假设我们要插入 **10** 到树中。最后的结果可能是这样的，有变化的部分用红色标记出来了：

![Insert1](Images/Insert1.png)

如果你已经完成了家庭作业并且熟悉二叉搜索树的话，这个节点的放置就不会惊讶到你了。新东西是如何维护节点之间的线索。我们知道我们要将 **10** 作为 **12** 的左节点插入进去。第一件要做的事情就是将 **12** 的 `left` 设置成 **10**，将 **10** 的父节点设置成 **12**。因为 **10** 已经插入再 `left` 了，并且 **10** 没有它自己的子节点，所以我们可以安全地将 **10** 的 `rightThread` 设置成它的 parent **12**。**10** 的 `leftThread` 怎么办呢？因为我们知道 **10** < **12**，并且 **10** 是 **12** 唯一的子节点，所以可以安全地将 **10** 的 `leftThread` 设置成 **12** 的 `leftThreaded`。最后将 **12** 的 `leftThreaded` 设置成 `nil`，因为它现在有一个 `left` 节点了。

现在我们插入另一个节点 **4** 到树中：

![Insert2](Images/Insert2.png)

在将 **4** 作为 right 子节点插入时，它和上面的步骤是一样的，不过是镜像的（将 `left` 和 `right` 进行交换）。处于完整性，我们最后插入一个 **15** 的节点：

![Insert3](Images/Insert3.png)

现在我们的树有点挤了，我们移除一些节点吧。跟插入相比，删除又要更复杂一些。先从简单的开始吧，比如，移除 **7**，它没有子节点：

![Remove1](Images/Remove1.png)

在扔掉 **7** 之前，我们先要做一些清理工作。在上面的例子中，**7** 是一个 `right` 子节点并且自己没有子节点，我们只要简单地将 **7** 的 `parent` （**5**）的 `rightThread` 设置成 **7** 的 `rightThread` 即可。然后只要将 **7** 的 `parent`、`left`、`right`、`leftThread`、 `rightThread` 以及 **7** 的父节点的右子节点设置成 `nil` 就可以将它从树中移除了。

来试试更难一点的吧。把 **5** 从树中移除：

![Remove2](Images/Remove2.png)

这看起来有些棘手，因为 **5** 有一些子节点需要处理。核心思想就是用 **5** 的第一个子节点 **2** 替换它。为了实现这个，当然就需要将 **2** 的 `parent` 设置成 **9** 并且将 **9** 的 `left` 子节点设置成 **2**。注意，原来 **4** 的 `rightThread` 是 **5**，但是现在要移除 **5**，所以这个也要变。现在，理解线索二叉树的两个重要特性就非常重要了：

1. 对于任意节点 **n** 的 `left` 子树的最大节点 **m**，**m** 的 `rightThread` 是 **n**
2. 对于任意节点 **n** 的 `right` 子树的最小节点 **m**，**m** 的 `leftThread` 是 **n**。

在移除 **5**之前，看看这两个特性是如何为真的，因为 **4** 是 **5** 的 `left` 子树的最大节点。为了保持这个特性，就要将 **4** 的 rightThread 设置成 **9**，因为 **4** 现在是 **9** 的 `left` 子树的最大节点。最后要做的就是将 **5** 的 `parent`、`left`、`right`、`leftThread` 和 `rightThread` 设置成 `nil`。

来点疯狂的怎么养？如果我们试图删除 **9** 会怎么样？这是最后的结果：

![Remove3](Images/Remove3.png)

当我们想要移除有两个子节点的节点时，我们才去和上面稍微有点不一样的方法。基本思想是用要移除的节点的 `right` 子树的最小节点来替换它，我们把它叫做替换节点。

> 注意：我们也可以用 `left` 子树的最大节点节点来替换。这是一个随意的决定。

一旦找到了替换节点，在这个例子中是 **10**，我们用上面的算法把它从树中移除。这样可以保证 `right` 子树的边还是正确的。从这里开始就要用 **10** 来替换 **9** 了，我们只要更新从 **10** 出去的边。为了维持上面说的两个特性，现在要做的就是处理线索。在这个例子中，**12** 的 `leftThread` 现在是 **10**。不再需要节点 **9** 了，在将它的所有属性都设置为 `nil` 之后就可以结束这个移除操作了。

为了说明如何移除只有 `right` 节点的节点，我们从树中移除最后一个节点 **12**：

![Remove4](Images/Remove4.png)

移除 **12** 和我们之前移除 **5** 的步骤是一样，只是反过来。**5** 有 `left` 节点，而 **12** 有 `right` 节点，但是核心算法是一样的。

就这些了！这只是一个关于线索二叉树的插入和删除如何工作的快速概览，但如果你理解了这些例子，你就可以从任何树中移除任何你想要的移除的节点。可以在[这里](ThreadedBinaryTree.swift)找到更多细节。


## 其他方法

还有很多线索二叉树可以做的类似 `searching()` 树中的节点，查找节点的 `depth()` 和 `height()` 的操作，可以查看这里的[实现](ThreadedBinaryTree.swift)获取更多技术细节。这里面的很多方法也是二叉搜索树的方法，可以从[这里](../Binary%20Search%20Tree/README-CN.markdown)找到关于二叉搜索树的内容。


## 参考

[线索二叉树 维基百科](https://en.wikipedia.org/wiki/Threaded_binary_tree)

*作者：[Jayson Tung](https://github.com/JFTung) 翻译：Daisy*
*升级到 Swift 3： Jaap Wijnen*

*图片制作于： www.draw.io*


