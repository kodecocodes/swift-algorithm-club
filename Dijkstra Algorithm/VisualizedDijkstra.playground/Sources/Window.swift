import Foundation
import UIKit

public protocol GraphDelegate: class {
    func willCompareVertices(startVertexPathLength: Double, edgePathLength: Double, endVertexPathLength: Double)
    func didFinishCompare()
    func didCompleteGraphParsing()
    func didTapWrongVertex()
    func didStop()
    func willStartVertexNeighborsChecking()
    func didFinishVertexNeighborsChecking()
}

public class Window: UIView, GraphDelegate {
    public var graphView: GraphView!

    private var topView: UIView!
    private var createGraphButton: RoundedButton!
    private var startVisualizationButton: RoundedButton!
    private var startInteractiveVisualizationButton: RoundedButton!
    private var startButton: UIButton!
    private var pauseButton: UIButton!
    private var stopButton: UIButton!
    private var comparisonLabel: UILabel!
    private var activityIndicator: UIActivityIndicatorView!
    private var graph: Graph!
    private var numberOfVertices: UInt!
    private var graphColors: GraphColors = GraphColors.sharedInstance

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = self.graphColors.mainWindowBackgroundColor
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(graph: Graph) {
        self.graph = graph
        self.graph.createNewGraph()
        self.graph.delegate = self
        let frame = CGRect(x: 10, y: 170, width: self.frame.width - 20, height: self.frame.height - 180)
        self.graphView = GraphView(frame: frame)
        self.graphView.layer.cornerRadius = 15

        self.graphView.configure(graph: self.graph)
        self.graphView.createNewGraph()
        self.addSubview(self.graphView)

        self.configureCreateGraphButton()
        self.configureStartVisualizationButton()
        self.configureStartInteractiveVisualizationButton()
        self.configureStartButton()
        self.configurePauseButton()
        self.configureStopButton()
        self.configureComparisonLabel()
        self.configureActivityIndicator()

        self.topView = UIView(frame: CGRect(x: 10, y: 10, width: self.frame.width - 20, height: 150))
        self.topView.backgroundColor = self.graphColors.topViewBackgroundColor
        self.topView.layer.cornerRadius = 15
        self.addSubview(self.topView)

        self.topView.addSubview(self.createGraphButton)
        self.topView.addSubview(self.startVisualizationButton)
        self.topView.addSubview(self.startInteractiveVisualizationButton)
        self.topView.addSubview(self.startButton)
        self.topView.addSubview(self.pauseButton)
        self.topView.addSubview(self.stopButton)
        self.topView.addSubview(self.comparisonLabel)
        self.topView.addSubview(self.activityIndicator)
    }

