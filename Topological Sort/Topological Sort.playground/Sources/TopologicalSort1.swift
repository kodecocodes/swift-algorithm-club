extension Graph {
  typealias InDegree = Int

  func calculateInDegreeOfNodes() -> [Node : InDegree] {
    var inDegrees = [Node : InDegree]()
    
    for (node, _) in adjacencyLists {
      inDegrees[node] = 0
    }
    
    for (_, adjacencyList) in adjacencyLists {
      for nodeInList in adjacencyList {
        inDegrees[nodeInList] = (inDegrees[nodeInList] ?? 0) + 1
      }
    }
    return inDegrees
  }
  
  private func depthFirstSearch(source: Node, inout visited: [Node : Bool]) -> [Node] {
    var result = [source]
    visited[source] = true
    
    if let adjacencyList = adjacencyList(forNode: source) {
      for nodeInAdjacencyList in adjacencyList {
        if !(visited[nodeInAdjacencyList] ?? false) {
          result += (depthFirstSearch(nodeInAdjacencyList, visited: &visited))
        }
      }
    }
    return result
  }
  
  public func topologicalSort() -> [Node] {
    
    let startNodes = calculateInDegreeOfNodes().filter({(_, indegree) in
      return indegree == 0
    }).map({(node, indegree) in
      return node
    })
    
    var visited = [Node : Bool]()
    
    for (node, _) in adjacencyLists {
      visited[node] = false
    }
    
    var result = [Node]()
    
    for startNode in startNodes {
      result += depthFirstSearch(startNode, visited: &visited)
    }
    
    return result
  }
}
