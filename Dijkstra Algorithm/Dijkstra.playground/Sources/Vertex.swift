import Foundation

open class Vertex {

    open var identifier: String
    open var neighbors: [(Vertex, Double)] = []
    open var pathLengthFromStart: Double = Double.infinity
    open var pathVerticesFromStart: [Vertex] = []

    public init(identifier: String) {
        self.identifier = identifier
    }

    open func clearCache() {
        self.pathLengthFromStart = Double.infinity
        self.pathVerticesFromStart = []
    }
}

extension Vertex: Hashable {
    open var hashValue: Int {
        return self.identifier.hashValue
    }
}

extension Vertex: Equatable {
    public static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        if lhs.hashValue == rhs.hashValue {
            return true
        }
        return false
    }
}
