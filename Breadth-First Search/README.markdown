# Breadth-First Search

Breadth-first search (BFS) is an algorithm for traversing or searching tree or graph data structures. It starts at the tree root and explores the neighbor nodes first, before moving to the next level neighbors.

## Animated example

![Animated example of a breadth-first search](Images/Animated_BFS.gif)

Let's follow the animated example by using a [queue](../Queue/).

Start with the root node ``a`` and add it to a queue.
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
func breadthFirstSearch(graph: Graph, root: Node) {
  print("Performing breadth-first search on '\(root.label)'")

  var q = Queue<Node>()
  q.enqueue(root)

  while !q.isEmpty {
    let current = q.dequeue()
    for edge in current!.neighbors {
      let neighborNode = edge.neighbor
      q.enqueue(neighborNode)

      print(neighborNode.label)
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

breadthFirstSearch(graph, root: nodeA) // This will output: Performing breadth-first search on 'a', b, c, d, e, f, g, h

```

## Applications

**TODO**: list a few common Applications

# Finding the shortest path

**TODO**: step through example

## See also

[Graphs](../Graph/), [Queues](../Queue/), [Breadth-first search on Wikipedia](https://en.wikipedia.org/wiki/Breadth-first_search).

*Written by [Chris Pilcher](https://github.com/chris-pilcher)*
