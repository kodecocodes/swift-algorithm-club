extension Graph {
  /* Topological sort using Kahn's algorithm. */
  public func topologicalSortKahn() -> [Node] {
    var nodes = calculateInDegreeOfNodes()

    // Find vertices with no predecessors and puts them into a new list.
    // These are the "leaders". The leaders array eventually becomes the
    // topologically sorted list.
    var leaders = nodes.filter({ _, indegree in
      return indegree == 0
    }).map({ node, indegree in
      return node
    })

    // "Remove" each of the leaders. We do this by decrementing the in-degree
    // of the nodes they point to. As soon as such a node has itself no more
    // predecessors, it is added to the leaders array. This repeats until there
    // are no more vertices left.
    var l = 0
    while l < leaders.count {
      if let edges = adjacencyList(forNode: leaders[l]) {
        for neighbor in edges {
          if let count = nodes[neighbor] {
            nodes[neighbor] = count - 1
            if count == 1 {             // this leader was the last predecessor
              leaders.append(neighbor)  // so neighbor is now a leader itself
            }
          }
        }
      }
      l += 1
    }

    // Was there a cycle in the graph?
    if leaders.count != nodes.count {
      print("Error: graphs with cycles are not allowed")
    }

    return leaders
  }
}
