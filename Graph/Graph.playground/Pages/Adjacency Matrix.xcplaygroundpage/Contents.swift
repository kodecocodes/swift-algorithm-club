//: [Previous](@previous)
/*

A graph implementation, using an adjacency matrix.

In an adjacency matrix implementation, each vertex is associated with an index from 0..<V (V being the number of vertices). Then a matrix (a 2D array) is stored for the entire graph, with each entry indicating if the corresponding vertices are connected, and the weight.  For example, if matrix[3][5] = 4.6, then vertex #3 is connected to vertex #5, with a weight of 4.6.  Note that vertex #5 is not necessarily connected to vertex #3.

Creating a new vertex must expand the adjacency matrix in this implementation, so creating a new vertex is O(V).  
Connecting vertices os O(1).

*/

public struct GraphVertex<T> {
    public var data: T
    private let uniqueID: Int
}

public struct Graph<T> {
    
    // nil entries are used to mark that two vertices are NOT connected.
    private var adjacencyMatrix: [[Double?]] = []
    
    public init() { }
    
    public mutating func createVertex(data: T) -> GraphVertex<T> {
        let vertex = GraphVertex(data: data, uniqueID: adjacencyMatrix.count)
        
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
        adjacencyMatrix[sourceVertex.uniqueID][toDestinationVertex.uniqueID] = weight
    }
    
    // Creates an undirected edge by making 2 directed edges: some ----> other, and other ----> some
    public mutating func connect(someVertex: GraphVertex<T>, withVertex: GraphVertex<T>, withWeight weight: Double = 0) {
        adjacencyMatrix[someVertex.uniqueID][withVertex.uniqueID] = weight
        adjacencyMatrix[withVertex.uniqueID][someVertex.uniqueID] = weight
        
    }
}



// Create 4 separate vertices
var graph = Graph<Int>()
let v1 = graph.createVertex(1)
let v2 = graph.createVertex(2)
let v3 = graph.createVertex(3)
let v4 = graph.createVertex(4)

// Setup a cycle like so:
// v1 ---> v2 ---> v3 ---> v4
// ^                       |
// |                       V
// -----------<------------|

graph.connect(v1, toDestinationVertex: v2)
graph.connect(v2, toDestinationVertex: v3)
graph.connect(v3, toDestinationVertex: v4)
graph.connect(v4, toDestinationVertex: v1)
