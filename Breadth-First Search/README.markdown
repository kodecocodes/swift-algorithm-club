# Breadth-First Search

Breadth-first search (BFS) is an algorithm for traversing or searching [tree](../Tree/) or [graph](../Graph/) data structures. It starts at a source node and explores the immediate neighbor nodes first, before moving to the next level neighbors.

## Animated example

Here's how breadth-first search works on a graph:

![Animated example of a breadth-first search](Images/AnimatedExample.gif)

When we visit a node, we color it black. We also put its neighbor nodes into a [queue](../Queue/). In the animation the nodes that are enqueued but not visited yet are shown in gray.

Let's follow the animated example. We start with the source node `A` and add it to a queue. In the animation this is shown as node `A` becoming gray.

```swift
queue.enqueue(A)
```

The queue is now `[ A ]`. The idea is that, as long as there are nodes in the queue, we visit the node that's at the front of the queue, and enqueue its immediate neighbor nodes if they have not been visited yet.

To start traversing the graph, we pull the first node off the queue, `A`, and color it black. Then we enqueue its two neighbor nodes `B` and `C`. This colors them gray.

```swift
queue.dequeue()   // A
queue.enqueue(B)
queue.enqueue(C)
```

The queue is now `[ B, C ]`. We dequeue `B`, and enqueue `B`'s neighbor nodes `D` and `E`.

```swift
queue.dequeue()   // B
queue.enqueue(D)
queue.enqueue(E)
```

The queue is now `[ C, D, E ]`. Dequeue `C`, and enqueue `C`'s neighbor nodes `F` and `G`.

```swift
queue.dequeue()   // C
queue.enqueue(F)
queue.enqueue(G)
```

The queue is now `[ D, E, F, G ]`. Dequeue `D`, which has no neighbor nodes.

```swift
queue.dequeue()   // D
```

The queue is now `[ E, F, G ]`. Dequeue `E` and enqueue its single neighbor node `H`. Note that `B` is also a neighbor for `E` but we've already visited `B`, so we're not adding it to the queue again.

```swift
queue.dequeue()   // E
queue.enqueue(H)
```

The queue is now `[ F, G, H ]`. Dequeue `F`, which has no unvisited neighbor nodes.

```swift
queue.dequeue()   // F
```

The queue is now `[ G, H ]`. Dequeue `G`, which has no unvisited neighbor nodes.

```swift
queue.dequeue()   // G
```

The queue is now `[ H ]`. Dequeue `H`, which has no unvisited neighbor nodes.

```swift
queue.dequeue()   // H
```

The queue is now empty, meaning that all nodes have been explored. The order in which the nodes were explored is `A`, `B`, `C`, `D`, `E`, `F`, `G`, `H`.

We can show this as a tree:

![The BFS tree](Images/TraversalTree.png)

The parent of a node is the one that "discovered" that node. The root of the tree is the node you started the breadth-first search from.

For an unweighted graph, this tree defines a shortest path from the starting node to every other node in the tree. So breadth-first search is one way to find the shortest path between two nodes in a graph.

Breadth-first search can be used on directed and undirected graphs.

## The code

Simple implementation of breadth-first search using a queue:

```swift
func breadthFirstSearch(graph: Graph, source: Node) -> [String] {
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

While there are nodes in the queue, we visit the first one and then enqueue its immediate neighbors if they haven't been visited yet.

Put this code in a playground and test it like so:

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

This will output: `["a", "b", "c", "d", "e", "f", "g", "h"]`
   
## Applications

Breadth-first search can be used to solve many problems. A small selection:

* Computing the shortest path between a source node and each of the other nodes (only for unweighted graphs).
* Calculating the minimum spanning tree on an unweighted graph.

## Shortest path example

Breadth-first search can be used to compute the [shortest path](../Shortest Path/) between a source node and each of the other nodes in the tree or graph, because it explores all of the immediate neighbor nodes first before moving to the next level neighbors.

Let's follow the animated example and calculate the shortest path to all the other nodes. Start with the source node ``a`` and add it to a queue with a distance of ``0``.

```swift
queue.enqueue(a)
a.distance = 0
```

The queue is now ``[ a ]``. Dequeue ``a`` and enqueue its two neighbor nodes ``b`` and ``c`` with a distance of ``1``.

```swift
queue.dequeue()   // a
queue.enqueue(b)
b.distance = a.distance + 1   // result: 1
queue.enqueue(c)
c.distance = a.distance + 1   // result: 1
```

The queue is now ``[ b, c ]``. Dequeue ``b`` and enqueue `b`'s neighbor nodes ``d`` and ``e`` with a distance of ``2``.

```swift
queue.dequeue()   // b
queue.enqueue(d)
d.distance = b.distance + 1   // result: 2
queue.enqueue(e)
e.distance = b.distance + 1   // result: 2
```

Continue until the queue is empty to calculate the shortest path to all other nodes.

Here's the code:

```swift
func breadthFirstSearchShortestPath(graph: Graph, source: Node) -> Graph {
  let shortestPathGraph = graph.duplicate()

  var queue = Queue<Node>()
  let sourceInShortestPathsGraph = shortestPathGraph.findNodeWithLabel(source.label)
  queue.enqueue(sourceInShortestPathsGraph)
  sourceInShortestPathsGraph.distance = 0

  while let current = queue.dequeue() {
    for edge in current.neighbors {
      let neighborNode = edge.neighbor
      if !neighborNode.hasDistance {
        queue.enqueue(neighborNode)
        neighborNode.distance = current.distance! + 1
      }
    }
  }

  return shortestPathGraph
}
```

Put this code in a playground and test it like so:

```swift
let shortestPathGraph = breadthFirstSearchShortestPath(graph, source: nodeA)
print(shortestPathGraph.nodes)
```

This will output:

	Node(label: a, distance: 0), Node(label: b, distance: 1), Node(label: c, distance: 1),
	Node(label: d, distance: 2), Node(label: e, distance: 2), Node(label: f, distance: 2),
	Node(label: g, distance: 2), Node(label: h, distance: 3)

## Minimum spanning tree example

Breadth-first search can be used to calculate the [minimum spanning tree](../Minimum Spanning Tree/) on an unweighted graph. A minimum spanning tree describes a path that contains the smallest number of edges that are needed to visit every node in the graph.

Let's calculate the minimum spanning tree for the following graph:

![Minimum spanning tree](Images/Minimum_Spanning_Tree.png)

*Note: the minimum spanning tree is represented by the bold edges.*

Start with the source node ``a`` and add it to a queue and mark it as visited.

```swift
queue.enqueue(a)
a.visited = true
```

The queue is now ``[ a ]``. Dequeue ``a`` and enqueue its immediate neighbor nodes ``b`` and ``h`` and mark them as visited.

```swift
queue.dequeue()   // a
queue.enqueue(b)
b.visited = true
queue.enqueue(h)
h.visited = true
```

The queue is now ``[ b, h ]``. Dequeue ``b`` and enqueue the neighbor node ``c`` mark it as visited. Remove the edge between ``b`` to ``h`` because ``h`` has already been visited.

```swift
queue.dequeue()   // b
queue.enqueue(c)
c.visited = true
b.removeEdgeTo(h)
```

The queue is now ``[ h, c ]``. Dequeue ``h`` and enqueue the neighbor nodes ``g`` and ``i`` and mark them as visited.

```swift
queue.dequeue()   // h
queue.enqueue(g)
g.visited = true
queue.enqueue(i)
i.visited = true
```

The queue is now ``[ c, g, i ]``. Dequeue ``c`` and enqueue the neighbor nodes ``d`` and ``f`` and mark them as visited. Remove the edge between ``c`` to ``i`` because ``i`` has already been visited.

```swift
queue.dequeue()   // c
queue.enqueue(d)
d.visited = true
queue.enqueue(f)
f.visited = true
c.removeEdgeTo(i)
```

The queue is now ``[ g, i, d, f ]``. Dequeue ``g`` and remove the edges between ``g`` to ``f`` and ``g`` to ``i`` because ``f`` and ``i`` have already been visited.

```swift
queue.dequeue()   // g
g.removeEdgeTo(f)
g.removeEdgeTo(i)
```

The queue is now ``[ i, d, f ]``. Dequeue ``i``.

```swift
queue.dequeue()   // i
```

The queue is now ``[ d, f ]``. Dequeue ``d`` and enqueue the neighbor node ``e`` mark it as visited. Remove the edge between ``d`` to ``f`` because ``f`` has already been visited.

```swift
queue.dequeue()   // d
queue.enqueue(e)
e.visited = true
d.removeEdgeTo(f)
```

The queue is now ``[ f, e ]``. Dequeue ``f``. Remove the edge between ``f`` to ``e`` because ``e`` has already been visited.

```swift
queue.dequeue()   // f
f.removeEdgeTo(e)
```

The queue is now ``[ e ]``. Dequeue ``e``.

```swift
queue.dequeue()   // e
```

The queue is now empty, which means the minimum spanning tree has been computed.

Here's the code:

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

This function returns a new `Graph` object that describes just the minimum spanning tree. In the figure, that would be the graph containing just the bold edges.

Put this code in a playground and test it like so:

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

## See also

[Graph](../Graph/), [Tree](../Tree/), [Queue](../Queue/), [Shortest Path](../Shortest Path/), [Minimum Spanning Tree](../Minimum Spanning Tree/).

*Written by [Chris Pilcher](https://github.com/chris-pilcher) and Matthijs Hollemans*
