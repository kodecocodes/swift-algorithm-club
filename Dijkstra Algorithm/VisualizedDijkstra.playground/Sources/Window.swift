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
    private var graphColors = GraphColors.sharedInstance

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        backgroundColor = graphColors.mainWindowBackgroundColor
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(graph: Graph) {
        self.graph = graph
        graph.createNewGraph()
        graph.delegate = self
        let frame = CGRect(x: 10, y: 170, width: self.frame.width - 20, height: self.frame.height - 180)
        graphView = GraphView(frame: frame, graph: graph)
        

        graphView.createNewGraph()
        addSubview(graphView)

        configureCreateGraphButton()
        configureStartVisualizationButton()
        configureStartInteractiveVisualizationButton()
        configureStartButton()
        configurePauseButton()
        configureStopButton()
        configureComparisonLabel()
        configureActivityIndicator()

        topView = UIView(frame: CGRect(x: 10, y: 10, width: frame.width - 20, height: 150))
        topView.backgroundColor = graphColors.topViewBackgroundColor
        topView.layer.cornerRadius = 15
        addSubview(topView)

        topView.addSubview(createGraphButton)
        topView.addSubview(startVisualizationButton)
        topView.addSubview(startInteractiveVisualizationButton)
        topView.addSubview(startButton)
        topView.addSubview(pauseButton)
        topView.addSubview(stopButton)
        topView.addSubview(comparisonLabel)
        topView.addSubview(activityIndicator)
    }

    private func configureCreateGraphButton() {
        let frame = CGRect(x: center.x - 200, y: 12, width: 100, height: 34)
        createGraphButton = RoundedButton(frame: frame)
        createGraphButton.setTitle("New graph", for: .normal)
        createGraphButton.addTarget(self, action: #selector(createGraphButtonTap), for: .touchUpInside)
    }

    private func configureStartVisualizationButton() {
        let frame = CGRect(x: center.x - 50, y: 12, width: 100, height: 34)
        startVisualizationButton = RoundedButton(frame: frame)
        startVisualizationButton.setTitle("Auto", for: .normal)
        startVisualizationButton.addTarget(self, action: #selector(startVisualizationButtonDidTap), for: .touchUpInside)
    }

    private func configureStartInteractiveVisualizationButton() {
        let frame = CGRect(x: center.x + 100, y: 12, width: 100, height: 34)
        startInteractiveVisualizationButton = RoundedButton(frame: frame)
        startInteractiveVisualizationButton.setTitle("Interactive", for: .normal)
        startInteractiveVisualizationButton.addTarget(self, action: #selector(startInteractiveVisualizationButtonDidTap), for: .touchUpInside)
    }

    private func configureStartButton() {
        let frame = CGRect(x: center.x - 65, y: 56, width: 30, height: 30)
        startButton = UIButton(frame: frame)
        let playImage = UIImage(named: "Start.png")
        startButton.setImage(playImage, for: .normal)
        startButton.isEnabled = false
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
    }

    private func configurePauseButton() {
        let frame = CGRect(x: center.x - 15, y: 56, width: 30, height: 30)
        pauseButton = UIButton(frame: frame)
        let pauseImage = UIImage(named: "Pause.png")
        pauseButton.setImage(pauseImage, for: .normal)
        pauseButton.isEnabled = false
        pauseButton.addTarget(self, action: #selector(didTapPauseButton), for: .touchUpInside)
    }

    private func configureStopButton() {
        let frame = CGRect(x: center.x + 35, y: 56, width: 30, height: 30)
        stopButton = UIButton(frame: frame)
        let stopImage = UIImage(named: "Stop.png")
        stopButton.setImage(stopImage, for: .normal)
        stopButton.isEnabled = false
        stopButton.addTarget(self, action: #selector(didTapStopButton), for: .touchUpInside)
    }

    private func configureComparisonLabel() {
        let size = CGSize(width: 250, height: 42)
        let origin = CGPoint(x: center.x - 125, y: 96)
        let frame = CGRect(origin: origin, size: size)
        comparisonLabel = UILabel(frame: frame)
        comparisonLabel.textAlignment = .center
        comparisonLabel.text = "Have fun!"
    }

    private func configureActivityIndicator() {
        let size = CGSize(width: 50, height: 42)
        let origin = CGPoint(x: center.x - 25, y: 100)
        let activityIndicatorFrame = CGRect(origin: origin, size: size)
        activityIndicator = UIActivityIndicatorView(frame: activityIndicatorFrame)
        activityIndicator.style = .whiteLarge
    }

    @objc private func createGraphButtonTap() {
        comparisonLabel.text = ""
        graphView.removeGraph()
        graph.removeGraph()
        graph.createNewGraph()
        graphView.createNewGraph()
        graph.state = .initial
    }

    @objc private func startVisualizationButtonDidTap() {
        comparisonLabel.text = ""
        pauseButton.isEnabled = true
        stopButton.isEnabled = true
        createGraphButton.isEnabled = false
        startVisualizationButton.isEnabled = false
        startInteractiveVisualizationButton.isEnabled = false
        createGraphButton.alpha = 0.5
        startVisualizationButton.alpha = 0.5
        startInteractiveVisualizationButton.alpha = 0.5

        if graph.state == .completed {
            graphView.reset()
            graph.reset()
        }
        graph.state = .autoVisualization
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
        comparisonLabel.text = ""
        pauseButton.isEnabled = true
        stopButton.isEnabled = true
        createGraphButton.isEnabled = false
        startVisualizationButton.isEnabled = false
        startInteractiveVisualizationButton.isEnabled = false
        createGraphButton.alpha = 0.5
        startVisualizationButton.alpha = 0.5
        startInteractiveVisualizationButton.alpha = 0.5

        if graph.state == .completed {
            graphView.reset()
            graph.reset()
        }

        guard let startVertex = graph.startVertex else {
            assertionFailure("startVertex is nil")
            return
        }
        startVertex.pathLengthFromStart = 0
        startVertex.pathVerticesFromStart.append(startVertex)
        graph.state = .parsing
        graph.parseNeighborsFor(vertex: startVertex) {
            self.graph.state = .interactiveVisualization
            DispatchQueue.main.async {
                self.comparisonLabel.text = "Pick next vertex"
            }
        }
    }

    @objc private func didTapStartButton() {
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        DispatchQueue.global(qos: .utility).async {
            self.graph.pauseVisualization = false
        }
    }

    @objc private func didTapPauseButton() {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        DispatchQueue.global(qos: .utility).async {
            self.graph.pauseVisualization = true
        }
    }

    @objc private func didTapStopButton() {
        startButton.isEnabled = false
        pauseButton.isEnabled = false
        comparisonLabel.text = ""
        activityIndicator.startAnimating()
        if graph.state == .parsing || graph.state == .autoVisualization {
            graph.stopVisualization = true
        } else if graph.state == .interactiveVisualization {
            didStop()
        }
    }

    private func setButtonsToInitialState() {
        createGraphButton.isEnabled = true
        startVisualizationButton.isEnabled = true
        startInteractiveVisualizationButton.isEnabled = true
        startButton.isEnabled = false
        pauseButton.isEnabled = false
        stopButton.isEnabled = false
        createGraphButton.alpha = 1
        startVisualizationButton.alpha = 1
        startInteractiveVisualizationButton.alpha = 1
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
        graph.state = .completed
        setButtonsToInitialState()
        comparisonLabel.text = "Completed!"
    }

    public func didTapWrongVertex() {
        if !subviews.contains { $0 is ErrorView } {
            showError(error: "You have picked wrong next vertex")
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
        graph.state = .initial
        graph.stopVisualization = false
        graph.pauseVisualization = false
        graphView.reset()
        graph.reset()
        setButtonsToInitialState()
        activityIndicator.stopAnimating()
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
