//: Playground - noun: a place where people can play

import Foundation
import UIKit

open class ProductVertex: Vertex {}

open class Vertex: Hashable, Equatable {

    open var identifier: String!
    open var neighbors: [(Vertex, Double)] = []
    open var pathLengthFromStart: Double = Double.infinity
    open var pathVerticesFromStart: [Vertex] = []
//    open var point: CGPoint!

    public init(identifier: String/*, point: CGPoint*/) {
        self.identifier = identifier
//        self.point = point
    }

    open var hashValue: Int {
        return self.identifier.hashValue
    }

    public static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        if lhs.hashValue == rhs.hashValue {
            return true
        }
        return false
    }

    open func clearCache() {
        self.pathLengthFromStart = Double.infinity
        self.pathVerticesFromStart = []
    }
}

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

var _vertices: Set<Vertex> = Set()

func createNotConnectedVertices() {
    for i in 0..<15 {
        let vertex = Vertex(identifier: "\(i)")
        _vertices.insert(vertex)
    }
}

func setupConnections() {
    for vertex in _vertices {
        let randomEdgesCount = arc4random_uniform(4) + 1
        for _ in 0..<randomEdgesCount {
            let randomWeight = Double(arc4random_uniform(10))
            let neighborVertex = randomVertex(except: vertex)
            if vertex.neighbors.contains(where: { $0.0 == neighborVertex }) {
                continue
            }
            let neighbor1 = (neighborVertex, randomWeight)
            let neighbor2 = (vertex, randomWeight)
            vertex.neighbors.append(neighbor1)
            neighborVertex.neighbors.append(neighbor2)
        }
    }
}

func randomVertex(except vertex: Vertex) -> Vertex {
    var newSet = _vertices
    newSet.remove(vertex)
    let offset = Int(arc4random_uniform(UInt32(newSet.count)))
    let index = newSet.index(newSet.startIndex, offsetBy: offset)
    return newSet[index]
}

createNotConnectedVertices()
setupConnections()
let dijkstra = Dijkstra(vertices: _vertices)
let offset = Int(arc4random_uniform(UInt32(_vertices.count)))
let index = _vertices.index(_vertices.startIndex, offsetBy: offset)
let startVertex = _vertices[index]
dijkstra.findShortestPaths(from: startVertex)
let destinationVertex = randomVertex(except: startVertex)
destinationVertex.pathLengthFromStart
destinationVertex.pathVerticesFromStart


