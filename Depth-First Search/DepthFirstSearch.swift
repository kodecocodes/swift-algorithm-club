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
