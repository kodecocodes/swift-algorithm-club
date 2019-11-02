public class Edge: Equatable {
  public var neighbor: Node

  public init(_ neighbor: Node) {
    self.neighbor = neighbor
  }
}

public func == (_ lhs: Edge, rhs: Edge) -> Bool {
  return lhs.neighbor == rhs.neighbor
}
