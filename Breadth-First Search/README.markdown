# Breadth-First Search

Breadth-first search (BFS) is an algorithm for traversing or searching [tree](../Tree/) or [graph](../Graph/) data structures. It starts at the tree source and explores the neighbor nodes first, before moving to the next level neighbors.

## Animated example

![Animated example of a breadth-first search](Images/Animated_BFS.gif)

Let's follow the animated example by using a [queue](../Queue/).

Start with the source node ``a`` and add it to a queue.
```swift
queue.enqueue(a)
```
The queue is now ``[ a ]``. Dequeue ``a`` and enqueue the neighbor nodes ``b`` and ``c``.
```swift
queue.dequeue(a)
queue.enqueue(b)
queue.enqueue(c)
```
The queue is now ``[ b, c ]``. Dequeue ``b`` and enqueue the neighbor nodes ``d`` and ``e``.
```swift
queue.dequeue(b)
queue.enqueue(d)
queue.enqueue(e)
```
The queue is now ``[ c, d, e ]``. Dequeue ``c`` and enqueue the neighbor nodes ``f`` and ``g``.
```swift
queue.dequeue(c)
queue.enqueue(f)
queue.enqueue(g)
```
The queue is now ``[ d, e, f, g ]``. Dequeue ``d`` which has no neighbor nodes.
```swift
queue.dequeue(d)
```
The queue is now ``[ e, f, g ]``. Dequeue ``e`` and enqueue the single neighbor node ``h``.
```swift
queue.dequeue(e)
queue.enqueue(h)
```
The queue is now ``[ f, g, h ]``. Dequeue ``f`` which has no neighbor nodes.
```swift
queue.dequeue(f)
```
The queue is now ``[ g, h ]``. Dequeue ``g`` which has no neighbor nodes.
```swift
queue.dequeue(g)
```
The queue is now ``[ h ]``. Dequeue ``h`` which has no neighbor nodes.
```swift
queue.dequeue(h)
```
The queue is now empty which means all nodes have been explored.

## The code

Simple implementation of breadth-first search using a queue:

```swift
func breadthFirstSearch(graph: Graph, source: Node) {
  var seenNodes = [source]
  var queue = Queue<Node>()
  queue.enqueue(source)

  print(source.label)

  while !queue.isEmpty {
    let current = queue.dequeue()!
    for edge in current.neighbors {
      let neighborNode = edge.neighbor
      if !seenNodes.contains(neighborNode) {
        queue.enqueue(neighborNode)
        seenNodes.append(neighborNode)
        print(neighborNode.label)
      }
    }
  }
}
```

Put this code in a playground and test it like so:
```swift
let graph = Graph() // Representing the graph from the animated example

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

breadthFirstSearch(graph, source: nodeA) // This will output: a, b, c, d, e, f, g, h
```

## Applications

Breadth-first search can be used to solve many problems, for example:

* Computing the shortest path between a source node and each of the other nodes
  * Only for unweighted graphs
* Calculating the minimum spanning tree on an unweighted graph

## Shortest path example

Breadth-first search can be used to compute the [shortest path](../Shortest Path/) between a source node and each of the other nodes because it explores all of the neighbor nodes before moving to the next level neighbors. Let's follow the animated example and calculate the shortest path to all the other nodes:

Start with the source node ``a`` and add it to a queue with a distance of ``0``.
```swift
queue.enqueue(a)
a.distance = 0
```
The queue is now ``[ a ]``. Dequeue ``a`` and enqueue the neighbor nodes ``b`` and ``c`` with a distance of ``1``.
```swift
queue.dequeue(a)
queue.enqueue(b)
b.distance = a.distance + 1 // result: 1
queue.enqueue(c)
c.distance = a.distance + 1 // result: 1
```
The queue is now ``[ b, c ]``. Dequeue ``b`` and enqueue the neighbor nodes ``d`` and ``e`` with a distance of ``2``.
```swift
queue.dequeue(b)
queue.enqueue(d)
d.distance = b.distance + 1 // result: 2
queue.enqueue(e)
e.distance = b.distance + 1 // result: 2
```

Continue until the queue is empty to calculate the shortest path to all other nodes.

