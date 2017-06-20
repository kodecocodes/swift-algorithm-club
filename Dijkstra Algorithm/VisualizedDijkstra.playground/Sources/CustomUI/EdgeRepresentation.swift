import UIKit

public class EdgeRepresentation {
    private var graphColors: GraphColors = GraphColors.sharedInstance

    public private(set)var label: UILabel!
    public private(set)var layer: MyShapeLayer!

    public init(from vertex1: Vertex, to vertex2: Vertex, weight: Double) {
        guard let vertex1View = vertex1.view, let vertex2View = vertex2.view else {
            assertionFailure("passed vertices without configured views")
            return
        }
        let x1 = vertex1View.frame.origin.x
        let y1 = vertex1View.frame.origin.y
        let width1 = vertex1View.frame.width
        let height1 = vertex1View.frame.height

        let x2 = vertex2View.frame.origin.x
        let y2 = vertex2View.frame.origin.y
        let width2 = vertex2View.frame.width
        let height2 = vertex2View.frame.height

        var startPoint: CGPoint
        var endPoint: CGPoint

        if y1 == y2 {
            if x1 < x2 {
                startPoint = CGPoint(x: x1 + width1, y: y1 + height1 / 2)
                endPoint = CGPoint(x: x2, y: y2 + height2 / 2)
            } else {
                startPoint = CGPoint(x: x1, y: y1 + height1 / 2)
                endPoint = CGPoint(x: x2 + width2, y: y2 + height2 / 2)
            }
        } else {
            startPoint = CGPoint(x: x1 + width1 / 2, y: y1 + height1)
            endPoint = CGPoint(x: x2 + width2 / 2, y: y2)
        }

        let arcDiameter: CGFloat = 20
        var circleOrigin: CGPoint!

        if endPoint.x == startPoint.x {
            startPoint.y -= 1
            endPoint.y += 1
            let x = startPoint.x - arcDiameter / 2
            let y = startPoint.y + ((endPoint.y - startPoint.y) / 2 * 1.25 - arcDiameter / 2)
            circleOrigin = CGPoint(x: x, y: y)
        } else if endPoint.y == startPoint.y {
            let x = startPoint.x + ((endPoint.x - startPoint.x) / 2 * 1.25 - arcDiameter / 2)
            let y = startPoint.y + ((endPoint.y - startPoint.y) / 2 * 1.25 - arcDiameter / 2)
            circleOrigin = CGPoint(x: x, y: y)
        } else {
            startPoint.x -= 1
            endPoint.x += 1
            startPoint.y -= 1
            endPoint.y += 1
            let x = startPoint.x + ((endPoint.x - startPoint.x) / 2 * 1.25 - arcDiameter / 2)
            let y = startPoint.y + ((endPoint.y - startPoint.y) / 2 * 1.25 - arcDiameter / 2)
            circleOrigin = CGPoint(x: x, y: y)
        }


        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)

        let label = UILabel(frame: CGRect(origin: circleOrigin, size: CGSize(width: arcDiameter, height: arcDiameter)))
        label.textAlignment = .center
        label.backgroundColor = graphColors.defaultEdgeColor
        label.clipsToBounds = true
        label.adjustsFontSizeToFitWidth = true
        label.layer.cornerRadius = arcDiameter / 2
        label.text = ""

        let shapeLayer = MyShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = graphColors.defaultEdgeColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.startPoint = startPoint
        shapeLayer.endPoint = endPoint
        shapeLayer.actions = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]

        self.layer = shapeLayer
        self.label = label
        self.label.text = "\(weight)"
    }

    public func setCheckingColor() {
        layer.strokeColor = graphColors.checkingColor.cgColor
        label.backgroundColor = graphColors.checkingColor
    }

    public func setDefaultColor() {
        layer.strokeColor = graphColors.defaultEdgeColor.cgColor
        label.backgroundColor = graphColors.defaultEdgeColor
    }

    public func setText(text: String) {
        label.text = text
    }
}

extension EdgeRepresentation: Equatable {
    public static func ==(lhs: EdgeRepresentation, rhs: EdgeRepresentation) -> Bool {
        return lhs.label.hashValue == rhs.label.hashValue && lhs.layer.hashValue == rhs.layer.hashValue
    }
}
