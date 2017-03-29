# 深度优先搜索

深度优先搜索（DFS）是用来遍历或搜索 [树](../Tree/README-CN.markdown) 或者 [图](../Graph/README-CN.markdown) 的算法。从源节点开始，一直走到每个分支的尽头才回溯。

深度优先搜索可以用于有向图和无向图。

## 动画示例

下面是展示深度优先搜索在图上是如何工作的：

![Animated example](Images/AnimatedExample.gif)

假设我们从节点 `A` 开始。在深度优先搜索里，我们查找源节点的第一个邻居节点并访问它。在例子中是节点 `B`。然后我们查找节点 `B` 的第一个邻居节点并且访问它。这就是节点 `D`。因为 `D` 没有任何未访问的邻居，我们就回到节点 `B` 然后取到它的下一个邻居节点 `E`。直到我们访问了树中所有的节点。

每次访问第一个邻居节点时都是一直往下走直到没有地方可去，然后我们就回到一个还有节点可以访问的地方。当回溯了所有的路径到达节点 `A` 时，搜索就结束了。

对于这个例子来说，节点的访问顺序是：`A`, `B`, `D`, `E`, `H`, `F`, `G`, `C`。

深度优先搜索过程也可以用一棵树来表示：

![Traversal tree](Images/TraversalTree.png)

节点的父节点是“发现”该节点的节点。根节点就是开始深度优先搜索的节点。有分支的地方就是我们回溯的地方。

## 代码

深度优先搜索的简单递归实现：

```swift
func depthFirstSearch(_ graph: Graph, source: Node) -> [String] {
  var nodesExplored = [source.label]
  source.visited = true

  for edge in source.neighbors {
    if !edge.neighbor.visited {
      nodesExplored += depthFirstSearch(graph, source: edge.neighbor)
    }
  }
  return nodesExplored
}
```

[广度优先搜索](../Breadth-First%20Search/README-CN.markdown)总是先访问所有的邻居节点，而深度优先搜索则是尽可能地往树或者图的深处走。

将代码放到 playground 里测试：

```swift
let graph = Graph()

let nodeA = graph.addNode("a")
let nodeB = graph.addNode("b")
let nodeC = graph.addNode("c")
let nodeD = graph.addNode("d")
let nodeE = graph.addNode("e")
let nodeF = graph.addNode("f")
let nodeG = graph.addNode("g")
let nodeH = graph.addNode("h")

graph.addEdge(nodeA, neighbor: nodeB)
graph.addEdge(nodeA, neighbor: nodeC)
graph.addEdge(nodeB, neighbor: nodeD)
graph.addEdge(nodeB, neighbor: nodeE)
graph.addEdge(nodeC, neighbor: nodeF)
graph.addEdge(nodeC, neighbor: nodeG)
graph.addEdge(nodeE, neighbor: nodeH)
graph.addEdge(nodeE, neighbor: nodeF)
graph.addEdge(nodeF, neighbor: nodeG)

let nodesExplored = depthFirstSearch(graph, source: nodeA)
print(nodesExplored)
```

输出结果： `["a", "b", "d", "e", "h", "f", "g", "c"]`
   
## DFS 用来做什么好？

深度优先搜索可以用来解决许多问题，例如：

* 找到稀疏图的有连接的部分
* 图中节点的 [拓扑排序](../Topological%20Sort/README-CN.markdown)
* 找到图中的桥 (参考：[桥](https://en.wikipedia.org/wiki/Bridge_(graph_theory)#Bridge-finding_algorithm))
* 以及很多其他的！

*作者：Paulo Tanaka and Matthijs Hollemans 翻译：Daisy*


