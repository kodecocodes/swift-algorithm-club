public struct GraphEdge<T> {
  let from: GraphVertex<T>
  let to: GraphVertex<T>
  let weight: Int
}

public struct GraphVertex<T> {
  public var data: T
  private var edges: [GraphEdge<T>] = [] // This is a simple adjacency list, rather than matrix
  
  public init(data: T) {
    self.data = data
  }
  
  // Creates a directed edge self -----> dest
  public mutating func connectTo(destinationVertex: GraphVertex<T>, withWeight weight: Int = 0) {
    edges.append(GraphEdge(from: self, to: destinationVertex, weight: weight))
  }
  
  // Creates an undirected edge by making 2 directed edges: self ----> other, and other ----> self
  public mutating func connectBetween(inout otherVertex: GraphVertex<T>, withWeight weight: Int = 0) {
    edges.append(GraphEdge(from: self, to: otherVertex, weight: weight))
    otherVertex.edges.append(GraphEdge(from: otherVertex, to: self, weight: weight))
  }
}




var v1 = GraphVertex(data: 1)
var v2 = GraphVertex(data: 2)
var v3 = GraphVertex(data: 3)
var v4 = GraphVertex(data: 4)

// v1 ---> v2 ---> v3 ---> v4
// ^                       |
// |                       V
// -----------<------------|
v1.connectTo(v2)
v2.connectTo(v3)
v3.connectTo(v4)
v4.connectTo(v1)
