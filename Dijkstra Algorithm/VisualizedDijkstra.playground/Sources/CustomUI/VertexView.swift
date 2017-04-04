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
        self.backgroundColor = self.graphColors.defaultVertexColor
        self.layer.cornerRadius = frame.width / 2
        self.clipsToBounds = true
        self.setupIdLabel()
        self.setupPathLengthFromStartLabel()
    }

    private func setupIdLabel() {
        let x: CGFloat = self.frame.width * 0.2
        let y: CGFloat = 0
        let width: CGFloat = self.frame.width * 0.6
        let height: CGFloat = self.frame.height / 2
        let idLabelFrame = CGRect(x: x, y: y, width: width, height: height)

        self.idLabel = UILabel(frame: idLabelFrame)
        self.idLabel.textAlignment = .center
        self.idLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(self.idLabel)
    }

    private func setupPathLengthFromStartLabel() {
        let x: CGFloat = self.frame.width * 0.2
        let y: CGFloat = self.frame.height / 2
        let width: CGFloat = self.frame.width * 0.6
        let height: CGFloat = self.frame.height / 2
        let pathLengthLabelFrame = CGRect(x: x, y: y, width: width, height: height)

        self.pathLengthLabel = UILabel(frame: pathLengthLabelFrame)
        self.pathLengthLabel.textAlignment = .center
        self.pathLengthLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(self.pathLengthLabel)
    }

    public func setIdLabel(text: String) {
        self.idLabel.text = text
    }

    public func setPathLengthLabel(text: String) {
        self.pathLengthLabel.text = text
    }

    public func setLabelsTextColor(color: UIColor) {
        self.idLabel.textColor = color
        self.pathLengthLabel.textColor = color
    }
}
