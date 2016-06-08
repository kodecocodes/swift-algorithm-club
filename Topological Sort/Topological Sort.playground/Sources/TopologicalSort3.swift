/*
  An alternative implementation of topological sort using depth-first search.
  This does not start at vertices with in-degree 0 but simply at the first one
  it finds. It uses a stack to build up the sorted list, but in reverse order.
*/
extension Graph {
  public func topologicalSortAlternative() -> [Node] {
    var stack = [Node]()

    var visited = [Node: Bool]()
    for (node, _) in adjacencyLists {
      visited[node] = false
    }

    func depthFirstSearch(source: Node) {
      if let adjacencyList = adjacencyList(forNode: source) {
        for neighbor in adjacencyList {
          if let seen = visited[neighbor] where !seen {
            depthFirstSearch(neighbor)
          }
        }
      }
      stack.append(source)
      visited[source] = true
    }

    for (node, _) in visited {
      if let seen = visited[node] where !seen {
        depthFirstSearch(node)
      }
    }

    return stack.reverse()
  }
}
