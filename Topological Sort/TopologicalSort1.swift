extension Graph {
  private func depthFirstSearch(_ source: Node, visited: inout [Node : Bool]) -> [Node] {
    var result = [Node]()
    visited[source] = true

    if let adjacencyList = adjacencyList(forNode: source) {
      for nodeInAdjacencyList in adjacencyList {
        if let seen = visited[nodeInAdjacencyList], !seen {
          result = depthFirstSearch(nodeInAdjacencyList, visited: &visited) + result
        }
      }
    }

    return [source] + result
  }

  /* Topological sort using depth-first search. */
  public func topologicalSort() -> [Node] {

    let startNodes = calculateInDegreeOfNodes().filter({ _, indegree in
      return indegree == 0
    }).map({ node, _ in
      return node
    })

    var visited = [Node: Bool]()
    for (node, _) in adjacencyLists {
      visited[node] = false
    }

    var result = [Node]()
    for startNode in startNodes {
      result = depthFirstSearch(startNode, visited: &visited) + result
    }

    return result
  }
}
