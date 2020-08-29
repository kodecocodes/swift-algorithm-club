// Written by Alejandro Isaza.

import Foundation

public protocol Graph {
    associatedtype Vertex: Hashable
    associatedtype Edge: WeightedEdge where Edge.Vertex == Vertex

    /// Lists all edges going out from a vertex.
    func edgesOutgoing(from vertex: Vertex) -> [Edge]
}

public protocol WeightedEdge {
    associatedtype Vertex

    /// The edge's cost.
    var cost: Double { get }

    /// The target vertex.
    var target: Vertex { get }
}

public final class AStar<G: Graph> {
    /// The graph to search on.
    public let graph: G

    /// The heuristic cost function that estimates the cost between two vertices.
    ///
    /// - Note: The heuristic function needs to always return a value that is lower-than or equal to the actual
    ///         cost for the resulting path of the A* search to be optimal.
    public let heuristic: (G.Vertex, G.Vertex) -> Double

    /// Open list of nodes to expand.
    private var open: HashedHeap<Node<G.Vertex>>

    /// Closed list of vertices already expanded.
    private var closed = Set<G.Vertex>()

    /// Actual vertex cost for vertices we already encountered (refered to as `g` on the literature).
    private var costs = Dictionary<G.Vertex, Double>()

    /// Store the previous node for each expanded node to recreate the path.
    private var parents = Dictionary<G.Vertex, G.Vertex>()

    /// Initializes `AStar` with a graph and a heuristic cost function.
    public init(graph: G, heuristic: @escaping (G.Vertex, G.Vertex) -> Double) {
        self.graph = graph
        self.heuristic = heuristic
        open = HashedHeap(sort: <)
    }

    /// Finds an optimal path between `source` and `target`.
    ///
    /// - Precondition: both `source` and `target` belong to `graph`.
    public func path(start: G.Vertex, target: G.Vertex) -> [G.Vertex] {
        open.insert(Node<G.Vertex>(vertex: start, cost: 0, estimate: heuristic(start, target)))
        while !open.isEmpty {
            guard let node = open.remove() else {
                break
            }
            costs[node.vertex] = node.cost

            if (node.vertex == target) {
                let path = buildPath(start: start, target: target)
                cleanup()
                return path
            }

            if !closed.contains(node.vertex) {
                expand(node: node, target: target)
                closed.insert(node.vertex)
            }
        }

        // No path found
        return []
    }

    private func expand(node: Node<G.Vertex>, target: G.Vertex) {
        let edges = graph.edgesOutgoing(from: node.vertex)
        for edge in edges {
            let g = cost(node.vertex) + edge.cost
            if g < cost(edge.target) {
                open.insert(Node<G.Vertex>(vertex: edge.target, cost: g, estimate: heuristic(edge.target, target)))
                parents[edge.target] = node.vertex
            }
        }
    }

    private func cost(_ vertex: G.Edge.Vertex) -> Double {
        if let c = costs[vertex] {
            return c
        }

        let node = Node(vertex: vertex, cost: Double.greatestFiniteMagnitude, estimate: 0)
        if let index = open.index(of: node) {
            return open[index].cost
        }

        return Double.greatestFiniteMagnitude
    }

    private func buildPath(start: G.Vertex, target: G.Vertex) -> [G.Vertex] {
        var path = Array<G.Vertex>()
        path.append(target)

        var current = target
        while current != start {
            guard let parent = parents[current] else {
                return [] // no path found
            }
            current = parent
            path.append(current)
        }

        return path.reversed()
    }

    private func cleanup() {
        open.removeAll()
        closed.removeAll()
        parents.removeAll()
    }
}

private struct Node<V: Hashable>: Hashable, Comparable {
    /// The graph vertex.
    var vertex: V

    /// The actual cost between the start vertex and this vertex.
    var cost: Double

    /// Estimated (heuristic) cost betweent this vertex and the target vertex.
    var estimate: Double

    public init(vertex: V, cost: Double, estimate: Double) {
        self.vertex = vertex
        self.cost = cost
        self.estimate = estimate
    }

    static func < (lhs: Node<V>, rhs: Node<V>) -> Bool {
        return lhs.cost + lhs.estimate < rhs.cost + rhs.estimate
    }

    static func == (lhs: Node<V>, rhs: Node<V>) -> Bool {
        return lhs.vertex == rhs.vertex
    }

    var hashValue: Int {
        return vertex.hashValue
    }
}
