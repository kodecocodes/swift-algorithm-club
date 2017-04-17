import Foundation

public class Dijkstra {
    private var totalVertices: Set<Vertex>

    public init(vertices: Set<Vertex>) {
        self.totalVertices = vertices
    }

    private func clearCache() {
        self.totalVertices.forEach { $0.clearCache() }
    }

    public func findShortestPaths(from startVertex: Vertex) {
        self.clearCache()
        startVertex.pathLengthFromStart = 0
        startVertex.pathVerticesFromStart.append(startVertex)
        var currentVertex: Vertex! = startVertex
        while currentVertex != nil {
            totalVertices.remove(currentVertex)
            let filteredNeighbors = currentVertex.neighbors.filter { totalVertices.contains($0.0) }
            for neighbor in filteredNeighbors {
                let neighborVertex = neighbor.0
                let weight = neighbor.1

                let theoreticNewWeight = currentVertex.pathLengthFromStart + weight
                if theoreticNewWeight < neighborVertex.pathLengthFromStart {
                    neighborVertex.pathLengthFromStart = theoreticNewWeight
                    neighborVertex.pathVerticesFromStart = currentVertex.pathVerticesFromStart
                    neighborVertex.pathVerticesFromStart.append(neighborVertex)
                }
            }
            if totalVertices.isEmpty {
                currentVertex = nil
                break
            }
            currentVertex = totalVertices.min { $0.pathLengthFromStart < $1.pathLengthFromStart }
        }
    }
}
