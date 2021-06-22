import UIKit

public class BoardView: UIView {
    // MARK: -- Public
    public var gameModel: GameModelAI!
    public let gameModelQueue: DispatchQueue = DispatchQueue.init(label: "gameModelQueue")
    public let mainQueue: DispatchQueue = DispatchQueue.main
    public var players: [Player] = [Player(name: "Player", symbol: "❌"),
                                    Player(name: "Computer", symbol: "⭕️")]
    
    // MARK: -- Override's
    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupBoard()
        self.setupResetButton()
        self.setupIndicator()
        self.startGame()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: -- Private
    private var buttons: [UIButton] = []
    
    private var stackView: UIStackView!
    
    private var resetButton: UIButton!
    
    private var indicator: UIActivityIndicatorView!
    
    private func startGame() {
        gameModelQueue.async {
            self.gameModel = GameModelAI.init(boardSize: 3, playersList: self.players)
            
            self.blockViewForUser()
            
            sleep(1)
            
            self.gameModel.makeMoveAI()
            
            self.unblockViewForUser()
        }
    }
    
    private func updateUI() {
        if gameModel.gameStatus != BoardStatus.continues {

            blockButtons()
        }
        
        boardToButtons()
    }
    
    private func boardToButtons() {
        var buttonIndex = 0
        
        for row in 0 ..< 3 {
            for column in 0 ..< 3 {
                let symbol = gameModel.board.table[row][column]
                if symbol != "0" {
                    self.buttons[buttonIndex].setTitle(PlayerSymbol(symbol), for: .normal)
                    self.buttons[buttonIndex].isUserInteractionEnabled = false
                }
                buttonIndex += 1
            }
        }
    }
    
    private func setupBoard() {
        self.stackView = UIStackView()
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.axis = .vertical
        self.stackView.alignment = .fill
        self.stackView.distribution = .fillEqually
        self.stackView.spacing = 10
        
        self.addSubview(self.stackView)
        
        for index in 1 ... 3 {
            let boardRow = self.createBoardRow(rowNumber: index)
            self.stackView.addArrangedSubview(boardRow)
        }
        
        // constraints
        let constraints = [
            self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.stackView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20),
            self.stackView.heightAnchor.constraint(equalTo: self.stackView.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func createBoardRow(rowNumber: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        for index in 1 ... 3 {
            let button = UIButton()
            let id = String(index + ( (rowNumber - 1) * 3 ) )
            button.restorationIdentifier = id
            button.backgroundColor = .lightGray
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            
            self.buttons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        return stackView
    }
    
    private func blockViewForUser() {
        DispatchQueue.main.async {
            self.blockButtons()
            self.updateUI()
            
            self.resetButton.isHidden = true
            self.indicator.isHidden = false
            self.indicator.startAnimating()
        }
    }
    
    private func unblockViewForUser() {
        DispatchQueue.main.async {
            self.unblockButtons()
            self.updateUI()
            
            self.resetButton.isHidden = false
            self.indicator.isHidden = true
            self.indicator.stopAnimating()
        }
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        let position = buttonIDtoPosition(id: sender.restorationIdentifier!)
        
        gameModelQueue.async {
            self.gameModel.playerMakeMove(selectedPosition: position)
                        
            self.blockViewForUser()
            
            sleep(1)
            
            self.gameModel.makeMoveAI()
            
            self.unblockViewForUser()
        }
    }
    
    private func setupResetButton() {
        self.resetButton = UIButton(type: .system)
        self.resetButton.translatesAutoresizingMaskIntoConstraints = false
        self.resetButton.setTitle("Reset", for: .normal)
        self.resetButton.backgroundColor = .lightGray
        self.resetButton.addTarget(self, action: #selector(resetButtonPressed(_:)), for: .touchUpInside)
        
        self.addSubview(self.resetButton)
        
        // constraints
        let constraints = [
            self.resetButton.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 10),
            self.resetButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.resetButton.widthAnchor.constraint(equalTo: self.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc private func resetButtonPressed(_ sender: UIButton) {
        self.gameModel.newRound()
        self.clearButtons()
        self.startGame()
    }
    
    private func setupIndicator() {
        self.indicator = UIActivityIndicatorView()
        self.indicator.translatesAutoresizingMaskIntoConstraints = false
        self.indicator.backgroundColor = .lightGray
        
        self.addSubview(self.indicator)
        
        // constraints
        let constraints = [
            self.indicator.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 10),
            self.indicator.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.indicator.widthAnchor.constraint(equalTo: self.widthAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func buttonIDtoPosition(id: String) -> (Int, Int) {
        switch id {
        case "1":
            return (0, 0)
        case "2":
            return (0, 1)
        case "3":
            return (0, 2)
        case "4":
            return (1, 0)
        case "5":
            return (1, 1)
        case "6":
            return (1, 2)
        case "7":
            return (2, 0)
        case "8":
            return (2, 1)
        case "9":
            return (2, 2)
        default:
            return (0, 0)
        }
    }
    
    private func clearButtons() {
        for button in self.buttons {
            button.setTitle("", for: .normal);
            button.isUserInteractionEnabled = true
        }
    }
    
    private func unblockButtons() {
        for button in self.buttons {
            button.isUserInteractionEnabled = true
        }
    }
    
    private func blockButtons() {
        for button in self.buttons {
            button.isUserInteractionEnabled = false
        }
    }
}
