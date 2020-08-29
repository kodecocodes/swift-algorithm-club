import Foundation
import XCTest

struct GridGraph: Graph {
    struct Vertex: Hashable {
        var x: Int
        var y: Int

        static func == (lhs: Vertex, rhs: Vertex) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }

        public var hashValue: Int {
            return x.hashValue ^ y.hashValue
        }
    }

    struct Edge: WeightedEdge {
        var cost: Double
        var target: Vertex
    }

    func edgesOutgoing(from vertex: Vertex) -> [Edge] {
        return [
            Edge(cost: 1, target: Vertex(x: vertex.x - 1, y: vertex.y)),
            Edge(cost: 1, target: Vertex(x: vertex.x + 1, y: vertex.y)),
            Edge(cost: 1, target: Vertex(x: vertex.x, y: vertex.y - 1)),
            Edge(cost: 1, target: Vertex(x: vertex.x, y: vertex.y + 1)),
        ]
    }
}

class AStarTests: XCTestCase {
    func testSameStartAndEnd() {
        let graph = GridGraph()
        let astar = AStar(graph: graph, heuristic: manhattanDistance)
        let path = astar.path(start: GridGraph.Vertex(x: 0, y: 0), target: GridGraph.Vertex(x: 0, y: 0))
        XCTAssertEqual(path.count, 1)
        XCTAssertEqual(path[0].x, 0)
        XCTAssertEqual(path[0].y, 0)
    }

    func testDiagonal() {
        let graph = GridGraph()
        let astar = AStar(graph: graph, heuristic: manhattanDistance)
        let path = astar.path(start: GridGraph.Vertex(x: 0, y: 0), target: GridGraph.Vertex(x: 10, y: 10))
        XCTAssertEqual(path.count, 21)
        XCTAssertEqual(path[0].x, 0)
        XCTAssertEqual(path[0].y, 0)
        XCTAssertEqual(path[20].x, 10)
        XCTAssertEqual(path[20].y, 10)
    }

    func manhattanDistance(_ s: GridGraph.Vertex, _ t: GridGraph.Vertex) -> Double {
        return Double(abs(s.x - t.x) + abs(s.y - t.y))
    }
}
