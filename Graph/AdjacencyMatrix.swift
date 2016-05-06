import Foundation

public struct Vertex<T> {
  public var data: T
  public let index: Int
}



public struct Graph<T> {
  // If adjacencyMatrix[i][j] is not nil, then there is an edge from
  // vertex i to vertex j.
  var adjacencyMatrix: [[Double?]] = []
  var vertices: [Vertex<T>] = []

  public init() {}
  
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

    vertices.append(vertex)
    return vertex
  }
}

extension Graph: CustomStringConvertible {
  public var description: String {
    get {
      var grid = [String]()
      let n = self.adjacencyMatrix.count
      for i in 0..<n {
        var row = ""
        for j in 0..<n {
          if let value = self.adjacencyMatrix[i][j] {
            let number = NSString(format: "%.1f", value)
            row += "\(value >= 0 ? " " : "")\(number) "
          } else {
            row += "  ø  "
          }
        }
        grid.append(row)
      }
      return (grid as NSArray).componentsJoinedByString("\n")
    }
  }
}

extension Graph {
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
