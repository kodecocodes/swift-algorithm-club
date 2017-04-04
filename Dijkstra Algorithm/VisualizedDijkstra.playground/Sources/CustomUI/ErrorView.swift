import UIKit

public class ErrorView: UIView {
    private var label: UILabel!
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        self.backgroundColor = UIColor(red: 242/255, green: 156/255, blue: 84/255, alpha: 1)
        self.layer.cornerRadius = 10

        let labelFrame = CGRect(x: 10, y: 10, width: self.frame.width - 20, height: self.frame.height - 20)
        self.label = UILabel(frame: labelFrame)
        self.label.numberOfLines = 0
        self.label.adjustsFontSizeToFitWidth = true
        self.label.textAlignment = .center
        self.label.textColor = UIColor.white
        self.addSubview(self.label)
    }

    public func setText(text: String) {
        self.label.text = text
    }
}
