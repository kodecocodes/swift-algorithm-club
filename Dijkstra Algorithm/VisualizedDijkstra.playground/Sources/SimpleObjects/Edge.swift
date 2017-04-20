import Foundation

public class Edge {
    public var neighbor: Vertex
    public var weight: Double
    public var edgeRepresentation: EdgeRepresentation?

    public init(vertex: Vertex, weight: Double) {
        self.neighbor = vertex
        self.weight = weight
    }
}
