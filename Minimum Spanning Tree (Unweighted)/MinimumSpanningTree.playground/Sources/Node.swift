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
