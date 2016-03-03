# Graph

[TODO: this is a work-in-progress]

A graph is a set of *vertices* paired with a set of *edges*. Each vertex has a number of associated edges, which connect the vertex to other vertices.

For example, a graph can represent a social network. Each person is a vertex, and people who know each other are connected by edges.

// TODO: Insert image here

> **Note:** Vertices are sometimes also called "nodes" and edges are also called "links".

## Weighted and Directed Edges

Edges can optionally be *weighted*, where an arbitrary weight -- a positive or negative numeric value -- is assigned to each edge.  Consider an example of a graph representing airplane flights. Cities can be represented as vertices, and flights as edges. Then an edge weight could represent flight time or the cost of the trip.

In addition, edges can optionally be *directed*.  A directed edge from vertex A to vertex B connects *A to B*, but **not** *B to A*. Continuing from the flight path example, a directed edge from San Francisco, CA to Juneau, AK would indicate that there is a flight from San Francisco to Juneau, but not from Juneau to San Francisco.

// TODO: Insert image here

## Representing Graphs in Code

There are two main strategies for representing graphs:

**Adjacency List.** In an adjacency list implementation, each vertex stores a list of edges that originate from the vertex. For example, if vertex A has an edge to vertices B, C, and D, then vertex A would have a list of 3 edges.

**Adjacency Matrix.** In an adjacency matrix implementation, a matrix with rows and columns representing vertices stores a weight to indicate if vertices are connected, and by what weight. For example, if there is a directed edge of weight 5.6 from vertex A to vertex B, then the entry with row for  vertex A, column for vertex B would have value 5.6:

```
matrix[index(A)][index(B)] == 5.6
```

### Comparing Graph Representations

Let *V* be the number of vertices in the graph, and *E* the number of edges.  Then we have:

| Operation       | Adjacency List | Adjacency Matrix |
|-----------------|----------------|------------------|
| Storage Space   | O(V + E)       | O(V^2)           |
| Add Vertex      | O(1)           | O(V^2)           |
| Add Edge        | O(1)           | O(1)             |
| Check Adjacency | O(V)           | O(1)             |

Note that the time to check adjacency for an adjacency list is **O(V)**, because at worst a vertex is connected to *every* other vertex.

In the case of a *sparse* graph, where each vertex is connected to only a handful of other vertices, an Adjacency List is preferred. If the graph is *dense*, where each vertex is connected to most of the other vertices, then an Adjacency Matrix is preferred.

## The Code

Below we have implementations of both Adjacency List and Adjacency Matrix graph representations. In both cases, we also let the vertex store arbitrary data with a generic parameter.

### Adjacency List

First, we have the data structures for edges and vertices:

```swift
var uniqueIDCounter = 0

public struct GraphEdge<T> {
  public let from: GraphVertex<T>
  public let to: GraphVertex<T>
  public let weight: Double
}

public struct GraphVertex<T> {
  public var data: T
  private var edges: [GraphEdge<T>] = []
  
  private let uniqueID: Int
  
  public init(data: T) {
    self.data = data
    uniqueID = uniqueIDCounter
    uniqueIDCounter += 1
  }
}
```

Note that each vertex has a unique identifier, which we use to compare equality later.

Now, lets see how to connect vertices:

```swift
// Creates a directed edge self -----> dest
public mutating func connectTo(destinationVertex: GraphVertex<T>, withWeight weight: Double = 1.0) {
  edges.append(GraphEdge(from: self, to: destinationVertex, weight: weight))
}
```
And then we can check for an edge between vertices:

```swift
// Queries for an edge from self -----> otherVertex
public func edgeTo(otherVertex: GraphVertex<T>) -> GraphEdge<T>? {
  for e in edges {
    if e.to.uniqueID == otherVertex.uniqueID {
      return e
    }
  } 
  return nil
}
```

### Adjacency Matrix

Fundamentally, we will store a `[[Double?]]` array, which is the adjacency matrix. An entry of `nil` indicates no edge, while any other value indicates an edge of the given weight.  To index into the matrix using vertices, we give each `GraphVertex` a unique integer index:

```swift
public struct GraphVertex<T> {
  public var data: T
  private let index: Int
}
```

Then the `Graph` struct keeps track of the matrix.  To create a new vertex, the graph must resize the matrix:

```swift
public struct Graph<T> {
  
  // nil entries are used to mark that two vertices are NOT connected.
  // If adjacencyMatrix[i][j] is not nil, then there is an edge from vertex i to vertex j.
  private var adjacencyMatrix: [[Double?]] = []
    
  // O(n^2) because of the resizing of the matrix
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
```

Once we have the matrix properly configured, adding edges and querying for edges are simple indexing operations into the matrix:

```swift
// Creates a directed edge source -----> dest.  Represented by M[source][dest] = weight
public mutating func connect(sourceVertex: GraphVertex<T>, toDestinationVertex: GraphVertex<T>, withWeight weight: Double = 0) {
  adjacencyMatrix[sourceVertex.index][toDestinationVertex.index] = weight
}

public func weightFrom(sourceVertex: GraphVertex<T>, toDestinationVertex: GraphVertex<T>) -> Double? {
  return adjacencyMatrix[sourceVertex.index][toDestinationVertex.index]
}
```
*Written by Donald Pinckney*
