# 最小生成树 (无权图)

最小生成树描述的是访问图中所有节点包含的最少边数的路径。

看看下面这个图：

![Graph](Images/Graph.png)

如果我们从节点 `a` 开始，想要访问每一个节点，那么最有效率的路径是什么呢？我们可以用最小生成树算法来计算这个。

下面是这个图的最小生成树。用粗边表示出来的部分：

![Minimum spanning tree](Images/MinimumSpanningTree.png)

画一颗更传统的树就是这样的：

![An actual tree](Images/Tree.png)

为了计算无权图的最小生成树，我们可以用 [广度优先搜索](../Breadth-First%20Search/README-CN.markdown) 算法。广度优先搜索是从一个源节点开始，在移动到下一级的邻居之前先探索节点的直接邻居节点来遍历图，如果我们通过有选择的移除边来调整这个算法，那么就可以将图变成一颗最小生成树。

我们来看看这个例子吧，从源节点 `a` 开始，将它加到队列并将它标记为已访问。

```swift
queue.enqueue(a)
a.visited = true
```

队列现在是 `[ a ]`，就像普通的广度优先搜索一样，我们将队列顶端的节点出列，`a`，然后将它的直接邻居节点 `b` 和 `h` 入列。将它们也标记为已访问。

```swift
queue.dequeue()   // a
queue.enqueue(b)
b.visited = true
queue.enqueue(h)
h.visited = true
```

现在队列是 `[ b, h ]`。b 出列，邻居节点 `c` 入列。将 `c` 标记为已访问。移除 `b` 到 `h` 的边，因为 `h` 已经被访问了。

```swift
queue.dequeue()   // b
queue.enqueue(c)
c.visited = true
b.removeEdgeTo(h)
```

队列现在是 `[ h, c ]`。`h` 出列，邻居节点 `g` 和 `i` 入列，将它们标记为已访问。

```swift
queue.dequeue()   // h
queue.enqueue(g)
g.visited = true
queue.enqueue(i)
i.visited = true
```

队列现在是 `[ c, g, i ]`。`c` 出列，邻居节点 `d` 和 `f` 入列，并且将它们标记为已访问。移除 `c` 和 `i` 之间的边，因为 `i` 已经被访问了。

```swift
queue.dequeue()   // c
queue.enqueue(d)
d.visited = true
queue.enqueue(f)
f.visited = true
c.removeEdgeTo(i)
```

队列现在是 `[ g, i, d, f ]`。`g` 出列。它所有的邻居节点都已经被访问过了，所以没有要入列的了。移除 `g` 到 `f` 和 `g` 到 `i` 的边，因为 `f` 和 `i` 都已经被访问了。

```swift
queue.dequeue()   // g
g.removeEdgeTo(f)
g.removeEdgeTo(i)
```

队列现在是 `[ i, d, f ]`。`i` 出列。这个节点没有别的要做的了。

```swift
queue.dequeue()   // i
```

队列现在是 `[ d, f ]`。出列 `d` 并且邻居节点 `e` 入列。将 `e` 标记为已访问。移除 `d` 到 `f` 的边，因为 `f` 已经被访问了。

```swift
queue.dequeue()   // d
queue.enqueue(e)
e.visited = true
d.removeEdgeTo(f)
```

队列现在是 `[ f, e ]`。出列 `f`。移除 `f` 到 `e` 的边，因为 `e` 已经被访问了。

```swift
queue.dequeue()   // f
f.removeEdgeTo(e)
```

队列现在是 `[ e ]`。出列 `e`。

```swift
queue.dequeue()   // e
```

队列现在空了，这就意味着最小生成树已经计算完成了。

下面是代码：

```swift
func breadthFirstSearchMinimumSpanningTree(graph: Graph, source: Node) -> Graph {
  let minimumSpanningTree = graph.duplicate()

  var queue = Queue<Node>()
  let sourceInMinimumSpanningTree = minimumSpanningTree.findNodeWithLabel(source.label)
  queue.enqueue(sourceInMinimumSpanningTree)
  sourceInMinimumSpanningTree.visited = true

  while let current = queue.dequeue() {
    for edge in current.neighbors {
      let neighborNode = edge.neighbor
      if !neighborNode.visited {
        neighborNode.visited = true
        queue.enqueue(neighborNode)
      } else {
        current.remove(edge)
      }
    }
  }

  return minimumSpanningTree
}
```

这个函数返回一个新的描述最小生成树的 `Graph` 对象。在图中，这就是只包含粗边的图。

将代码放到 playground 中测试一下：

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
let nodeI = graph.addNode("i")

graph.addEdge(nodeA, neighbor: nodeB)
graph.addEdge(nodeA, neighbor: nodeH)
graph.addEdge(nodeB, neighbor: nodeA)
graph.addEdge(nodeB, neighbor: nodeC)
graph.addEdge(nodeB, neighbor: nodeH)
graph.addEdge(nodeC, neighbor: nodeB)
graph.addEdge(nodeC, neighbor: nodeD)
graph.addEdge(nodeC, neighbor: nodeF)
graph.addEdge(nodeC, neighbor: nodeI)
graph.addEdge(nodeD, neighbor: nodeC)
graph.addEdge(nodeD, neighbor: nodeE)
graph.addEdge(nodeD, neighbor: nodeF)
graph.addEdge(nodeE, neighbor: nodeD)
graph.addEdge(nodeE, neighbor: nodeF)
graph.addEdge(nodeF, neighbor: nodeC)
graph.addEdge(nodeF, neighbor: nodeD)
graph.addEdge(nodeF, neighbor: nodeE)
graph.addEdge(nodeF, neighbor: nodeG)
graph.addEdge(nodeG, neighbor: nodeF)
graph.addEdge(nodeG, neighbor: nodeH)
graph.addEdge(nodeG, neighbor: nodeI)
graph.addEdge(nodeH, neighbor: nodeA)
graph.addEdge(nodeH, neighbor: nodeB)
graph.addEdge(nodeH, neighbor: nodeG)
graph.addEdge(nodeH, neighbor: nodeI)
graph.addEdge(nodeI, neighbor: nodeC)
graph.addEdge(nodeI, neighbor: nodeG)
graph.addEdge(nodeI, neighbor: nodeH)

let minimumSpanningTree = breadthFirstSearchMinimumSpanningTree(graph, source: nodeA)

print(minimumSpanningTree) // [node: a edges: ["b", "h"]]
                           // [node: b edges: ["c"]]
                           // [node: c edges: ["d", "f"]]
                           // [node: d edges: ["e"]]
                           // [node: h edges: ["g", "i"]]
```

> **Note:** On an unweighed graph, any spanning tree is always a minimal spanning tree. This means you can also use a [depth-first search](../Depth-First Search) to find the minimum spanning tree.
> **注意：** 在无权图中，任何生成树都是最小生成树。这就意味着你也可以用[深度优先搜索](../Depth-First%20Search/README-CN.markdown)来找到最小生成树。

*作者：[Chris Pilcher](https://github.com/chris-pilcher) 和 Matthijs Hollemans 翻译：Daisy*


