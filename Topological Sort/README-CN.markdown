# 拓扑排序

拓扑排序是用来对有向图进行排序的算法。有向图就是对于每一条有向边 *u+v*，顶点 *u* 在 顶点 *v* 前面

换句话说，拓扑排序将 [有向无环图](../Graph/README-CN.markdown) 的顶点放到一起，所有的有向边都是从左到右的。

看看下面的图：

![Example](Images/Graph.png)

这个图有两个可能的拓扑排序：

![Example](Images/TopologicalSort.png)

拓扑顺序是 **S, V, W, T, X** 和 **S, W, V, T, X**。注意到了吗，所有的剪头都是从左到右的。

对于这个图来说，下面不是一个有效的拓扑排序，因为 **X** 和 **T** 不能在 **V** 之前：

![Example](Images/InvalidSort.png)

## 在哪里用？

假如你想从 Swift 算法俱乐部学习所有的算法和数据结构。刚开始时这看起来很可怕，但是我们可以用拓扑排序来让事情变得可组织。

既然你正在学习拓扑排序，那我们就以这个来举例子吧。在你完全理解拓扑排序之前你还要先学什么？好吧，拓扑排序用 [深度优先搜索](../Depth-First%20Search/README-CN.markdown) 和 [栈](../Stack/README-CN.markdown)。但是在学习深度优先搜索算法之前，需要了解什么是 [图](../Graph/README-CN.markdown)，另外，了解一下 [树](../Tree/README-CN.markdown) 也会有帮助。反过来，图和树又同时用到了链表对象，所以你可能要从上开始往下看。等等等等...

如果我们要用图的形式来展示这些对象的话就是下面这样的：

![Example](Images/Algorithms.png)

如果我们把每个算法都当做图中的一个顶点，你可以清楚地看到它们之间的依赖。为了学习一个东西，可能需要先了解别的东西。这就是拓扑排序的用途 —— 它会将事情摆出来好让你知道要先做哪个。

## 如何工作？

**第一步：找到所有入度为 0 的顶点**

一个顶点的 *入度* 就是指向这个顶点的边的条数。没有边指向的顶点的入度是 0。这些顶点就是拓扑排序开始的地方。

在上面的例子中，这些起始顶点就是那些不u需要任何先决条件的算法和数据结构；你不需要先学别的东西，因此，先从他们开始。

**第二步：用深度优先遍历图**

深度优先搜索是一个从某个顶点开始遍历图，然后尽可能地在回溯之前沿着每个分之往下探索的算法。为了更好的了解深度优先搜索，可以看看这个[详细解释](../Depth-First%20Search/README-CN.markdown)。

对每个入度为 0 的顶点都进行一次深度优先搜索。这会告诉我们有哪些顶点和这个起始顶点有连接。

**第三步：记住所有访问过的顶点**

在执行深度优先搜索的时候，我们需要维护一个包含所有访问过的顶点的列表。这是为了避免访问同一个顶点两次。

**第四步：将他们放到一起**

排序的最后一步就是将不同的深度优先搜索的结果有序地放到一起。

## 例子

看看下面的图

![Graph Example](Images/Example.png)

**第一步：** 入度为 0 的顶点是： **3, 7, 5**。这是我们的起始顶点。

**第二步：** 对每个顶点执行深度优先搜索，不用记录已经访问过了的顶点。
```
Vertex 3: 3, 10, 8, 9
Vertex 7: 7, 11, 2, 8, 9
Vertex 5: 5, 11, 2, 9, 10
```

**第三步：** 过滤掉在之前已经访问过了的顶点：
```
Vertex 3: 3, 10, 8, 9
Vertex 7: 7, 11, 2
Vertex 5: 5
```

**第四步：** 将三个深度优先搜索的结果拼接起来。最后的排序是 **5, 7, 11, 2, 3, 10, 8, 9** (重要：我们要将每个子系列里的结果添加到有序列表的 *front*。)

拓扑排序的结果是这样的：

![Result of the sort](Images/GraphResult.png)

> **注意：** 这不是这个图的位移的拓扑排序结果。例如，其他可能的结果是：**3, 7, 5, 10, 8, 11, 9, 2** 和 **3, 7, 5, 8, 11, 2, 9, 10**。所有符合箭头是从左到右的顺序都是可以的。

## 代码

下面是在 Swift 中拓扑排序的实现（[看这里](TopologicalSort1.swift)）：

```swift
extension Graph {
  public func topologicalSort() -> [Node] {
    // 1
    let startNodes = calculateInDegreeOfNodes().filter({ _, indegree in
      return indegree == 0
    }).map({ node, indegree in
      return node
    })
    
    // 2
    var visited = [Node : Bool]()
    for (node, _) in adjacencyLists {
      visited[node] = false
    }
    
    // 3
    var result = [Node]()
    for startNode in startNodes {
      result = depthFirstSearch(startNode, visited: &visited) + result
    }

    // 4    
    return result
  }
}
```

一些标记：

1. 找到所有顶点的入度，然后将所有入度为 0 的顶点放到 `startNodes` 数组。在这个图的实现中，顶点叫做 “节点”。这两个概念被写图代码的人混用。

2. `visited` 数组用来追踪在深度优先搜索里已经访问过的顶点。开始的时候，将所有元素都设置成 `false`。

3. 对每一个 `startNodes` 数组里的顶点执行深度优先搜索。这会返回一个有序的 `Node` 对象。我们将这个对象作为我们的 `result` 数组。

4. result 数组包含了所有拓扑有序的顶点。

> **注意：** 想要一个用深度优先搜索的有点不一样的拓扑排序的实现，可以看[这里](TopologicalSort3.swift)。它使用栈，并且不需要先找到所有入度为 0 的顶点。

## Kahn 的算法

即使深度优先搜索是执行拓扑排序的一个典型方法。还有其他算法也可以完成这个工作。

1. 找到每个顶点的入度。
2. 将没有祖先的节点放入一个新的叫 `leaders` 的数组。这些顶点的入度是 0，所以他们不需要依赖别的顶点。
3. 遍历 `leaders` 列表，然后将他们从图中一个个的移除。我们不会真的改变图，只是将它们所指向的入度减 1。效果是一样的。
4. 查看每个 leader 的直接邻居顶点。如果有任何一个的入度是 0，那么它们就没有任何祖先了，然后将这些顶点放到 `leaders` 数组里。
5. 重复这个过程直到没有可查看的顶点了。这个时候， leaders 数组里包含的顶点就是有序的。

这是一个 **O(n + m)** 的算法， **n** 是顶点的个数， **m** 是边的条数。可以看看[这里](TopologicalSort2.swift)的实现。

参考：我第一次读到关于这个算法是在 1993 年的 Dr. Dobb's 杂志的 Algorithm Alley 里。

*作者：Ali Hafizji and Matthijs Hollemans 翻译：Daisy*


