# 图

图是像这样的东西：

![A graph](Images/Graph.png)

在计算机科学术语中，图是与一组 *边* 配对的 *顶点* 的集合。顶点是圆的，边是顶点之间的线。边将一个顶点和其他顶点连起来。

> **注意：** 顶点有时也叫做 “节点”，边也叫做 “连接”。

例如，图可以表示一个社交网络。每个人是一个顶点，互相知道的人之间通过边连接。一个历史上不太准确的例子是：

![Social network](Images/SocialNetwork.png)

图有各种形状和大小。边可以有 *权重*，给每条边赋值一个正数或者负数。想想表示飞行航线的图。城市是顶点，线路是边。边的权重可以用来描述飞行时间或者票价。

![Airplane flights](Images/Flights.png)

在这个假设的航线里，从三藩市到莫斯科经过纽约最便宜的。

边也可以是 *有向* 的。目前为止你看到的边都是无向的，所以如果 Ada 知道 Charles，那么 Charles 也知道 Ada。另一方面，有向边表示的单边的关系。从顶点 X 到 Y 的有向边连接 X 到 Y，但是*不是* Y 到 X。

继续用航线举例子，从三藩市到阿拉斯加的朱诺的有向边表示从三藩市到朱诺有航线，但不表示从朱诺到三藩市也有（我假设你要回来）。

![One-way flights](Images/FlightsDirected.png)

下面的也是图：

![Tree and linked list](Images/TreeAndList.png)

左边的是 [树](../Tree/README-CN.markdown) 结构，右边的是[ 链表](../Linked%20List/README-CN.markdown)。他们都可以看做是图，只不过是更简单的形式。毕竟他们都有顶点（节点）和边（连接）。

我给你展示的第一张图包含一个 *循环*，循环就是你从一个顶点出发，沿着一条路，然后又回到了这个顶点。树是没有这样的循环的图。

另外一个常用的图是 *有向无环图* 或 DAG：

![DAG](Images/DAG.png)

像树一样它也没有环（不管从哪里开始，都没有可以回到起始顶点的路径），但是与树不同的是，边是有方向的并且形状不会形成层级关系。

## 为什么使用图？

可能你正在耸肩和进行思考，有什么大不了的？好吧，起始图是一种非常有用的数据结构。

如果有一个编程问题，可以用顶点来描述数据，用边来描述顶点之间的关系，那么就可以用图来画出问题，并且用已知的图算法，比如 [广度优先](../Breadth-First%20Search/README-CN.markdown) 或 [深度优先](../Depth-First%20Search/README-CN.markdown) 来找到一个解决方法。

例如，假设你有一堆任务，其中有些任务需要等其他的任务完成才能开始。你就可以用有向无环图来表示：

![Tasks as a graph](Images/Tasks.png)

每个顶点代表一个任务。两个顶点之间的边的意思是，源任务必须在目标任务开始之前结束。所以任务 C 不能在 B 和 D 完成之前开始，并且 B 和 D 不能在 A 结束之前开始。

现在问题是用图表示的，可以使用 [深度优先](../Depth-First%20Search/README-CN.markdown) 来执行 [拓扑排序](../Topological%20Sort/README-CN.markdown)。这样任务就可以以最优的顺序来执行，可以减少等待任务完成的时间（一个可能的顺序是 A, B, D, E, C, F, G, H, I, J, K.）。

不管什么时候遇到一个困难的编程问题是，问问你自己，“我怎样才能用一个图来表示这个问题？” 图就是用来表示数据之间的关系的。诀窍就是你如何定义 “关系”。

如果你是一个音乐家，你可能会感激这个图：

![Chord map](Images/ChordMap.png)

