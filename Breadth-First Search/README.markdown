# Breadth-First Search

Breadth-first search (BFS) is an algorithm for traversing or searching tree or graph data structures. It starts at the tree root and explores the neighbor nodes first, before moving to the next level neighbors.

## Animated example

![Animated example of a breadth-first search](Images/Animated_BFS.gif)

## The code

Before we can code the breadth-first search algorithm we need to:
* Create an implementation of the graph
* Create an implementation of a queue

### Graph implementation

A graph is made up of nodes and edges. In the [animated example](#animated-example) the nodes are represented as circles and the edges are represented as lines.

Implementation of a node:
```swift
class Node {
  private var label: String
  private var neighbors: [Edge]

  init(label: String) {
    self.label = label
    neighbors = []
  }
}
```

Implementation of an edge:
```swift
class Edge {
  private var neighbor: Node

  init(neighbor: Node) {
    self.neighbor = neighbor
  }
}
```

Implementation of a graph:
```swift
class Graph {
  private var nodes = [Node]()

  func addNode(label: String) -> Node {
    let node = Node(label: label)
    nodes.append(node)
    return node
  }

  func addEdge(source: Node, neighbor: Node) {
    let edge = Edge(neighbor: neighbor)
    edge.neighbor = neighbor
    source.neighbors.append(edge)
  }
}
```

### Queue implementation

Implementation of simple queue:

```swift
class Queue<T> {
  private var top: QueueNode<T>!

  func enqueue(item: T) {
    if (top == nil) {
      top = QueueNode<T>()
    }

    if (top.item == nil) {
      top.item = item;
      return
    }

    let childToUse = QueueNode<T>()
    var current: QueueNode = top
    while current.next != nil {
      current = current.next!
    }

    childToUse.item = item;
    current.next = childToUse;
  }

  func dequeue() -> QueueNode<T>? {
    guard !isEmpty else {
      return nil
    }

    let itemToDequeue = top
    top = itemToDequeue.next
    return itemToDequeue
  }

  var isEmpty: Bool {
    get { return top == nil }
  }
}

class QueueNode<T> {
  var item: T?
  var next: QueueNode?
}
```

### Breadth-first search algorithm

Simple implementation of breadth-first search using queues:
```swift
func breadthFirstSearch(graph: Graph, root: Node) {
  print("Performing breadth-first search on '\(root.label)'")

  let q = Queue<Node>()
  q.enqueue(root)

  while !q.isEmpty {
    let current = q.dequeue()
    for edge in current!.item!.neighbors {
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

## See also

[Breadth-first search on Wikipedia](https://en.wikipedia.org/wiki/Breadth-first_search)

[Queues](http://waynewbishop.com/swift/stacks-queues) & [Graphs](http://waynewbishop.com/swift/graphs) by Wayne Bishop

*Written by [Chris Pilcher](https://github.com/chris-pilcher)*
