# Depth-First Search

Depth-first search (DFS) is an algorithm for traversing or searching [tree](../Tree/) or [graph](../Graph/) data structures. It starts at a source node and explores as far as possible along each branch before backtracking.

[TODO: this is a work-in-progress]

## The code

Simple recursive implementation of depth-first search:

```swift
func depthFirstSearch(graph: Graph, source: Node) -> [String] {
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

Where a [breadth-first search](../Breadth-First Search/) visits all immediate neighbors first, a depth-first search tries to go as deep down the tree or graph as it can.

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

let nodesExplored = depthFirstSearch(graph, source: nodeA)
print(nodesExplored)
```

This will output: `["a", "b", "d", "e", "h", "c", "f", "g"]`
   
## Applications

Depth-first search can be used to solve many problems, for example:

* Finding connected components of a sparse graph
* Topological sorting of nodes in a graph
* Finding bridges of a graph (see: [Bridges](https://en.wikipedia.org/wiki/Bridge_(graph_theory)#Bridge-finding_algorithm))
* And lots of others!

*Written for Swift Algorithm Club by Paulo Tanaka*
