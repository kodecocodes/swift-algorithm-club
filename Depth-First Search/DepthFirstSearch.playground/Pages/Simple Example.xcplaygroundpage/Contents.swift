

func depthFirstSearch(graph: Graph, source: Node) -> [String] {
  var nodesExplored = [source.label]
  source.visited = true

  for edge in source.neighbors {
    if !edge.neighbor.visited {
      nodesExplored += depthFirstSearch(graph: graph, source: edge.neighbor)
    }
  }
  return nodesExplored
}



let graph = Graph()

let nodeA = graph.addNode(label: "a")
let nodeB = graph.addNode(label: "b")
let nodeC = graph.addNode(label: "c")
let nodeD = graph.addNode(label: "d")
let nodeE = graph.addNode(label: "e")
let nodeF = graph.addNode(label: "f")
let nodeG = graph.addNode(label: "g")
let nodeH = graph.addNode(label: "h")

graph.addEdge(source: nodeA, neighbor: nodeB)
graph.addEdge(source: nodeA, neighbor: nodeC)
graph.addEdge(source: nodeB, neighbor: nodeD)
graph.addEdge(source: nodeB, neighbor: nodeE)
graph.addEdge(source: nodeC, neighbor: nodeF)
graph.addEdge(source: nodeC, neighbor: nodeG)
graph.addEdge(source: nodeE, neighbor: nodeH)
graph.addEdge(source: nodeE, neighbor: nodeF)
graph.addEdge(source: nodeF, neighbor: nodeG)

let nodesExplored = depthFirstSearch(graph: graph, source: nodeA)
print(nodesExplored)