顶点是 C 打掉音阶的和弦。边 —— 也就是和弦之间的关系 —— 表示的是 [一个和弦如何到下一个和弦](http://mugglinworks.com/chordmaps/genmap.htm)。这是一个有向图，所以箭头的方向就表示了怎么才能从一个和弦到下一个和弦。这也是一个权重图，边的权重 —— 通过线的粗细来描绘 —— 表示的是和弦之间的关系强弱。就像你看到的，G7 和弦后面可能跟着一个 C 和弦，很少会跟一个 Am 和弦。

你可能在不知道图的情况下已经使用过它了。你的数据模型也是一个图（来自 Apple 的 Core Data 文档）：

![Core Data model](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreDataVersioning/Art/recipe_version2.0.jpg)

另一个经常被程序员用到的图是状态机，在状态机里边描绘的是状态之间的转换条件。下面是我的猫的一个状态机模型：

![State machine](Images/StateMachine.png)

图是非常酷的。Facebook 从他们的社交图里挣了一大笔了。如果你想学任何数据结构，那一定是图和庞大的标准图算法。

## 顶点和边，天哪！

理论上来说，图指示一堆顶点和边对象。但是要怎么用代码来表述这些呢？

有两个主要的策略：邻接链表和邻接矩阵。

**邻接链表** 在邻接链表的实现中，每个顶点存储一个从这个顶点出发的边的链表。例如，如果顶点 A 有一条道顶点 B、C 和 D 的边，那么顶点 A 就会有一个包含 3 条边的链表。

![Adjacency list](Images/AdjacencyList.png)

邻接链表描述的是出去的边。A 有一条到 B 的边但是 B 没有一条回到 A 的边，所以 A 不会出现在 B 的邻接链表里。找到一条边或者两个顶点之间的权重是非常昂贵的，因为没有对于边的随机访问 —— 必须遍历整个链表直到找到它。

**邻接矩阵** 在邻接矩阵的视线中，有行和列的矩阵表示的是存储了用来表示顶点之间是否连接以及权重是多少的顶点。例如，如果有一个从顶点 A 到顶点 B 的边的权重是 5.6，那么对于顶点 A 行，顶点 B 列的项就是指 5.6：

![Adjacency matrix](Images/AdjacencyMatrix.png)

添加一个顶点到图中是昂贵的，因为新的矩阵结构必须要有足够的空间来保留新的行/列，并且已经存在的结构要拷贝到新的里面。

所以你会用哪个呢？大部分时候，邻接链表是正确的方法。下面有更多他们之间的对比。

假设 *V* 是图中顶点的个数，*E* 是边的条数。我们有：

| 操作       | 邻接链表 | 邻接矩阵 |
|-----------------|----------------|------------------|
| 存储空间   | O(V + E)       | O(V^2)           |
| 添加顶点      | O(1)           | O(V^2)           |
| 添加边        | O(1)           | O(1)             |
| 查询连接 | O(V)           | O(1)             |

“查询连接” 指的是我们视图确定一个给定顶点是不是另一个顶点的直接邻居。对于邻接链表来说查询连接的时间复杂度是 **O(V)**，因为在最差的情况下，顶点与 *每个* 其他顶点都由连接。

在 *稀疏* 图的例子中，每个顶点只连接到其他几个顶点，连接链表是存储边最好的方式。如果图是 *密集* 的，每个顶点与其他大部分的顶点都由连接，那么矩阵是就一个好的选择。

我们会展示给你邻接链表和邻接矩阵的实现。

## 代码：边和顶点

由边组成的顶点的临街链表：

```swift
public struct Edge<T>: Equatable where T: Equatable, T: Hashable {

  public let from: Vertex<T>
  public let to: Vertex<T>

  public let weight: Double?

}
```

这个结构描述的是 “From” 和 “to" 顶点以及他们的权重值。注意到，`Edge` 对象始终是有方向的，一个单向联系（在上面的解释中是用箭头表示的）。如果你想变成无向的连接，你还需要在相反的方向上添加一个 `Edge` 对象。每个 `Edge` 存储的是一个可选的权重，所以他们可以用来描述有权重和无权重的图。

`Vertex` 看起来是这样的：

```swift
public struct Vertex<T>: Equatable where T: Equatable, T: Hashable {

  public var data: T
  public let index: Int

}
```

它用泛型类型 `T` 存储任意数据，数据必须是 `Hashable` 的以保证唯一性，并且也要是 `Equatable` 的。顶点本身是 `Equatable` 的。

## 代码：图

> **注意：** 有许多方法可以用来实现图。这里给出的代码只是一种可能的实现。你可能想定制图代码到每个你想解决的问题。例如，你的边可能不需要 `weight` 属性，或者你不需要区分有向边和无向边。

下面是一个非常简单的图的例子：

![Demo](Images/Demo1.png)

我们可以用邻接矩阵或者临街链表来表示。实现这些概念的类也是从 `AbstractGraph` 继承了一些共同的 API，所以他们可以用同样的方法创建，但是背后却用的是不同的优化的数据结构。 

我们用每一种表现方式来创建一些有向的有权重的图来存储例子中的数据：

```swift
for graph in [AdjacencyMatrixGraph<Int>(), AdjacencyListGraph<Int>()] {

  let v1 = graph.createVertex(1)
  let v2 = graph.createVertex(2)
  let v3 = graph.createVertex(3)
  let v4 = graph.createVertex(4)
  let v5 = graph.createVertex(5)

  graph.addDirectedEdge(v1, to: v2, withWeight: 1.0)
  graph.addDirectedEdge(v2, to: v3, withWeight: 1.0)
  graph.addDirectedEdge(v3, to: v4, withWeight: 4.5)
  graph.addDirectedEdge(v4, to: v1, withWeight: 2.8)
  graph.addDirectedEdge(v2, to: v5, withWeight: 3.2)

}
```

就像之前提到的，创建无向边需要创建两条有向边。如果我们想要无向图，我们要调用这些方法，它帮我们做了一些工作：

```swift
  graph.addUndirectedEdge(v1, to: v2, withWeight: 1.0)
  graph.addUndirectedEdge(v2, to: v3, withWeight: 1.0)
  graph.addUndirectedEdge(v3, to: v4, withWeight: 4.5)
  graph.addUndirectedEdge(v4, to: v1, withWeight: 2.8)
  graph.addUndirectedEdge(v2, to: v5, withWeight: 3.2)
```

在想要无权重图的时候我们可以将 `nil` 作为 `withWeight` 的参数。

## 代码：邻接链表

为了维护邻接链表，有一个类来讲边的列表对应到顶点。图只是简单的维护了这种对象的一个数组，然后在必要的时候修改他们。


```swift
private class EdgeList<T> where T: Equatable, T: Hashable {

  var vertex: Vertex<T>
  var edges: [Edge<T>]? = nil

  init(vertex: Vertex<T>) {
    self.vertex = vertex
  }

  func addEdge(_ edge: Edge<T>) {
    edges?.append(edge)
  }

}
```

他们是用一个类来而不是结构体来实现的，所以我们可以用引用来修改他们，在这里面，比如要添加一条新的边到某个顶点，顶点本身已经有一个边的列表了：

```swift
open override func createVertex(_ data: T) -> Vertex<T> {
  // check if the vertex already exists
  let matchingVertices = vertices.filter() { vertex in
    return vertex.data == data
  }

  if matchingVertices.count > 0 {
    return matchingVertices.last!
  }

  // if the vertex doesn't exist, create a new one
  let vertex = Vertex(data: data, index: adjacencyList.count)
  adjacencyList.append(EdgeList(vertex: vertex))
  return vertex
}
```

这个例子的邻接链表看起来是这样的：

```
v1 -> [(v2: 1.0)]
v2 -> [(v3: 1.0), (v5: 3.2)]
v3 -> [(v4: 4.5)]
v4 -> [(v1: 2.8)]
```

`a -> [(b: w), ...]` 这种通用形式的意思是存在一条从 `a` 到 `b` 的边，它的权重是 `w`（也存在从 `a` 到其他顶点的边）。

## 代码：邻接矩阵

我们用一个二维数组 `[[Double?]]` 来跟踪一个邻接矩阵。`nil` 表示没有边，任何其他的值都表示有一条给定权重的边。如果 `adjacencyMatrix[i][j]` 不是 `nil`，那么就有一条从顶点 `i` 到顶点 `j` 的边。

为了用顶点来索引矩阵，我们要用到 `Vertex` 中的 `index` 属性，它会在遍历图对象创建顶点时赋值。当创建新顶点的时候，图也必须改变矩阵的大小：

```swift
open override func createVertex(_ data: T) -> Vertex<T> {
  // check if the vertex already exists
  let matchingVertices = vertices.filter() { vertex in
    return vertex.data == data
  }

  if matchingVertices.count > 0 {
    return matchingVertices.last!
  }

  // if the vertex doesn't exist, create a new one
  let vertex = Vertex(data: data, index: adjacencyMatrix.count)

  // Expand each existing row to the right one column.
  for i in 0 ..< adjacencyMatrix.count {
    adjacencyMatrix[i].append(nil)
  }

  // Add one new row at the bottom.
  let newRow = [Double?](repeating: nil, count: adjacencyMatrix.count + 1)
  adjacencyMatrix.append(newRow)

  _vertices.append(vertex)

  return vertex
}
```

邻接矩阵看起来是这样的：

	[[nil, 1.0, nil, nil, nil]    v1
	 [nil, nil, 1.0, nil, 3.2]    v2
	 [nil, nil, nil, 4.5, nil]    v3
	 [2.8, nil, nil, nil, nil]    v4
	 [nil, nil, nil, nil, nil]]   v5

	  v1   v2   v3   v4   v5


## 参考

这篇文章描述了什么是图以及如何实现基本的数据结构。但是我们还有许多文章是图的一些实践，所以也去看看那些文章吧！

*作者：Matthijs Hollemans 翻译：Daisy*


