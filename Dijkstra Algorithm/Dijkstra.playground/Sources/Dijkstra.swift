import Foundation

public class Dijkstra {
    private var totalVertices: Set<Vertex>

    public init(vertices: Set<Vertex>) {
        totalVertices = vertices
    }

    private func clearCache() {
        totalVertices.forEach { $0.clearCache() }
    }

    public func findShortestPaths(from startVertex: Vertex) {
        clearCache()
        var currentVertices = self.totalVertices
        startVertex.pathLengthFromStart = 0
        startVertex.pathVerticesFromStart.append(startVertex)
        var currentVertex: Vertex? = startVertex
        while let vertex = currentVertex {
            currentVertices.remove(vertex)
            let filteredNeighbors = vertex.neighbors.filter { currentVertices.contains($0.0) }
            for neighbor in filteredNeighbors {
                let neighborVertex = neighbor.0
                let weight = neighbor.1

                let theoreticNewWeight = vertex.pathLengthFromStart + weight
                if theoreticNewWeight < neighborVertex.pathLengthFromStart {
                    neighborVertex.pathLengthFromStart = theoreticNewWeight
                    neighborVertex.pathVerticesFromStart = vertex.pathVerticesFromStart
                    neighborVertex.pathVerticesFromStart.append(neighborVertex)
                }
            }
            if currentVertices.isEmpty {
                currentVertex = nil
                break
            }
            currentVertex = currentVertices.min { $0.pathLengthFromStart < $1.pathLengthFromStart }
        }
    }
}
