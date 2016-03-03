//: [Previous](@previous)
/*

A graph implementation, using an adjacency matrix.

In an adjacency matrix implementation, each vertex is associated with an index from 0..<V (V being the number of vertices). Then a matrix (a 2D array) is stored for the entire graph, with each entry indicating if the corresponding vertices are connected, and the weight.  For example, if matrix[3][5] = 4.6, then vertex #3 is connected to vertex #5, with a weight of 4.6.  Note that vertex #5 is not necessarily connected to vertex #3.

*/

public struct GraphVertex<T> {
  public var data: T
  private let index: Int
}

public struct Graph<T> {
  
  // nil entries are used to mark that two vertices are NOT connected.
  // If adjacencyMatrix[i][j] is not nil, then there is an edge from vertex i to vertex j.
  private var adjacencyMatrix: [[Double?]] = []
  
  // Possibly O(n^2) because of the resizing of the matrix
  public mutating func createVertex(data: T) -> GraphVertex<T> {
    let vertex = GraphVertex(data: data, index: adjacencyMatrix.count)
    
    // Expand each existing row to the right one column
    for i in 0..<adjacencyMatrix.count {
      adjacencyMatrix[i].append(nil)
    }
    
    // Add one new row at the bottom
    let newRow = [Double?](count: adjacencyMatrix.count + 1, repeatedValue: nil)
    adjacencyMatrix.append(newRow)
    
    return vertex
  }
  
  // Creates a directed edge source -----> dest.  Represented by M[source][dest] = weight
  public mutating func connect(sourceVertex: GraphVertex<T>, toDestinationVertex: GraphVertex<T>, withWeight weight: Double = 0) {
    adjacencyMatrix[sourceVertex.index][toDestinationVertex.index] = weight
  }
  
  // Creates an undirected edge by making 2 directed edges: some ----> other, and other ----> some
  public mutating func connect(someVertex: GraphVertex<T>, symmetricallyWithVertex withVertex: GraphVertex<T>, withWeight weight: Double = 0) {
    adjacencyMatrix[someVertex.index][withVertex.index] = weight
    adjacencyMatrix[withVertex.index][someVertex.index] = weight
  }
  
  public func weightFrom(sourceVertex: GraphVertex<T>, toDestinationVertex: GraphVertex<T>) -> Double? {
    return adjacencyMatrix[sourceVertex.index][toDestinationVertex.index]
  }
  
}



// Create 4 separate vertices
var graph = Graph<Int>()
let v1 = graph.createVertex(1)
let v2 = graph.createVertex(2)
let v3 = graph.createVertex(3)
let v4 = graph.createVertex(4)

// Setup a cycle like so:
// v1 ---(1)---> v2 ---(1)---> v3 ---(4.5)---> v4
// ^                                            |
// |                                            V
// ---------<-----------<---------(2.8)----<----|

graph.connect(v1, toDestinationVertex: v2, withWeight: 1.0)
graph.connect(v2, toDestinationVertex: v3, withWeight: 1.0)
graph.connect(v3, toDestinationVertex: v4, withWeight: 4.5)
graph.connect(v4, toDestinationVertex: v1, withWeight: 2.8)

// Returns the weight of the edge from v1 to v2 (1.0)
graph.weightFrom(v1, toDestinationVertex: v2)

// Returns the weight of the edge from v1 to v3 (nil, since there is not an edge)
graph.weightFrom(v1, toDestinationVertex: v3)

// Returns the weight of the edge from v3 to v4 (4.5)
graph.weightFrom(v3, toDestinationVertex: v4)

// Returns the weight of the edge from v4 to v1 (2.8)
graph.weightFrom(v4, toDestinationVertex: v1)

