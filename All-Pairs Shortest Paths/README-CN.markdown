# 全源最短路径

全源最短路径问题同时计算图中的每两个节点之间的最短路径，倘若节点之间存在路径的话。在简单的实现中，就是简单的计算从一个节点到其他节点的单源最短路径。计算出的最短路径数最多是 `O(V^2)`，其中 `V` 是图中顶点的个数。由于 SSSP 最多也是 `O(V^2)`，所以简单实现的总运行时间是 `O(V^4)`。

然而，通过使用 `Floyd-Warshall` 对图的邻接矩阵应用动态方法，运行时间可以到 `O(V^3)`。Floyd-Warshall 遍历整个邻接矩阵，对于每一对 start(`i`) 和 end(`j`) 的顶点，会将这两点之间的当前距离和经过图中的领域一个顶点(`k`)（如果 `i` ~> `k` 和 `k` ~> `j` 的路径存在的话）进行比较。通过对于每一个顶点对 (`i`, `j`) 都应用邻接矩阵中每个顶点 `k` 的对比来进行移动，所以对于每一个 `k` 会生成一个新的邻接矩阵 `D(k)`，每个值 `d(k)[i][j]` 是这样定义的：

<img src="img/weight_comparison_formula.png" width="400px" />

`w[i][j]` 是连接顶点 i 和顶点 j 在图的原始邻接矩阵的边的权重。

当算法记住每个细化的邻接和前导矩阵，它的空间复杂度是 `Θ(V^3)`，可以通过只记住最新的细化来优化到 `Θ(V^2)`。重建路径是一个递归的过程，需要 `Θ(V)` 的时间和 `Θ(V^2)` 的空间。

# 例子

对于下面的加权有向图

<img src="img/example_graph.png" width="200px" />

邻接矩阵 `w` 可表示为：

<img src="img/original_adjacency_matrix.png" width="200px" />

### 计算最短路径的权重

在算法的饿一开始，`D(0)` 是和 `w` 一样的，以下例外适用于比较方法：

1. 没有路径连接的顶点要用 `∞` 代替 `ø`
2. 对角线都是 `0`

下面是在上面的图中执行 Floyd-Warshall 之后生成的所有邻接矩阵：

<img src="img/d0.png" width="200px" />
<img src="img/d1.png" width="200px" />

<img src="img/d2.png" width="200px" />
<img src="img/d3.png" width="200px" />

最后一个就是结果，表示的是每个连接起始和结束顶点之间的最短路径的权重。在 `k = 2` 的步骤中，将右上角的值从“2”更改为“-4”的比较是这样的：

	k = 2, i = 0, j = 3
	d(k-1)[i][j] => d(1)[0][3] = 2
	d(k-1)[i][k] => d(1)[0][2] = 1
	d(k-1)[j][k] => d(1)[2][3] = -5

因此，对于在 `d(2)[0][3]` 的元素， `min(2, 2 + -5) => min(2, -4)` 生成了一个新的权重 `-4`，意思就是 1 ~> 4 之间的路径在这步之前是 1 -> 2 -> 4，权重是 -2，之后我们就发现了一个更短的路径是 1 -> 3 -> 4，权重是 -4。

### 重建路径

这是一个只查找所有节点对之间最短路径长度的算法；需要维护一个单独的结构来跟踪原来的索引然后重新构建最短路径。上面的图的每一步的前置矩阵如下：

<img src="img/pi0.png" width="200px" />
<img src="img/pi1.png" width="200px" />

<img src="img/pi2.png" width="200px" />
<img src="img/pi3.png" width="200px" />

# 项目结构

提供的 xcworkspace 允许在 playground 中工作，它从 xcodeproj 导入 APSP 框架对象。构建框架对象然后回到 playground 来开始。在 xcodeproj 也有一个测试对象。

在框架中有：

- 全源最短路径算法和结果结构的协议
- Floyd-Warshall 算法的实现

# TODO

- 实现简单的 `Θ(V^4)` 比较方法
- 实现稀疏图的 Johnson's 算法
- 实现其他优化版本的工具

# 参考

[算法导论 第 25 章，第三版，Cormen, Leiserson, Rivest and Stein](https://mitpress.mit.edu/books/introduction-algorithms](https://mitpress.mit.edu/books/introduction-algorithms)

*作者：[Andrew McKnight](https://github.com/armcknight) 翻译：Daisy*

