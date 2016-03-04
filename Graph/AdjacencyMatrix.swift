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
