/*

A graph implementation, using an adjacency list.

In an adjacency list implementation, each vertex stores an array of edges, indicating to which vertices it has an edge (note the directionality).  The edge stores the source and destination vertices, as well as a weight.

*/

var uniqueIDCounter: Int = 0

public struct GraphEdge<T> {
  public let from: GraphVertex<T>
  public let to: GraphVertex<T>
  public let weight: Double
}


public struct GraphVertex<T> {
  public var data: T
  private var edges: [GraphEdge<T>] = [] // This is an adjacency list, rather than matrix
  
  private let uniqueID: Int
  
  public init(data: T) {
    self.data = data
    uniqueID = uniqueIDCounter
    uniqueIDCounter += 1
  }
  
  // Creates a directed edge self -----> dest
  public mutating func connectTo(destinationVertex: GraphVertex<T>, withWeight weight: Double = 1.0) {
    edges.append(GraphEdge(from: self, to: destinationVertex, weight: weight))
  }
  
  // Creates an undirected edge by making 2 directed edges: self ----> other, and other ----> self
  public mutating func connectBetween(inout otherVertex: GraphVertex<T>, withWeight weight: Double = 1.0) {  
    connectTo(otherVertex, withWeight: weight)
    otherVertex.connectTo(self, withWeight: weight)
  }
  
  // Queries for an edge from self -----> otherVertex
  public func edgeTo(otherVertex: GraphVertex<T>) -> GraphEdge<T>? {
    for e in edges {
      if e.to.uniqueID == otherVertex.uniqueID {
        return e
      }
    }
    
    return nil
  }
}



// Create 4 separate vertices
var v1 = GraphVertex(data: 1)
var v2 = GraphVertex(data: 2)
var v3 = GraphVertex(data: 3)
var v4 = GraphVertex(data: 4)

// Setup a cycle like so:
// v1 ---(1)---> v2 ---(1)---> v3 ---(4.5)---> v4
// ^                                            |
// |                                            V
// ---------<-----------<---------(2.8)----<----|

v1.connectTo(v2, withWeight: 1.0)
v2.connectTo(v3, withWeight: 1.0)
v3.connectTo(v4, withWeight: 4.5)
v4.connectTo(v1, withWeight: 2.8)

// Returns the weight of the edge from v1 to v2 (1.0)
v1.edgeTo(v2)?.weight

// Returns the weight of the edge from v1 to v3 (nil, since there is not an edge)
v1.edgeTo(v3)?.weight

// Returns the weight of the edge from v3 to v4 (4.5)
v3.edgeTo(v4)?.weight

// Returns the weight of the edge from v4 to v1 (2.8)
v4.edgeTo(v1)?.weight
//: [Next](@next)
