import UIKit

public class GraphView: UIView {
    private var graph: Graph
    private var panningView: VertexView? = nil
    private var graphColors = GraphColors.sharedInstance

    public init(frame: CGRect, graph: Graph) {
        self.graph = graph
        super.init(frame: frame)
        backgroundColor = graphColors.graphBackgroundColor
        layer.cornerRadius = 15
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    
    }

    public func removeGraph() {
        for vertex in graph.vertices {
            if let view = vertex.view {
                view.removeFromSuperview()
                vertex.view = nil
            }
        }
        for vertex in graph.vertices {
            for edge in vertex.edges {
                if let edgeRepresentation = edge.edgeRepresentation {
                    edgeRepresentation.layer.removeFromSuperlayer()
                    edgeRepresentation.label.removeFromSuperview()
                    edge.edgeRepresentation = nil
                }
            }
        }
    }

    public func createNewGraph() {
        setupVertexViews()
        setupEdgeRepresentations()
        addGraph()
    }

    public func reset() {
        for vertex in graph.vertices {
            vertex.edges.forEach { $0.edgeRepresentation?.setDefaultColor() }
            vertex.setDefaultColor()
        }
    }

    private func addGraph() {
        for vertex in graph.vertices {
            for edge in vertex.edges {
                if let edgeRepresentation = edge.edgeRepresentation {
                    layer.addSublayer(edgeRepresentation.layer)
                    addSubview(edgeRepresentation.label)
                }
            }
        }
        for vertex in graph.vertices {
            if let view = vertex.view {
                addSubview(view)
            }
        }
    }

    private func setupVertexViews() {
        var level = 0
        var buildViewQueue = [graph.startVertex!]
        let itemWidth: CGFloat = 40
        while !buildViewQueue.isEmpty {
            let levelItemsCount = CGFloat(buildViewQueue.count)
            let xStep = (frame.width - levelItemsCount * itemWidth) / (levelItemsCount + 1)
            var previousVertexMaxX: CGFloat = 0.0
            for vertex in buildViewQueue {
                let x: CGFloat = previousVertexMaxX + xStep
                let y: CGFloat = CGFloat(level * 100)
                previousVertexMaxX = x + itemWidth
                let frame = CGRect(x: x, y: y, width: itemWidth, height: itemWidth)
                let vertexView = VertexView(frame: frame)
                vertex.view = vertexView
                vertexView.vertex = vertex
                vertex.view?.setIdLabel(text: vertex.identifier)
                vertex.view?.setPathLengthLabel(text: "\(vertex.pathLengthFromStart)")
                vertex.view?.addTarget(self, action: #selector(didTapVertex(sender:)), for: .touchUpInside)
                let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
                vertex.view?.addGestureRecognizer(panGesture)
            }
            level += 1
            buildViewQueue = graph.vertices.filter { $0.level == level }
        }
    }

    private var movingVertexInputEdges: [EdgeRepresentation] = []
    private var movingVertexOutputEdges: [EdgeRepresentation] = []

    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        guard let vertexView = recognizer.view as? VertexView, let vertex = vertexView.vertex else {
            return
        }
        if panningView != nil {
            if panningView != vertexView {
                return
            }
        }

        switch recognizer.state {
        case .began:
            let movingVertexViewFrame = vertexView.frame
            let sizedVertexView = CGRect(x: movingVertexViewFrame.origin.x - 10,
                                         y: movingVertexViewFrame.origin.y - 10,
                                         width: movingVertexViewFrame.width + 20,
                                         height: movingVertexViewFrame.height + 20)
            vertex.edges.forEach { edge in
                if let edgeRepresentation = edge.edgeRepresentation{
                    if sizedVertexView.contains(edgeRepresentation.layer.startPoint!) {
                        movingVertexOutputEdges.append(edgeRepresentation)
                    } else {
                        movingVertexInputEdges.append(edgeRepresentation)
                    }
                }
            }
            panningView = vertexView
        case .changed:
            if movingVertexOutputEdges.isEmpty && movingVertexInputEdges.isEmpty {
                return
            }
            let translation = recognizer.translation(in: self)
            if vertexView.frame.origin.x + translation.x <= 0
                || vertexView.frame.origin.y + translation.y <= 0
                || (vertexView.frame.origin.x + vertexView.frame.width + translation.x) >= frame.width
                || (vertexView.frame.origin.y + vertexView.frame.height + translation.y) >= frame.height {
                break
            }
            movingVertexInputEdges.forEach { edgeRepresentation in
                let originalLabelCenter = edgeRepresentation.label.center
                edgeRepresentation.label.center = CGPoint(x: originalLabelCenter.x + translation.x * 0.625,
                                                          y: originalLabelCenter.y + translation.y * 0.625)

                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                let newPath = path(fromEdgeRepresentation: edgeRepresentation, movingVertex: vertex, translation: translation, outPath: false)
                edgeRepresentation.layer.path = newPath
                CATransaction.commit()

            }

            movingVertexOutputEdges.forEach { edgeRepresentation in
                let originalLabelCenter = edgeRepresentation.label.center
                edgeRepresentation.label.center = CGPoint(x: originalLabelCenter.x + translation.x * 0.375,
                                                          y: originalLabelCenter.y + translation.y * 0.375)

                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                let newPath = path(fromEdgeRepresentation: edgeRepresentation, movingVertex: vertex, translation: translation, outPath: true)
                edgeRepresentation.layer.path = newPath
                CATransaction.commit()
            }

            vertexView.center = CGPoint(x: vertexView.center.x + translation.x,
                                        y: vertexView.center.y + translation.y)
            recognizer.setTranslation(CGPoint.zero, in: self)
        case .ended:
            movingVertexInputEdges = []
            movingVertexOutputEdges = []
            panningView = nil
        default:
            break
        }
    }

