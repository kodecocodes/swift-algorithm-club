import UIKit

public class RoundedButton: UIButton {
    private var graphColors: GraphColors = GraphColors.sharedInstance
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        self.backgroundColor = self.graphColors.buttonsBackgroundColor
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.layer.cornerRadius = 7
    }
}
