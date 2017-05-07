# 红黑树

红黑树是一种特殊的 [二叉搜索树](../Binary%20Search%20Tree/README-CN.markdown)。二叉搜索树（BSTs）在一系列的插入/删除之后会变得不平衡。BST 和红黑树（RBT）节点之间最大的不同时，RBT 的节点有一个颜色属性用来标识它是红的还是黑的。RBT 通过确保一下属性成立来达到自平衡。

## 属性
1. 节点要么是红的，要么是黑的
2. 根节点始终是黑的
3. 所有叶子节点是黑的
4. 如果节点是红的，那么它的子节点都是黑的
5. 每条通往叶子节点的路径要包含相同数量的黑节点（往下探索一棵 RBT 树时遇到的黑色节点的个数就叫做树的黑色深度）

## 方法
* `insert(_ value: T)` 插入值到树中
* `insert(_ values: [T])` 插入一组值到树中
* `delete(_ value: T)` 从树中删除值
* `find(_ value: T) -> RBTNode<T>` 查找并返回给定的值
* `minimum(n: RBTNode<T>) -> RBTNode<T>` 查找从给定节点开始的子树的最大值
* `maximum(n: RBTNode<T>) -> RBTNode<T>` 查找从给定节点开始的子树的最小值
* `func verify()` 检查树是不是还有效。如果失效了就要给出警告信息

## 旋转

RBTs 用一个叫做旋转的操作来使节点重新保持平衡。可以向左也可以向右旋转节点和它的子节点。旋转节点和它的子节点需要将他们和子树进行交换。左旋转将父节点和它的右节点交换，右旋转则是将父节点和它的左节点交换。

左旋转：
```
before left rotating p       after left rotating p  
     p                         b
   /   \                     /   \
  a     b          ->       p     n
 / \   / \                 / \   
n   n  n  n               a   n
                         / \
                        n   n
```
右旋转：
```
before right rotating p       after right rotating p  
     p                         a
   /   \                     /   \
  a     b          ->       n     p
 / \   / \                       / \   
n   n  n  n                     n   b
                                   / \
                                  n   n
```

## 插入

用值创建一个新的要插入到树中的节点。新节点的颜色始终是红的。
用这个节点执行一个标砖的 BST 插入。现在的树可能不是一个有效的 BST 了。  
现在我们进行一些插入操作来让树重新有效。我们把刚插入的节点叫 n。

**步骤 1**: 检查 n 是不是根节点，如果是，就将它变成黑色，然后就结束了。如果不是，就继续步骤 2。

现在我们知道 n 至少有一个父节点并且它不是根节点。

**步骤 2**: 检查 n 的父节点是不是黑色，如果是，就结束了。如果不是，就继续步骤 3。

现在我们知道父节点也不是根节点，因为父节点是红的。因此 n 还有一个祖父节点和一个叔叔节点，因为每个节点都有两个子节点。这个叔叔节点无论如何都不可能是 nullLeaf。

**步骤 3**: 检查 n 的叔叔是不是红的。如果不是，就到步骤 4。如果 n 的叔叔确实是红的，就将父节点和叔叔变成黑的，n 的祖父节点变成红的。然后再到步骤 1 对祖父节点执行相同的逻辑。

从这里开始有四种情况：
- **左左** n 的父节点是它的父节点的左节点并且 n 也是它的父节点的左节点。
- **左右** n 的父节点是它的父节点的左节点并且 n 是它的父节点的右节点。
- **右右** n 的父节点是它的父节点的右节点并且 n 也是它的父节点的右节点。
- **右左** n 的父节点是它的父节点的右节点并且 n 是它的父节点的左节点。

**步骤 4**: 检查是否是 **左右** 或者 **右左** 情况，如果是，就应用下面的情况。
  -如果是 **左右** 情况，往左旋转 n 的父节点并且将 n 设置成它的父节点之后跳到步骤 5.  (这会让 **左右** 情况变成 **左左**)
  - 如果发现是 **右左** 情况，往右旋转 n 的 父节点并且将 n 设置成 n 的父节点之后跳到步骤 5。 (这会将 **右左** 情况变成 **右右** 情况)
  - 如果发现不是上面的两种亲狂光，就跳到步骤 5。

n 的父节点现在是红的了，但它的祖父节点是黑的。

**Step 5**: 将 n 的父节点和祖父节点的颜色交换。
  - 如果是 **左左** 情况就往右旋转 n 的祖父节点。
  - 如果是 **右右** 情况就往左旋转 n 的祖父节点。

最后我们就成功地将树变成有效了。

# 删除

删除比插入要复杂一些。下面我们将要删除的节点叫做 del。
首先使用 find() 方法找到要删除的节点。
将查找的结果赋值到 del。
现在通过下面的步骤来删除节点 del。

首先做一些检查：
- del 是否是根节点。如果是，就将根节点设置成 nullLeaf 然后就结束了。
- 如果 del 有两个空叶子节点并且是红色的。检查 del 是左节点还是右节点相应地将 del 的父节点的左节点或者右节点设置为 nullLeaf。
- 如果 del 有两个非 nullLeaf 子节点，我们就要查找 del 的左子树的最大值。将 del 的值设置成这个最大值并且继续删除那个最大值的节点，现在我们把它叫做 del。

这些检查之后我们知道 del 有最多一个非 nullLeaf 的子节点。它要么有两个 nullLeaf 或者一个 nullLeaf 和一个普通的红色子节点。（子节点是红色，否则每个叶子的黑色深度就不一样了）

现在我们把 del 的非 nullLeaf 子节点叫做child。如果 del 有两个 nullLeaf 子节点，child 就是一个 nullLeaf。这就意味着 child 要么是一个 nullLeaf 要么是红色的。

现在我们有三个选择：

- 如果 del 是红的，它的子节点就是 nullLeaf。我们只要删除它，因为它不会改变树的黑色深度。这样就结束了。

- 如果 child 是红的，将它变成黑色，将 child 的父节点变成 del 的父节点。del 就被删除了。

- del 和 child 都是黑色的，

如果 del 和 child 都是黑色的，我们引入一个新的变量 sibling，它是 del 的兄弟。用 child 替换 del 并且让它变成双黑色。这时 del 就被删除了，child 和 sibling 变成了兄弟。

现在我们需要做很多事情来删除双黑色。在没有写出完整代码时很难用文字来描述。这是由于节点和颜色之间的各种可能的联系造成的。代码里右注释，但如果你还是不太理解的话，可以给我留言。关于删除操作还有一部分再下面的参考链接里右说明。

## 参考

* [维基百科](https://en.wikipedia.org/wiki/Red–black_tree)
* [GeeksforGeeks - introduction](http://www.geeksforgeeks.org/red-black-tree-set-1-introduction-2/)
* [GeeksforGeeks - insertion](http://www.geeksforgeeks.org/red-black-tree-set-2-insert/)
* [GeeksforGeeks - deletion](http://www.geeksforgeeks.org/red-black-tree-set-3-delete-2/)

Important to note is that GeeksforGeeks doesn't mention a few deletion cases that do occur. The code however does implement these.

*作者：Jaap Wijnen. 更新： Ashwin Raghuraman 翻译：Daisy*


