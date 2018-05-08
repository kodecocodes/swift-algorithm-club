# Depth-First Search

> This topic has been tutorialized [here](https://www.raywenderlich.com/157949/swift-algorithm-club-depth-first-search)

Depth-first search (DFS) is an algorithm for traversing or searching [tree](../Tree/) or [graph](../Graph/) data structures. It starts at a source node and explores as far as possible along each branch before backtracking.

Depth-first search can be used on both directed and undirected graphs.

## Animated example

Here's how depth-first search works on a graph:

![Animated example](Images/AnimatedExample.gif)

Let's say we start the search from node `A`. In depth-first search we look at the starting node's first neighbor and visit that. In the example that is node `B`. Then we look at node `B`'s first neighbor and visit it. This is node `D`. Since `D` doesn't have any unvisited neighbors of its own, we backtrack to node `B` and go to its other neighbor `E`. And so on, until we've visited all the nodes in the graph.

Each time we visit the first neighbor and keep going until there's nowhere left to go, and then we backtrack to a point where there are again nodes to visit. When we've backtracked all the way to node `A`, the search is complete.

For the example, the nodes were visited in the order `A`, `B`, `D`, `E`, `H`, `F`, `G`, `C`.

The depth-first search process can also be visualized as a tree:

![Traversal tree](Images/TraversalTree.png)

The parent of a node is the one that "discovered" that node. The root of the tree is the node you started the depth-first search from. Whenever there's a branch, that's where we backtracked.

## The code

Simple recursive implementation of depth-first search:

```swift
func depthFirstSearch(_ graph: Graph, source: Node) -> [String] {
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

Where a [breadth-first search](../Breadth-First%20Search/) visits all immediate neighbors first, a depth-first search tries to go as deep down the tree or graph as it can.

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

let nodesExplored = depthFirstSearch(graph, source: nodeA)
print(nodesExplored)
```

This will output: `["a", "b", "d", "e", "h", "f", "g", "c"]`

## What is DFS good for?

Depth-first search can be used to solve many problems, for example:

* Finding connected components of a sparse graph
* [Topological sorting](../Topological%20Sort/) of nodes in a graph
* Finding bridges of a graph (see: [Bridges](https://en.wikipedia.org/wiki/Bridge_(graph_theory)#Bridge-finding_algorithm))
* And lots of others!

*Written for Swift Algorithm Club by Paulo Tanaka and Matthijs Hollemans*
