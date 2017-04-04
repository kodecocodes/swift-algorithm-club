import Foundation
import UIKit

public enum GraphState {
    case initial
    case autoVisualization
    case interactiveVisualization
    case parsing
    case completed
}

public class Graph {
    private init() { }

    private var verticesCount: UInt!
    private var _vertices: Set<Vertex> = Set()
    public weak var delegate: GraphDelegate?
    public var nextVertices: [Vertex] = []
    public var state: GraphState = .initial
    public var pauseVisualization: Bool = false
    public var stopVisualization: Bool = false
    public var startVertex: Vertex!
    public var interactiveNeighborCheckAnimationDuration: Double = 1.8 {
        didSet {
            self._interactiveOneSleepDuration = UInt32(self.interactiveNeighborCheckAnimationDuration * 1000000.0 / 3.0)
        }
    }
    private var _interactiveOneSleepDuration: UInt32 = 600000

    public var visualizationNeighborCheckAnimationDuration: Double = 2.25 {
        didSet {
            self._visualizationOneSleepDuration = UInt32(self.visualizationNeighborCheckAnimationDuration * 1000000.0 / 3.0)
        }
    }
    private var _visualizationOneSleepDuration: UInt32 = 750000

    public var vertices: Set<Vertex> {
        return self._vertices
    }

    public init(verticesCount: UInt) {
        self.verticesCount = verticesCount
    }

    public func removeGraph() {
        self._vertices.removeAll()
        self.startVertex = nil
    }

    public func createNewGraph() {
        guard self._vertices.isEmpty, self.startVertex == nil else {
            assertionFailure("Clear graph before creating new one")
            return
        }
        self.createNotConnectedVertices()
        self.setupConnections()
        let offset = Int(arc4random_uniform(UInt32(self._vertices.count)))
        let index = self._vertices.index(self._vertices.startIndex, offsetBy: offset)
        self.startVertex =  self._vertices[index]
        self.setVertexLevels()
    }
    
    private func clearCache() {
        self._vertices.forEach { $0.clearCache() }
    }

    public func reset() {
        for vertex in self._vertices {
            vertex.clearCache()
        }
    }

    private func createNotConnectedVertices() {
        for i in 0..<self.verticesCount {
            let vertex = Vertex(identifier: "\(i)")
            self._vertices.insert(vertex)
        }
    }

    private func setupConnections() {
        for vertex in self._vertices {
            let randomEdgesCount = arc4random_uniform(4) + 1
            for _ in 0..<randomEdgesCount {
                let randomWeight = Double(arc4random_uniform(10))
                let neighbor = self.randomVertex(except: vertex)
                let edge1 = Edge(vertex: neighbor, weight: randomWeight)
                if vertex.edges.contains(where: { $0.neighbor == neighbor }) {
                    continue
                }
                let edge2 = Edge(vertex: vertex, weight: randomWeight)
                vertex.edges.append(edge1)
                neighbor.edges.append(edge2)
            }
        }
    }

    private func randomVertex(except vertex: Vertex) -> Vertex {
        var newSet = self._vertices
        newSet.remove(vertex)
        let offset = Int(arc4random_uniform(UInt32(newSet.count)))
        let index = newSet.index(newSet.startIndex, offsetBy: offset)
        return newSet[index]
    }

    private func setVertexLevels() {
        self._vertices.forEach { $0.clearLevelInfo() }
        guard let startVertex = self.startVertex else {
            assertionFailure()
            return
        }
        var queue: [Vertex] = [startVertex]
        startVertex.levelChecked = true

        //BFS
        while !queue.isEmpty {
            let currentVertex = queue.first!
            for edge in currentVertex.edges {
                let neighbor = edge.neighbor
                if !neighbor.levelChecked {
                    neighbor.levelChecked = true
                    neighbor.level = currentVertex.level + 1
                    queue.append(neighbor)
                }
            }
            queue.removeFirst()
        }
    }

