

public struct GraphVertex<T> {
  public var data: T
  let uniqueID: Int
}

public struct Graph<T> {
  
  private var adjacencyMatrix: [[Int?]] = [] // row-major
  
  public init() { } // Silence default constructor
  
  public mutating func createVertex(data: T) -> GraphVertex<T> {
    let vertex = GraphVertex(data: data, uniqueID: adjacencyMatrix.count)
    
    // Expand each existing row to the right one column
    for i in 0..<adjacencyMatrix.count {
      adjacencyMatrix[i].append(nil)
    }
    
    // Add one new row at the bottom
    let newRow = [Int?](count: adjacencyMatrix.count + 1, repeatedValue: nil)
    adjacencyMatrix.append(newRow)
    
    return vertex
  }
  
  // Creates a directed edge source -----> dest.  Represented by M[source][dest] = weight
  public mutating func connect(sourceVertex: GraphVertex<T>, toDestinationVertex: GraphVertex<T>, withWeight weight: Int = 0) {
    adjacencyMatrix[sourceVertex.uniqueID][toDestinationVertex.uniqueID] = weight
  }
  
  // Creates an undirected edge by making 2 directed edges: some ----> other, and other ----> some
  public mutating func connect(someVertex: GraphVertex<T>, withVertex: GraphVertex<T>, withWeight weight: Int = 0) {
    adjacencyMatrix[someVertex.uniqueID][withVertex.uniqueID] = weight
    adjacencyMatrix[withVertex.uniqueID][someVertex.uniqueID] = weight

  }
}




var graph = Graph<Int>()
let v1 = graph.createVertex(1)
let v2 = graph.createVertex(2)
let v3 = graph.createVertex(3)
let v4 = graph.createVertex(4)

// v1 ---> v2 ---> v3 ---> v4
// ^                       |
// |                       V
// -----------<------------|

graph.connect(v1, toDestinationVertex: v2)
graph.connect(v2, toDestinationVertex: v3)
graph.connect(v3, toDestinationVertex: v4)
graph.connect(v4, toDestinationVertex: v1)
