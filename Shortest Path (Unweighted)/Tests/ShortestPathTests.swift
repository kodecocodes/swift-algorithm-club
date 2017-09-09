import XCTest

class ShortestPathTests: XCTestCase {
  
  func testSwift4() {
    // last checked with Xcode 9.0b4
    #if swift(>=4.0)
      print("Hello, Swift 4!")
    #endif
  }

  func testShortestPathWhenGivenTree() {
    let tree = Graph()
    let nodeA = tree.addNode(label: "a")
    let nodeB = tree.addNode(label: "b")
    let nodeC = tree.addNode(label: "c")
    let nodeD = tree.addNode(label: "d")
    let nodeE = tree.addNode(label: "e")
    let nodeF = tree.addNode(label: "f")
    let nodeG = tree.addNode(label: "g")
    let nodeH = tree.addNode(label: "h")
    tree.addEdge(nodeA, neighbor: nodeB)
    tree.addEdge(nodeA, neighbor: nodeC)
    tree.addEdge(nodeB, neighbor: nodeD)
    tree.addEdge(nodeB, neighbor: nodeE)
    tree.addEdge(nodeC, neighbor: nodeF)
    tree.addEdge(nodeC, neighbor: nodeG)
    tree.addEdge(nodeE, neighbor: nodeH)

    let shortestPaths = breadthFirstSearchShortestPath(graph: tree, source: nodeA)

    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeA.label).distance, 0)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeB.label).distance, 1)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeC.label).distance, 1)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeD.label).distance, 2)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeE.label).distance, 2)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeF.label).distance, 2)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeG.label).distance, 2)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeH.label).distance, 3)
  }

  func testShortestPathWhenGivenGraph() {
    let graph = Graph()

    let nodeA = graph.addNode(label:"a")
    let nodeB = graph.addNode(label:"b")
    let nodeC = graph.addNode(label:"c")
    let nodeD = graph.addNode(label:"d")
    let nodeE = graph.addNode(label:"e")
    let nodeF = graph.addNode(label:"f")
    let nodeG = graph.addNode(label:"g")
    let nodeH = graph.addNode(label:"h")
    let nodeI = graph.addNode(label:"i")

    graph.addEdge(nodeA, neighbor: nodeB)
    graph.addEdge(nodeA, neighbor: nodeH)
    graph.addEdge(nodeB, neighbor: nodeA)
    graph.addEdge(nodeB, neighbor: nodeC)
    graph.addEdge(nodeB, neighbor: nodeH)
    graph.addEdge(nodeC, neighbor: nodeB)
    graph.addEdge(nodeC, neighbor: nodeD)
    graph.addEdge(nodeC, neighbor: nodeF)
    graph.addEdge(nodeC, neighbor: nodeI)
    graph.addEdge(nodeD, neighbor: nodeC)
    graph.addEdge(nodeD, neighbor: nodeE)
    graph.addEdge(nodeD, neighbor: nodeF)
    graph.addEdge(nodeE, neighbor: nodeD)
    graph.addEdge(nodeE, neighbor: nodeF)
    graph.addEdge(nodeF, neighbor: nodeC)
    graph.addEdge(nodeF, neighbor: nodeD)
    graph.addEdge(nodeF, neighbor: nodeE)
    graph.addEdge(nodeF, neighbor: nodeG)
    graph.addEdge(nodeG, neighbor: nodeF)
    graph.addEdge(nodeG, neighbor: nodeH)
    graph.addEdge(nodeG, neighbor: nodeI)
    graph.addEdge(nodeH, neighbor: nodeA)
    graph.addEdge(nodeH, neighbor: nodeB)
    graph.addEdge(nodeH, neighbor: nodeG)
    graph.addEdge(nodeH, neighbor: nodeI)
    graph.addEdge(nodeI, neighbor: nodeC)
    graph.addEdge(nodeI, neighbor: nodeG)
    graph.addEdge(nodeI, neighbor: nodeH)

    let shortestPaths = breadthFirstSearchShortestPath(graph: graph, source: nodeA)

    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeA.label).distance, 0)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeB.label).distance, 1)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeC.label).distance, 2)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeD.label).distance, 3)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeE.label).distance, 4)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeF.label).distance, 3)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeG.label).distance, 2)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeH.label).distance, 1)
    XCTAssertEqual(shortestPaths.findNodeWithLabel(label: nodeI.label).distance, 2)
  }
}
