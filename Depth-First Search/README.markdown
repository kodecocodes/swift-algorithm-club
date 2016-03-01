# Depth-First Search

Depth-first search (DFS) is an algorithm for traversing or searching [tree](../Tree/) or [graph](../Graph/) data structures. It starts at the tree source and explores as far as possible along each branch before backtracking.

## The code

Simple implementation of breadth-first search using a queue:

```swift
func depthFirstSearch(graph: Graph, source: Node) -> [String] {
  var nodesExplored: [String] = [source.label]
  source.visited = true

  // Iterate through all neighbors, and for each one visit all of its neighbors
  for edge in source.neighbors {
    let neighbor: Node = edge.neighbor

    if (!neighbor.visited) {
      nodesExplored += depthFirstSearch(graph, source: neighbor)
    }
  }
  return nodesExplored
}
```

Put this code in a playground and test it like so:

```swift
let graph = Graph()   // Representing the graph from the animated example

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
* Among others