    public func findShortestPathsWithVisualization(completion: () -> Void) {
        self.clearCache()
        startVertex.pathLengthFromStart = 0
        startVertex.pathVerticesFromStart.append(self.startVertex)
        var currentVertex: Vertex! = self.startVertex

        var totalVertices = self._vertices

        breakableLoop: while currentVertex != nil {
            totalVertices.remove(currentVertex)
            while self.pauseVisualization == true {
                if self.stopVisualization == true {
                    break breakableLoop
                }
            }
            if self.stopVisualization == true {
                break breakableLoop
            }
            DispatchQueue.main.async {
                currentVertex.setVisitedColor()
            }
            usleep(750000)
            currentVertex.visited = true
            let filteredEdges = currentVertex.edges.filter { !$0.neighbor.visited }
            for edge in filteredEdges {
                let neighbor = edge.neighbor
                let weight = edge.weight
                let edgeRepresentation = edge.edgeRepresentation

                while self.pauseVisualization == true {
                    if self.stopVisualization == true {
                        break breakableLoop
                    }
                }
                if self.stopVisualization == true {
                    break breakableLoop
                }
                DispatchQueue.main.async {
                    edgeRepresentation?.setCheckingColor()
                    neighbor.setCheckingPathColor()
                    self.delegate?.willCompareVertices(startVertexPathLength: currentVertex.pathLengthFromStart,
                                                       edgePathLength: weight,
                                                       endVertexPathLength: neighbor.pathLengthFromStart)
                }
                usleep(self._visualizationOneSleepDuration)


                let theoreticNewWeight = currentVertex.pathLengthFromStart + weight

                if theoreticNewWeight < neighbor.pathLengthFromStart {
                    while self.pauseVisualization == true {
                        if self.stopVisualization == true {
                            break breakableLoop
                        }
                    }
                    if self.stopVisualization == true {
                        break breakableLoop
                    }
                    neighbor.pathLengthFromStart = theoreticNewWeight
                    neighbor.pathVerticesFromStart = currentVertex.pathVerticesFromStart
                    neighbor.pathVerticesFromStart.append(neighbor)
                }
                usleep(self._visualizationOneSleepDuration)

                DispatchQueue.main.async {
                    self.delegate?.didFinishCompare()
                    edge.edgeRepresentation?.setDefaultColor()
                    edge.neighbor.setDefaultColor()
                }
                usleep(self._visualizationOneSleepDuration)
            }
            if totalVertices.isEmpty {
                currentVertex = nil
                break
            }
            currentVertex = totalVertices.min { $0.pathLengthFromStart < $1.pathLengthFromStart }
        }
        if self.stopVisualization == true {
            DispatchQueue.main.async {
                self.delegate?.didStop()
            }
        } else {
            completion()
        }
    }

    public func parseNeighborsFor(vertex: Vertex, completion: @escaping () -> ()) {
        DispatchQueue.main.async {
            vertex.setVisitedColor()
        }
        DispatchQueue.global(qos: .background).async {
            vertex.visited = true

            let nonVisitedVertices = self._vertices.filter { $0.visited == false }
            if nonVisitedVertices.isEmpty {
                self.state = .completed
                DispatchQueue.main.async {
                    self.delegate?.didCompleteGraphParsing()
                }
                return
            }

            let filteredEdges = vertex.edges.filter { !$0.neighbor.visited }
            breakableLoop: for edge in filteredEdges {
                while self.pauseVisualization == true {
                    if self.stopVisualization == true {
                        break breakableLoop
                    }
                }
                if self.stopVisualization == true {
                    break breakableLoop
                }
                let weight = edge.weight
                let neighbor = edge.neighbor

                DispatchQueue.main.async {
                    edge.neighbor.setCheckingPathColor()
                    edge.edgeRepresentation?.setCheckingColor()
                    self.delegate?.willCompareVertices(startVertexPathLength: vertex.pathLengthFromStart,
                                                       edgePathLength: weight,
                                                       endVertexPathLength: neighbor.pathLengthFromStart)
                }
                usleep(self._interactiveOneSleepDuration)
                
                let theoreticNewWeight = vertex.pathLengthFromStart + weight
                if theoreticNewWeight < neighbor.pathLengthFromStart {
                    while self.pauseVisualization == true {
                        if self.stopVisualization == true {
                            break breakableLoop
                        }
                    }
                    if self.stopVisualization == true {
                        break breakableLoop
                    }
                    neighbor.pathLengthFromStart = theoreticNewWeight
                    neighbor.pathVerticesFromStart = vertex.pathVerticesFromStart
                    neighbor.pathVerticesFromStart.append(neighbor)
                }

                usleep(self._interactiveOneSleepDuration)
                while self.pauseVisualization == true {
                    if self.stopVisualization == true {
                        break breakableLoop
                    }
                }
                if self.stopVisualization == true {
                    break breakableLoop
                }
                DispatchQueue.main.async {
                    self.delegate?.didFinishCompare()
                    edge.neighbor.setDefaultColor()
                    edge.edgeRepresentation?.setDefaultColor()
                }
                usleep(self._interactiveOneSleepDuration)
            }
            if self.stopVisualization == true {
                DispatchQueue.main.async {
                    self.delegate?.didStop()
                }
            } else {
                let nextVertexPathLength = nonVisitedVertices.sorted { $0.pathLengthFromStart < $1.pathLengthFromStart }.first!.pathLengthFromStart
                self.nextVertices = nonVisitedVertices.filter { $0.pathLengthFromStart == nextVertexPathLength }
                completion()
            }
        }
    }

    public func didTapVertex(vertex: Vertex) {
        if self.nextVertices.contains(vertex) {
            self.delegate?.willStartVertexNeighborsChecking()
            self.state = .parsing
            self.parseNeighborsFor(vertex: vertex) {
                self.state = .interactiveVisualization
                self.delegate?.didFinishVertexNeighborsChecking()
            }
        } else {
            self.delegate?.didTapWrongVertex()
        }
    }
}
