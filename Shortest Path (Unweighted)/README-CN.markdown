# 最短路径 (无权图)

目标：找到图中一个节点到另一个节点的最短路径。

假设我们有下面的图：

![Example graph](Images/Graph.png)

我们想找到从节点 A 到节点 F 的最短路径。

如果图是[无权图](../Graph/README-CN.markdown)，那么找到最短路径很简单：可以用广度优先搜索算法。对于有向图，可以用 Dijkstra 算法。

## 无向图：广度优先

[广度优先搜索](../Breadth-First%20Search/README-CN.markdown) 是用来遍历树或者图的方法。它是从源节点开始，在移动到下一层级的邻居之前，先探索节点的直接邻居节点。它有一个很方便的副作用就是，会自动计算源节点和树或者图中每个节点之间的最短路径。

广度优先搜索的结果可以用树来表示：

![The BFS tree](../Breadth-First Search/Images/TraversalTree.png)

树的根节点是开始广度优先搜索的节点。为了找到从节点 `A` 到其他任何节点的距离，只要简单计算树里的边即可。所以我们发现 `A` 和 `F` 之间的最短距离是 2。树不仅会告诉你最短路径是多少，也会告诉你怎么从 `A` 到 `F` （或其他任何节点）。

我们就来试试广度优先搜索并且计算从 `A` 到所有其他节点的最短路径。从源节点 `A` 开始，将它加到队列中，距离是 0。

```swift
queue.enqueue(element: A)
A.distance = 0
```

现在队列是 `A`。出列 `A` 并且将它的两个直接邻居节点 `B` 和 `C` 以 距离 `1` 入列。

```swift
queue.dequeue()   // A
queue.enqueue(element: B)
B.distance = A.distance + 1   // result: 1
queue.enqueue(element: C)
C.distance = A.distance + 1   // result: 1
```

现在队列是 `[ B, C ]`。出列 `B` 并且以距离 `2` 入列 `B` 的邻居节点 `D` 和 `E`。

```swift
queue.dequeue()   // B
queue.enqueue(element: D)
D.distance = B.distance + 1   // result: 2
queue.enqueue(element: E)
E.distance = B.distance + 1   // result: 2
```

队列现在是 `[ C, D, E ]`。出列 `C` 并且以距离 `2` 入列 `C` 的邻居节点 `F` 和 `G`。

```swift
queue.dequeue()   // C
queue.enqueue(element: F)
F.distance = C.distance + 1   // result: 2
queue.enqueue(element: G)
G.distance = C.distance + 1   // result: 2
```

一直往下执行直到队列为空并且访问了所有的节点。每次发现一个新节点，都要让它的父节点的 `distances`   加 1。就像你看到的，这就是[广度优先搜索](../Breadth-First%20Search/README-CN.markdown)算法做的事情，除了我们会追踪走过的距离之外。

下面是代码：

```swift
func breadthFirstSearchShortestPath(graph: Graph, source: Node) -> Graph {
  let shortestPathGraph = graph.duplicate()

  var queue = Queue<Node>()
  let sourceInShortestPathsGraph = shortestPathGraph.findNodeWithLabel(label: source.label)
  queue.enqueue(element: sourceInShortestPathsGraph)
  sourceInShortestPathsGraph.distance = 0

  while let current = queue.dequeue() {
    for edge in current.neighbors {
      let neighborNode = edge.neighbor
      if !neighborNode.hasDistance {
        queue.enqueue(element: neighborNode)
        neighborNode.distance = current.distance! + 1
      }
    }
  }

  return shortestPathGraph
}
```

将代码放到 playground 中试试：

```swift
let shortestPathGraph = breadthFirstSearchShortestPath(graph: graph, source: nodeA)
print(shortestPathGraph.nodes)
```

输出结果是：

	Node(label: a, distance: 0), Node(label: b, distance: 1), Node(label: c, distance: 1),
	Node(label: d, distance: 2), Node(label: e, distance: 2), Node(label: f, distance: 2),
	Node(label: g, distance: 2), Node(label: h, distance: 3)

> **Note:** This version of `breadthFirstSearchShortestPath()` does not actually produce the tree, it only computes the distances. See [minimum spanning tree](../Minimum Spanning Tree (Unweighted)/) on how you can convert the graph into a tree by removing edges.
> **注意：** 这个版本的 `breadthFirstSearchShortestPath()` 不会真的生成一棵树，它只计算距离。参考 [最小生成树](../Minimum%20Spanning%20Tree%20(无权)/README-CN.markdown) 看看如何通过移除边的方法将图转换成树。

*作者：[Chris Pilcher](https://github.com/chris-pilcher) 和 Matthijs Hollemans 翻译：Daisy*


