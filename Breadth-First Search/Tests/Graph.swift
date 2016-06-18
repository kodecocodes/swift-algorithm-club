// MARK: - Edge

public class Edge: Equatable {
  public var neighbor: Node

  public init(neighbor: Node) {
    self.neighbor = neighbor
  }
}

public func == (lhs: Edge, rhs: Edge) -> Bool {
  return lhs.neighbor == rhs.neighbor
}

// MARK: - Node

public class Node: CustomStringConvertible, Equatable {
  public var neighbors: [Edge]

  public private(set) var label: String
  public var distance: Int?
  public var visited: Bool

  public init(label: String) {
    self.label = label
    neighbors = []
    visited = false
  }

  public var description: String {
    if let distance = distance {
      return "Node(label: \(label), distance: \(distance))"
    }
    return "Node(label: \(label), distance: infinity)"
  }

  public var hasDistance: Bool {
    return distance != nil
  }

  public func remove(edge: Edge) {
    neighbors.removeAtIndex(neighbors.indexOf { $0 === edge }!)
  }
}

public func == (lhs: Node, rhs: Node) -> Bool {
  return lhs.label == rhs.label && lhs.neighbors == rhs.neighbors
}

// MARK: - Graph

public class Graph: CustomStringConvertible, Equatable {
  public private(set) var nodes: [Node]

  public init() {
    self.nodes = []
  }

  public func addNode(label: String) -> Node {
    let node = Node(label: label)
    nodes.append(node)
    return node
  }

  public func addEdge(source: Node, neighbor: Node) {
    let edge = Edge(neighbor: neighbor)
    source.neighbors.append(edge)
  }

  public var description: String {
    var description = ""

    for node in nodes {
      if !node.neighbors.isEmpty {
        description += "[node: \(node.label) edges: \(node.neighbors.map { $0.neighbor.label})]"
      }
    }
    return description
  }

  public func findNodeWithLabel(label: String) -> Node {
    return nodes.filter { $0.label == label }.first!
  }

  public func duplicate() -> Graph {
    let duplicated = Graph()

    for node in nodes {
      duplicated.addNode(node.label)
    }

    for node in nodes {
      for edge in node.neighbors {
        let source = duplicated.findNodeWithLabel(node.label)
        let neighbour = duplicated.findNodeWithLabel(edge.neighbor.label)
        duplicated.addEdge(source, neighbor: neighbour)
      }
    }

    return duplicated
  }
}

public func == (lhs: Graph, rhs: Graph) -> Bool {
  return lhs.nodes == rhs.nodes
}
