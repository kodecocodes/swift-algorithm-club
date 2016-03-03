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