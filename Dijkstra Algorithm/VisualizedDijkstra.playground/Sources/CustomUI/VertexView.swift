import UIKit

public class VertexView: UIButton {

    public var vertex: Vertex?
    private var idLabel: UILabel!
    private var pathLengthLabel: UILabel!
    private var graphColors: GraphColors = GraphColors.sharedInstance

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override init(frame: CGRect) {
        precondition(frame.height == frame.width)
        precondition(frame.height >= 30)
        super.init(frame: frame)
        backgroundColor = graphColors.defaultVertexColor
        layer.cornerRadius = frame.width / 2
        clipsToBounds = true
        setupIdLabel()
        setupPathLengthFromStartLabel()
    }

    private func setupIdLabel() {
        let x: CGFloat = frame.width * 0.2
        let y: CGFloat = 0
        let width: CGFloat = frame.width * 0.6
        let height: CGFloat = frame.height / 2
        let idLabelFrame = CGRect(x: x, y: y, width: width, height: height)

        idLabel = UILabel(frame: idLabelFrame)
        idLabel.textAlignment = .center
        idLabel.adjustsFontSizeToFitWidth = true
        addSubview(idLabel)
    }

    private func setupPathLengthFromStartLabel() {
        let x: CGFloat = frame.width * 0.2
        let y: CGFloat = frame.height / 2
        let width: CGFloat = frame.width * 0.6
        let height: CGFloat = frame.height / 2
        let pathLengthLabelFrame = CGRect(x: x, y: y, width: width, height: height)

        pathLengthLabel = UILabel(frame: pathLengthLabelFrame)
        pathLengthLabel.textAlignment = .center
        pathLengthLabel.adjustsFontSizeToFitWidth = true
        addSubview(pathLengthLabel)
    }

    public func setIdLabel(text: String) {
        idLabel.text = text
    }

    public func setPathLengthLabel(text: String) {
        pathLengthLabel.text = text
    }

    public func setLabelsTextColor(color: UIColor) {
        idLabel.textColor = color
        pathLengthLabel.textColor = color
    }
}
