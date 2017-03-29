# 广度优先搜索

广度优先搜索(BFS)是用来遍历或搜索 [树](../Tree/README-CN.markdown) 或者 [图](../Graph/README-CN.markdown) 的算法。它是从一个源节点开始，在移动到下一个邻居之前，先探索节点的直接邻居节点。

广度优先搜索可以同时用于有向图和无向图。

## 动画示例

下面展示的是广度优先搜索在图中是如何工作的：

![Animated example of a breadth-first search](Images/AnimatedExample.gif)

当我们访问一个节点的时候，我们就将它变成黑色。同时将它的邻居节点放到一个[队列](../Queue/README-CN.markdown)里。在动画里，放入队列但还未访问的节点是灰色的。

我们跟着这个动画示例来看看。从源节点 `A` 开始，将它放到队列里，在动画里，这时就将节点 `A` 变成灰色的了。

```swift
queue.enqueue(A)
```

现在队列里是 `[ A ]`。思想是这样的，只要队列里有节点，就访问队列最前面的节点，然后将它的直接邻居节点，如果还没有被访问的话，就放到队列里。

为了开始遍历图，将第一个节点从队列中取出来，`A`，并且将它变成黑色。然后将它的两个邻居节点 `B` 和 `C` 放到队列里。将它们变成灰色。

```swift
queue.dequeue()   // A
queue.enqueue(B)
queue.enqueue(C)
```

现在队列是 `[ B, C ]`。`B` 出列，然后将 `B` 的邻居节点 `D` 和 `E` 入列。

```swift
queue.dequeue()   // B
queue.enqueue(D)
queue.enqueue(E)
```

现在队列是 `[ C, D, E ]`. `C` 出列, 并且将 `C` 的邻居节点 `F` 和 `G` 入列.

```swift
queue.dequeue()   // C
queue.enqueue(F)
queue.enqueue(G)
```

现在对烈士 `[ D, E, F, G ]`.`D` 出列, 它没有邻居节点。

```swift
queue.dequeue()   // D
```

现在队列是 `[ E, F, G ]`。`E` 出列并且将它的一个邻居额节点 `H`。注意，`B` 也是节点 `E` 的邻居节点，但是我们已经访问过 `B` 了，所以我们不能再将它放入到队列中。 

```swift
queue.dequeue()   // E
queue.enqueue(H)
```

现在对烈士 `[ F, G, H ]`。`F` 出列，它没有未访问过的邻居节点。 

```swift
queue.dequeue()   // F
```

现在对烈士 `[ G, H ]`。`G` 出列, 没有未访问过的邻居节点。

```swift
queue.dequeue()   // G
```

现在对烈士 `[ H ]`。`H` 出列， 没有未访问过的邻居节点。

```swift
queue.dequeue()   // H
```

队列现在空了，意思就是没有还没有被探索的节点了。探索节点的顺序是：`A`, `B`, `C`, `D`, `E`, `F`, `G`, `H`。

可以将这个展示成一棵树：

![The BFS tree](Images/TraversalTree.png)

节点的父节点就是“发现”这个节点的节点。树的根节点是开始广度优先搜索的节点。

对于一个无权图来说，这棵树定义了一个从其实节点到树中的每个节点的最短路径。所以广度优先搜索是是找到图中两个节点之间最短路径的方法。

## 代码

用队列简单实现广度优先搜索：

```swift
func breadthFirstSearch(_ graph: Graph, source: Node) -> [String] {
  var queue = Queue<Node>()
  queue.enqueue(source)

  var nodesExplored = [source.label]
  source.visited = true

  while let node = queue.dequeue() {
    for edge in node.neighbors {
      let neighborNode = edge.neighbor
      if !neighborNode.visited {
        queue.enqueue(neighborNode)
        neighborNode.visited = true
        nodesExplored.append(neighborNode.label)
      }
    }
  }

  return nodesExplored
}
```

当队列中有节点时，我们就访问第一个节点然后将它的直接邻居节点入列，如果它的邻居节点还没有被访问的话。

将代码放到 playground 里看看吧：

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

let nodesExplored = breadthFirstSearch(graph, source: nodeA)
print(nodesExplored)
```

输出结果是：`["a", "b", "c", "d", "e", "f", "g", "h"]`
   
## BFS 用来做什么好？

广度优先搜索可以用来解决许多问题。举几个例子：

* 计算源节点和每个节点之间的[最短路径](../Shortest%20Path/README-CN.markdown)（只用于无权图）
* 计算无权图的[最小生成树](../Minimum%20Spanning%20Tree%20(无权)/README-CN.markdown)

*作者：[Chris Pilcher](https://github.com/chris-pilcher) 和 Matthijs Hollemans 翻译：Daisy*


