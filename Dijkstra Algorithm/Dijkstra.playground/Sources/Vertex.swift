import Foundation

open class Vertex: Hashable, Equatable {

    open var identifier: String!
    open var neighbors: [(Vertex, Double)] = []
    open var pathLengthFromStart: Double = Double.infinity
    open var pathVerticesFromStart: [Vertex] = []

    public init(identifier: String) {
        self.identifier = identifier
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