    private func configureCreateGraphButton() {
        let frame = CGRect(x: self.center.x - 200, y: 12, width: 100, height: 34)
        self.createGraphButton = RoundedButton(frame: frame)
        self.createGraphButton.setTitle("New graph", for: .normal)
        self.createGraphButton.addTarget(self, action: #selector(self.createGraphButtonTap), for: .touchUpInside)
    }

    private func configureStartVisualizationButton() {
        let frame = CGRect(x: self.center.x - 50, y: 12, width: 100, height: 34)
        self.startVisualizationButton = RoundedButton(frame: frame)
        self.startVisualizationButton.setTitle("Auto", for: .normal)
        self.startVisualizationButton.addTarget(self, action: #selector(self.startVisualizationButtonDidTap), for: .touchUpInside)
    }

    private func configureStartInteractiveVisualizationButton() {
        let frame = CGRect(x: self.center.x + 100, y: 12, width: 100, height: 34)
        self.startInteractiveVisualizationButton = RoundedButton(frame: frame)
        self.startInteractiveVisualizationButton.setTitle("Interactive", for: .normal)
        self.startInteractiveVisualizationButton.addTarget(self, action: #selector(self.startInteractiveVisualizationButtonDidTap), for: .touchUpInside)
    }

    private func configureStartButton() {
        let frame = CGRect(x: self.center.x - 65, y: 56, width: 30, height: 30)
        self.startButton = UIButton(frame: frame)
        let playImage = UIImage(named: "Start.png")
        self.startButton.setImage(playImage, for: .normal)
        self.startButton.isEnabled = false
        self.startButton.addTarget(self, action: #selector(self.didTapStartButton), for: .touchUpInside)
    }

    private func configurePauseButton() {
        let frame = CGRect(x: self.center.x - 15, y: 56, width: 30, height: 30)
        self.pauseButton = UIButton(frame: frame)
        let pauseImage = UIImage(named: "Pause.png")
        self.pauseButton.setImage(pauseImage, for: .normal)
        self.pauseButton.isEnabled = false
        self.pauseButton.addTarget(self, action: #selector(self.didTapPauseButton), for: .touchUpInside)
    }

    private func configureStopButton() {
        let frame = CGRect(x: self.center.x + 35, y: 56, width: 30, height: 30)
        self.stopButton = UIButton(frame: frame)
        let stopImage = UIImage(named: "Stop.png")
        self.stopButton.setImage(stopImage, for: .normal)
        self.stopButton.isEnabled = false
        self.stopButton.addTarget(self, action: #selector(self.didTapStopButton), for: .touchUpInside)
    }

    private func configureComparisonLabel() {
        let size = CGSize(width: 250, height: 42)
        let origin = CGPoint(x: self.center.x - 125, y: 96)
        let frame = CGRect(origin: origin, size: size)
        self.comparisonLabel = UILabel(frame: frame)
        self.comparisonLabel.textAlignment = .center
        self.comparisonLabel.text = "Have fun!"
    }

    private func configureActivityIndicator() {
        let size = CGSize(width: 50, height: 42)
        let origin = CGPoint(x: self.center.x - 25, y: 100)
        let activityIndicatorFrame = CGRect(origin: origin, size: size)
        self.activityIndicator = UIActivityIndicatorView(frame: activityIndicatorFrame)
        self.activityIndicator.activityIndicatorViewStyle = .whiteLarge
    }

    @objc private func createGraphButtonTap() {
        self.comparisonLabel.text = ""
        self.graphView.removeGraph()
        self.graph.removeGraph()
        self.graph.createNewGraph()
        self.graphView.createNewGraph()
        self.graph.state = .initial
    }

    @objc private func startVisualizationButtonDidTap() {
        self.comparisonLabel.text = ""
        self.pauseButton.isEnabled = true
        self.stopButton.isEnabled = true
        self.createGraphButton.isEnabled = false
        self.startVisualizationButton.isEnabled = false
        self.startInteractiveVisualizationButton.isEnabled = false
        self.createGraphButton.alpha = 0.5
        self.startVisualizationButton.alpha = 0.5
        self.startInteractiveVisualizationButton.alpha = 0.5

        if self.graph.state == .completed {
            self.graphView.reset()
            self.graph.reset()
        }
        self.graph.state = .autoVisualization
        DispatchQueue.global(qos: .background).async {
            self.graph.findShortestPathsWithVisualization {
                self.graph.state = .completed

                DispatchQueue.main.async {
                    self.startButton.isEnabled = false
                    self.pauseButton.isEnabled = false
                    self.stopButton.isEnabled = false
                    self.createGraphButton.isEnabled = true
                    self.startVisualizationButton.isEnabled = true
                    self.startInteractiveVisualizationButton.isEnabled = true
                    self.createGraphButton.alpha = 1
                    self.startVisualizationButton.alpha = 1
                    self.startInteractiveVisualizationButton.alpha = 1
                    self.comparisonLabel.text = "Completed!"
                }
            }
        }
    }

    @objc private func startInteractiveVisualizationButtonDidTap() {
        self.comparisonLabel.text = ""
        self.pauseButton.isEnabled = true
        self.stopButton.isEnabled = true
        self.createGraphButton.isEnabled = false
        self.startVisualizationButton.isEnabled = false
        self.startInteractiveVisualizationButton.isEnabled = false
        self.createGraphButton.alpha = 0.5
        self.startVisualizationButton.alpha = 0.5
        self.startInteractiveVisualizationButton.alpha = 0.5

        if self.graph.state == .completed {
            self.graphView.reset()
            self.graph.reset()
        }
        
        self.graph.startVertex.pathLengthFromStart = 0
        self.graph.startVertex.pathVerticesFromStart.append(self.graph.startVertex)
        self.graph.state = .parsing
        self.graph.parseNeighborsFor(vertex: self.graph.startVertex) {
            self.graph.state = .interactiveVisualization
            DispatchQueue.main.async {
                self.comparisonLabel.text = "Pick next vertex"
            }
        }
    }

    @objc private func didTapStartButton() {
        self.startButton.isEnabled = false
        self.pauseButton.isEnabled = true
        DispatchQueue.global(qos: .utility).async {
            self.graph.pauseVisualization = false
        }
    }

    @objc private func didTapPauseButton() {
        self.startButton.isEnabled = true
        self.pauseButton.isEnabled = false
        DispatchQueue.global(qos: .utility).async {
            self.graph.pauseVisualization = true
        }
    }

    @objc private func didTapStopButton() {
        self.startButton.isEnabled = false
        self.pauseButton.isEnabled = false
        self.comparisonLabel.text = ""
        self.activityIndicator.startAnimating()
        if self.graph.state == .parsing || self.graph.state == .autoVisualization {
            self.graph.stopVisualization = true
        } else if self.graph.state == .interactiveVisualization {
            self.didStop()
        }
    }

    private func setButtonsToInitialState() {
        self.createGraphButton.isEnabled = true
        self.startVisualizationButton.isEnabled = true
        self.startInteractiveVisualizationButton.isEnabled = true
        self.startButton.isEnabled = false
        self.pauseButton.isEnabled = false
        self.stopButton.isEnabled = false
        self.createGraphButton.alpha = 1
        self.startVisualizationButton.alpha = 1
        self.startInteractiveVisualizationButton.alpha = 1
    }

    private func showError(error: String) {
        DispatchQueue.main.async {
            let size = CGSize(width: 250, height: 42)
            let origin = CGPoint(x: self.topView.center.x - 125, y: 96)
            let frame = CGRect(origin: origin, size: size)
            let errorView = ErrorView(frame: frame)
            errorView.setText(text: error)
            self.topView.addSubview(errorView)
            UIView.animate(withDuration: 2, animations: {
                errorView.alpha = 0
            }, completion: { _ in
                errorView.removeFromSuperview()
            })
        }
    }

    // MARK: GraphDelegate
    public func didCompleteGraphParsing() {
        self.graph.state = .completed
        self.setButtonsToInitialState()
        self.comparisonLabel.text = "Completed!"
    }

    public func didTapWrongVertex() {
        if !self.subviews.contains { $0 is ErrorView } {
            self.showError(error: "You have picked wrong next vertex")
        }
    }

    public func willCompareVertices(startVertexPathLength: Double, edgePathLength: Double, endVertexPathLength: Double) {
        DispatchQueue.main.async {
            if startVertexPathLength + edgePathLength < endVertexPathLength {
                self.comparisonLabel.text = "\(startVertexPathLength) + \(edgePathLength) < \(endVertexPathLength) 👍"
            } else {
                self.comparisonLabel.text = "\(startVertexPathLength) + \(edgePathLength) >= \(endVertexPathLength) 👎"
            }
        }
    }

    public func didFinishCompare() {
        DispatchQueue.main.async {
            self.comparisonLabel.text = ""
        }
    }

    public func didStop() {
        self.graph.state = .initial
        self.graph.stopVisualization = false
        self.graph.pauseVisualization = false
        self.graphView.reset()
        self.graph.reset()
        self.setButtonsToInitialState()
        self.activityIndicator.stopAnimating()
    }

    public func willStartVertexNeighborsChecking() {
        DispatchQueue.main.async {
            self.comparisonLabel.text = ""
        }
    }

    public func didFinishVertexNeighborsChecking() {
        DispatchQueue.main.async {
            self.comparisonLabel.text = "Pick next vertex"
        }
    }
}
