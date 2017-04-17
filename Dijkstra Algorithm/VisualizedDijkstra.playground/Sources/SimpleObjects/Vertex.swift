import UIKit

public class Vertex {
    private var graphColors: GraphColors = GraphColors.sharedInstance

    public var view: VertexView?
    
    public var identifier: String
    public var edges: [Edge] = []
    public var pathVerticesFromStart: [Vertex] = []
    public var level: Int = 0
    public var levelChecked: Bool = false
    public var haveAllEdges: Bool = false
    public var visited: Bool = false
    public var pathLengthFromStart: Double = Double.infinity {
        didSet {
            DispatchQueue.main.async {
                self.view?.setPathLengthLabel(text: "\(self.pathLengthFromStart)")
            }
        }
    }

    public init(identifier: String) {
        self.identifier = identifier
    }

    public func clearCache() {
        pathLengthFromStart = Double.infinity
        pathVerticesFromStart = []
        visited = false
    }

    public func clearLevelInfo() {
        level = 0
        levelChecked = false
    }

    public func setVisitedColor() {
        view?.backgroundColor = graphColors.visitedColor
        view?.setLabelsTextColor(color: UIColor.white)
    }

    public func setCheckingPathColor() {
        view?.backgroundColor = graphColors.checkingColor
    }

    public func setDefaultColor() {
        view?.backgroundColor = graphColors.defaultVertexColor
        view?.setLabelsTextColor(color: UIColor.black)
    }
}

extension Vertex: Hashable {
    public var hashValue: Int {
        return identifier.hashValue
    }
}

extension Vertex: Equatable {
    public static func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