    private func path(fromEdgeRepresentation edgeRepresentation: EdgeRepresentation, movingVertex: Vertex, translation: CGPoint, outPath: Bool) -> CGPath {
        let bezier = UIBezierPath()

        if outPath == true {
            bezier.move(to: edgeRepresentation.layer.endPoint!)
            let startPoint = CGPoint(x: edgeRepresentation.layer.startPoint!.x + translation.x,
                                     y: edgeRepresentation.layer.startPoint!.y + translation.y)
            edgeRepresentation.layer.startPoint = startPoint
            bezier.addLine(to: startPoint)
        } else {
            bezier.move(to: edgeRepresentation.layer.startPoint!)
            let endPoint = CGPoint(x: edgeRepresentation.layer.endPoint!.x + translation.x,
                                   y: edgeRepresentation.layer.endPoint!.y + translation.y)
            edgeRepresentation.layer.endPoint = endPoint
            bezier.addLine(to: endPoint)
        }
        return bezier.cgPath
    }

    @objc private func didTapVertex(sender: AnyObject) {
        DispatchQueue.main.async {
            if self.graph.state == .completed {
                for vertex in self.graph.vertices {
                    vertex.edges.forEach { $0.edgeRepresentation?.setDefaultColor() }
                    vertex.setVisitedColor()
                }
                if let vertexView = sender as? VertexView, let vertex = vertexView.vertex {
                    for (index, pathVertex) in vertex.pathVerticesFromStart.enumerated() {
                        pathVertex.setCheckingPathColor()
                        if vertex.pathVerticesFromStart.count > index + 1 {
                            let nextVertex = vertex.pathVerticesFromStart[index + 1]

                            if let edge = pathVertex.edges.filter({ $0.neighbor == nextVertex }).first {
                                edge.edgeRepresentation?.setCheckingColor()
                            }
                        }

                    }
                }
            } else if self.graph.state == .interactiveVisualization {
                if let vertexView = sender as? VertexView, let vertex = vertexView.vertex {
                    if vertex.visited {
                        return
                    } else {
                        self.graph.didTapVertex(vertex: vertex)
                    }
                }
            }
        }
    }

    private func setupEdgeRepresentations() {
        var edgeQueue: [Vertex] = [graph.startVertex!]

        //BFS
        while !edgeQueue.isEmpty {
            let currentVertex = edgeQueue.first!
            currentVertex.haveAllEdges = true
            for edge in currentVertex.edges {
                let neighbor = edge.neighbor
                let weight = edge.weight
                if !neighbor.haveAllEdges {
                    let edgeRepresentation = EdgeRepresentation(from: currentVertex, to: neighbor, weight: weight)
                    edge.edgeRepresentation = edgeRepresentation
                    let index = neighbor.edges.index(where: { $0.neighbor == currentVertex })!
                    neighbor.edges[index].edgeRepresentation = edgeRepresentation
                    edgeQueue.append(neighbor)
                }
            }
            edgeQueue.removeFirst()
        }
    }
}
