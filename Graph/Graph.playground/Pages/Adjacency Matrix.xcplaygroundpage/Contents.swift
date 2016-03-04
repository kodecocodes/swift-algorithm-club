//: [Previous: Adjacency List](@previous)

//: # Graph using an adjacency matrix
//:
//: In an adjacency matrix implementation, each vertex is given an index 
//: from `0..<V`, where `V` is the total number of vertices. The matrix is 
//: a 2D array, with each entry indicating if the corresponding two vertices
//: are connected, and the weight of that edge.
//:
//: For example, if `matrix[3][5] = 4.6`, then vertex #3 is connected to
//: vertex #5, with a weight of 4.6. Note that vertex #5 is not necessarily
//: connected back to vertex #3 (that would be recorded in `matrix[5][3]`).

public struct Vertex<T> {
  public var data: T
  private let index: Int
}

public struct Graph<T> {
  // If adjacencyMatrix[i][j] is not nil, then there is an edge from
  // vertex i to vertex j.
  private var adjacencyMatrix: [[Double?]] = []
  
  // Adds a new vertex to the matrix.
  // Performance: possibly O(n^2) because of the resizing of the matrix.
  public mutating func createVertex(data: T) -> Vertex<T> {
    let vertex = Vertex(data: data, index: adjacencyMatrix.count)
    
    // Expand each existing row to the right one column.
    for i in 0..<adjacencyMatrix.count {
      adjacencyMatrix[i].append(nil)
    }
    
    // Add one new row at the bottom.
    let newRow = [Double?](count: adjacencyMatrix.count + 1, repeatedValue: nil)
    adjacencyMatrix.append(newRow)

    return vertex
  }
  
  // Creates a directed edge source -----> dest.
  public mutating func connect(sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>, withWeight weight: Double = 0) {
    adjacencyMatrix[sourceVertex.index][destinationVertex.index] = weight
  }
  
  // Creates an undirected edge by making 2 directed edges:
  // some ----> other, and other ----> some.
  public mutating func connect(someVertex: Vertex<T>, symmetricallyWithVertex withVertex: Vertex<T>, withWeight weight: Double = 0) {
    adjacencyMatrix[someVertex.index][withVertex.index] = weight
    adjacencyMatrix[withVertex.index][someVertex.index] = weight
  }

  public func weightFrom(sourceVertex: Vertex<T>, toDestinationVertex: Vertex<T>) -> Double? {
    return adjacencyMatrix[sourceVertex.index][toDestinationVertex.index]
  }
}



//: ### Demo

// Create the vertices
var graph = Graph<Int>()
let v1 = graph.createVertex(1)
let v2 = graph.createVertex(2)
let v3 = graph.createVertex(3)
let v4 = graph.createVertex(4)
let v5 = graph.createVertex(5)

// Set up a cycle like so:
//               v5
//                ^
//                | (3.2)
//                |
// v1 ---(1)---> v2 ---(1)---> v3 ---(4.5)---> v4
// ^                                            |
// |                                            V
// ---------<-----------<---------(2.8)----<----|

graph.connect(v1, to: v2, withWeight: 1.0)
graph.connect(v2, to: v3, withWeight: 1.0)
graph.connect(v3, to: v4, withWeight: 4.5)
graph.connect(v4, to: v1, withWeight: 2.8)
graph.connect(v2, to: v5, withWeight: 3.2)

// Returns the weight of the edge from v1 to v2 (1.0)
graph.weightFrom(v1, toDestinationVertex: v2)

// Returns the weight of the edge from v1 to v3 (nil, since there is not an edge)
graph.weightFrom(v1, toDestinationVertex: v3)

// Returns the weight of the edge from v3 to v4 (4.5)
graph.weightFrom(v3, toDestinationVertex: v4)

// Returns the weight of the edge from v4 to v1 (2.8)
graph.weightFrom(v4, toDestinationVertex: v1)

print(graph.adjacencyMatrix)

