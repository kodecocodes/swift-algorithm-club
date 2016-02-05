public struct GraphEdge<T> {
    let from: GraphVertex<T>
    let to: GraphVertex<T>
    let weight: Int
}

public struct GraphVertex<T> {
    public var data: T
    private var edges: [GraphEdge<T>] // This is a simple adjacency list, rather than matrix
    
    public mutating func connectTo(destinationVertex: GraphVertex<T>, withWeight weight: Int = 0) {
        edges.append(GraphEdge(from: self, to: destinationVertex, weight: weight))
    }
    
    public mutating func connectBetween(inout otherVertex: GraphVertex<T>, withWeight weight: Int = 0) {
        edges.append(GraphEdge(from: self, to: otherVertex, weight: weight))
        otherVertex.edges.append(GraphEdge(from: otherVertex, to: self, weight: weight))
    }
}


