public class Edge: Equatable {
  public var neighbor: Node

  public init(neighbor: Node) {
    self.neighbor = neighbor
  }
}

public func == (lhs: Edge, rhs: Edge) -> Bool {
  return lhs.neighbor == rhs.neighbor
}
