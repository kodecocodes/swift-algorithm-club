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
  print("Performing breadth-first search on '\(source.label)'")

  var seenNodes = [source]
  var queue = Queue<Node>()
  queue.enqueue(source)

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

breadthFirstSearch(graph, source: nodeA) // This will output: Performing breadth-first search on 'a', b, c, d, e, f, g, h
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

![Minimum spanning tree](Images/Minimum_Spanning_Tree.png)

The minimum spanning tree is represented by the bold edges.

TODO: explain steps to generate minimum spanning tree

## See also

[Graph](../Graph/), [Tree](../Tree/), [Queues](../Queue/), [Shortest Path](../Shortest Path/), [Breadth-first search on Wikipedia](https://en.wikipedia.org/wiki/Breadth-first_search), [Minimum spanning tree on Wikipedia](https://en.wikipedia.org/wiki/Minimum_spanning_tree).

*Written by [Chris Pilcher](https://github.com/chris-pilcher)*
