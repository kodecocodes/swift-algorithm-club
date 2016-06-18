import Foundation
import XCTest

extension Graph {
  public func loadEdgeList(lines: [String]) {
    for line in lines {
      let items = line.componentsSeparatedByString(" ").filter { s in !s.isEmpty }
      if adjacencyList(forNode: items[0]) == nil {
        addNode(items[0])
      }
      if adjacencyList(forNode: items[1]) == nil {
        addNode(items[1])
      }
      addEdge(fromNode: items[0], toNode: items[1])
    }
  }
}

class TopologicalSort: XCTestCase {

  // The topological sort is valid if a node does not have any of its
  // predecessors in its adjacency list.
  func checkIsValidTopologicalSort(graph: Graph, _ a: [Graph.Node]) {
    for i in (a.count - 1).stride(to: 0, by: -1) {
      if let neighbors = graph.adjacencyList(forNode: a[i]) {
        for j in (i - 1).stride(through: 0, by: -1) {
          XCTAssertFalse(neighbors.contains(a[j]), "\(a) is not a valid topological sort")
        }
      }
    }
  }

  func testTopologicalSort() {
    let graph = Graph()

    let node5 = graph.addNode("5")
    let node7 = graph.addNode("7")
    let node3 = graph.addNode("3")
    let node11 = graph.addNode("11")
    let node8 = graph.addNode("8")
    let node2 = graph.addNode("2")
    let node9 = graph.addNode("9")
    let node10 = graph.addNode("10")

    graph.addEdge(fromNode: node5, toNode: node11)
    graph.addEdge(fromNode: node7, toNode: node11)
    graph.addEdge(fromNode: node7, toNode: node8)
    graph.addEdge(fromNode: node3, toNode: node8)
    graph.addEdge(fromNode: node3, toNode: node10)
    graph.addEdge(fromNode: node11, toNode: node2)
    graph.addEdge(fromNode: node11, toNode: node9)
    graph.addEdge(fromNode: node11, toNode: node10)
    graph.addEdge(fromNode: node8, toNode: node9)

    XCTAssertEqual(graph.topologicalSort(), ["5", "7", "11", "2", "3", "10", "8", "9"])
    XCTAssertEqual(graph.topologicalSortKahn(), ["3", "7", "5", "8", "11", "2", "9", "10"])
    XCTAssertEqual(graph.topologicalSortAlternative(), ["5", "7", "3", "8", "11", "10", "9", "2"])
  }

  func testTopologicalSortEdgeLists() {
    let p1 = ["A B", "A C", "B C", "B D", "C E", "C F", "E D", "F E", "G A", "G F"]
    let p2 = ["B C", "C D", "C G", "B F", "D G", "G E", "F G", "F G"]
    let p3 = ["S V", "S W", "V T", "W T"]
    let p4 = ["5 11", "7 11", "7 8", "3 8", "3 10", "11 2", "11 9", "11 10", "8 9"]

    let data = [ p1, p2, p3, p4 ]

    for d in data {
      let graph = Graph()
      graph.loadEdgeList(d)

      let sorted1 = graph.topologicalSort()
      checkIsValidTopologicalSort(graph, sorted1)

      let sorted2 = graph.topologicalSortKahn()
      checkIsValidTopologicalSort(graph, sorted2)

      let sorted3 = graph.topologicalSortAlternative()
      checkIsValidTopologicalSort(graph, sorted3)
    }
  }
}