Here's the code:
```swift
func breadthFirstSearchShortestPath(graph: Graph, source: Node) {
  var queue = Queue<Node>()
  queue.enqueue(source)
  source.distance = 0

  while !queue.isEmpty {
    let current = queue.dequeue()!
    for edge in current.neighbors {
      let neighborNode = edge.neighbor
      if !neighborNode.hasDistance {
        queue.enqueue(neighborNode)
        neighborNode.distance = current.distance! + 1
      }
    }
  }

  print(graph.nodes)
}
```

Put this code in a playground and test it like so:
```swift
breadthFirstSearchShortestPath(graph, source: nodeA)

// This will output:
// Node(label: a, distance: 0), Node(label: b, distance: 1), Node(label: c, distance: 1),
// Node(label: d, distance: 2), Node(label: e, distance: 2), Node(label: f, distance: 2),
// Node(label: g, distance: 2), Node(label: h, distance: 3)
```

## Minimum spanning tree example

Breadth-first search can be used to calculate the [minimum spanning tree](../Minimum Spanning Tree/) on an unweighted graph.

Let's calculate the minimum spanning tree for the following graph:

![Minimum spanning tree](Images/Minimum_Spanning_Tree.png)

*Note: the minimum spanning tree is represented by the bold edges.*

Start with the source node ``a`` and add it to a queue and mark it as visited.
```swift
queue.enqueue(a)
a.visited = true
```
The queue is now ``[ a ]``. Dequeue ``a`` and enqueue the neighbor nodes ``b`` and ``h`` and mark them as visited.
```swift
queue.dequeue(a)
queue.enqueue(b)
b.visited = true
queue.enqueue(h)
h.visited = true
```
The queue is now ``[ b, h ]``. Dequeue ``b`` and enqueue the neighbor node ``c`` mark it as visited. Remove the edge between ``b`` to ``h`` because ``h`` has already been visited.
```swift
queue.dequeue(b)
queue.enqueue(c)
c.visited = true
b.removeEdgeTo(h)
```
The queue is now ``[ h, c ]``. Dequeue ``h`` and enqueue the neighbor nodes ``g`` and ``i`` and mark them as visited.
```swift
queue.dequeue(h)
queue.enqueue(g)
g.visited = true
queue.enqueue(i)
i.visited = true
```
The queue is now ``[ c, g, i ]``. Dequeue ``c`` and enqueue the neighbor nodes ``d`` and ``f`` and mark them as visited. Remove the edge between ``c`` to ``i`` because ``i`` has already been visited.
```swift
queue.dequeue(c)
queue.enqueue(d)
d.visited = true
queue.enqueue(f)
f.visited = true
c.removeEdgeTo(i)
```
The queue is now ``[ g, i, d, f ]``. Dequeue ``g`` and remove the edges between ``g`` to ``f`` and ``g`` to ``i`` because ``f`` and ``i`` have already been visited.
```swift
queue.dequeue(g)
g.removeEdgeTo(f)
g.removeEdgeTo(i)
```
The queue is now ``[ i, d, f ]``. Dequeue ``i``.
```swift
queue.dequeue(i)
```
The queue is now ``[ d, f ]``. Dequeue ``d`` and enqueue the neighbor node ``e`` mark it as visited. Remove the edge between ``d`` to ``f`` because ``f`` has already been visited.
```swift
queue.dequeue(d)
queue.enqueue(e)
e.visited = true
d.removeEdgeTo(f)
```
The queue is now ``[ f, e ]``. Dequeue ``f``. Remove the edge between ``f`` to ``e`` because ``e`` has already been visited.
```swift
queue.dequeue(f)
f.removeEdgeTo(e)
```
The queue is now ``[ e ]``. Dequeue ``e``.
```swift
queue.dequeue(e)
```
The queue is now empty which means the minimum spanning tree has been computed.

Here's the code:
```swift
func breadthFirstSearchMinimumSpanningTree(graph: Graph, source: Node) -> Graph {
  let minimumSpanningTree = graph.duplicate()

  var queue = Queue<Node>()
  let sourceInMinimumSpanningTree = minimumSpanningTree.findNodeWithLabel(source.label)
  queue.enqueue(sourceInMinimumSpanningTree)
  sourceInMinimumSpanningTree.visited = true

  while !queue.isEmpty {
    let current = queue.dequeue()!
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

[Graph](../Graph/), [Tree](../Tree/), [Queues](../Queue/), [Shortest Path](../Shortest Path/), [Minimum Spanning Tree](../Minimum Spanning Tree/).

*Written by [Chris Pilcher](https://github.com/chris-pilcher)*
