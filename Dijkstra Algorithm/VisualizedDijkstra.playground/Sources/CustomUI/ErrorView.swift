import UIKit

public class ErrorView: UIView {
    private var label: UILabel!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        backgroundColor = UIColor(red: 242/255, green: 156/255, blue: 84/255, alpha: 1)
        layer.cornerRadius = 10

        let labelFrame = CGRect(x: 10, y: 10, width: frame.width - 20, height: frame.height - 20)
        label = UILabel(frame: labelFrame)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.textColor = UIColor.white
        addSubview(label)
    }

    public func setText(text: String) {
        label.text = text
    }
}
