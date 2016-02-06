/*

A graph implementation, using an adjacency list.

In an adjacency list implementation, each vertex stores an array of edges, indicating to which vertices it has an edge (note the directionality).  The edge stores the source and destination vertices, as well as a weight.

Connected vertices in this implementation is O(1).

*/

public struct GraphEdge<T> {
  public let from: GraphVertex<T>
  public let to: GraphVertex<T>
  public let weight: Double
}

public struct GraphVertex<T> {
  public var data: T
  public private(set) var edges: [GraphEdge<T>] = [] // This is a simple adjacency list, rather than matrix
  
  public init(data: T) {
    self.data = data
  }
  
  // Creates a directed edge self -----> dest
  public mutating func connectTo(destinationVertex: GraphVertex<T>, withWeight weight: Double = 0) {
    edges.append(GraphEdge(from: self, to: destinationVertex, weight: weight))
  }
  
  // Creates an undirected edge by making 2 directed edges: self ----> other, and other ----> self
  public mutating func connectBetween(inout otherVertex: GraphVertex<T>, withWeight weight: Double = 0) {
    edges.append(GraphEdge(from: self, to: otherVertex, weight: weight))
    otherVertex.edges.append(GraphEdge(from: otherVertex, to: self, weight: weight))
  }
}



// Create 4 separate vertices
var v1 = GraphVertex(data: 1)
var v2 = GraphVertex(data: 2)
var v3 = GraphVertex(data: 3)
var v4 = GraphVertex(data: 4)

// Setup a cycle like so:
// v1 ---> v2 ---> v3 ---> v4
// ^                       |
// |                       V
// -----------<------------|

v1.connectTo(v2)
v2.connectTo(v3)
v3.connectTo(v4)
v4.connectTo(v1)


//: [Next](@next)
