import UIKit

public class Vertex: Hashable, Equatable {
    private var graphColors: GraphColors = GraphColors.sharedInstance

    public var identifier: String
    public var edges: [Edge] = []
    public var pathLengthFromStart: Double = Double.infinity {
        didSet {
            DispatchQueue.main.async {
                self.view?.setPathLengthLabel(text: "\(self.pathLengthFromStart)")
            }
        }
    }
    public var pathVerticesFromStart: [Vertex] = []
    public var level: Int = 0
    public var levelChecked: Bool = false
    public var haveAllEdges: Bool = false
    public var visited: Bool = false

    public var view: VertexView?

    public init(identifier: String) {
        self.identifier = identifier
    }

    public var hashValue: Int {
        return self.identifier.hashValue
    }

    public static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        if lhs.hashValue == rhs.hashValue {
            return true
        }
        return false
    }

    public func clearCache() {
        self.pathLengthFromStart = Double.infinity
        self.pathVerticesFromStart = []
        self.visited = false
    }

    public func clearLevelInfo() {
        self.level = 0
        self.levelChecked = false
    }

    public func setVisitedColor() {
        self.view?.backgroundColor = self.graphColors.visitedColor
        self.view?.setLabelsTextColor(color: UIColor.white)
    }

    public func setCheckingPathColor() {
        self.view?.backgroundColor = self.graphColors.checkingColor
    }

    public func setDefaultColor() {
        self.view?.backgroundColor = self.graphColors.defaultVertexColor
        self.view?.setLabelsTextColor(color: UIColor.black)
    }
}
