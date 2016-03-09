//: # Graph using an adjacency list
//:
//: In an adjacency list implementation of a graph, each vertex stores an
//: array of edges, indicating to which other vertices it has an edge.
//: (Note the directionality: we only record "to" edges, not "from" edges.)

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



//: ### Demo

// Create the vertices
var v1 = Vertex(data: 1)
var v2 = Vertex(data: 2)
var v3 = Vertex(data: 3)
var v4 = Vertex(data: 4)
var v5 = Vertex(data: 5)

// Set up a cycle like so:
//               v5
//                ^
//                | (3.2)
//                |
// v1 ---(1)---> v2 ---(1)---> v3 ---(4.5)---> v4
// ^                                            |
// |                                            V
// ---------<-----------<---------(2.8)----<----|

v1.connectTo(v2, withWeight: 1.0)
v2.connectTo(v3, withWeight: 1.0)
v3.connectTo(v4, withWeight: 4.5)
v4.connectTo(v1, withWeight: 2.8)
v2.connectTo(v5, withWeight: 3.2)


// Returns the weight of the edge from v1 to v2 (1.0)
v1.edgeTo(v2)?.weight

// Returns the weight of the edge from v1 to v3 (nil, since there is not an edge)
v1.edgeTo(v3)?.weight

// Returns the weight of the edge from v3 to v4 (4.5)
v3.edgeTo(v4)?.weight

// Returns the weight of the edge from v4 to v1 (2.8)
v4.edgeTo(v1)?.weight

//: [Next: Adjacency Matrix](@next)
