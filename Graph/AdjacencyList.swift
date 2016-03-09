private var uniqueIDCounter = 0

public struct Edge<T> {
  public let from: Vertex<T>
  public let to: Vertex<T>
  public let weight: Double
}

public struct Vertex<T> {
  public var data: T
  public let uniqueID: Int
  
  private(set) public var edges: [Edge<T>] = []   // the adjacency list
  
  public init(data: T) {
    self.data = data
    uniqueID = uniqueIDCounter
    uniqueIDCounter += 1
  }

  // Creates the directed edge: self -----> dest
  public mutating func connectTo(destinationVertex: Vertex<T>, withWeight weight: Double = 0) {
    edges.append(Edge(from: self, to: destinationVertex, weight: weight))
  }
  
  // Creates an undirected edge by making two directed edges: self ----> other, and other ----> self
  public mutating func connectBetween(inout otherVertex: Vertex<T>, withWeight weight: Double = 0) {
    connectTo(otherVertex, withWeight: weight)
    otherVertex.connectTo(self, withWeight: weight)
  }
  
  // Does this vertex have an edge -----> otherVertex?
  public func edgeTo(otherVertex: Vertex<T>) -> Edge<T>? {
    for e in edges where e.to.uniqueID == otherVertex.uniqueID {
      return e
    }
    return nil
  }
}
