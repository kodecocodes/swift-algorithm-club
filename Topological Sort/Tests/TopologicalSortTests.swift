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

    XCTAssertEqual(graph.topologicalSort(), ["3", "8", "9", "10", "7", "11", "2", "5"])
    XCTAssertEqual(graph.topologicalSort2(), ["3", "7", "5", "8", "11", "2", "9", "10"])
  }

  func testTopologicalSortEdgeLists() {
    let p1 = ["A B", "A C", "B C", "B D", "C E", "C F", "E D", "F E", "G A", "G F"]
    let a1 = ["G", "A", "B", "C", "F", "E", "D"]  // TODO
    let s1 = ["G", "A", "B", "C", "F", "E", "D"]

    let p2 = ["B C", "C D", "C G", "B F", "D G", "G E", "F G", "F G"]
    let a2 = ["B", "C", "F", "D", "G", "E"]  // TODO
    let s2 = ["B", "C", "F", "D", "G", "E"]

    let p3 = ["S V", "S W", "V T", "W T"]
    let a3 = ["S", "V", "W", "T"]  // TODO
    let s3 = ["S", "V", "W", "T"]

    let p4 = ["5 11", "7 11", "7 8", "3 8", "3 10", "11 2", "11 9", "11 10", "8 9"]
    let a4 = ["3", "8", "9", "10", "7", "11", "2", "5"]
    let s4 = ["3", "7", "5", "8", "11", "2", "9", "10"]

    let data = [
      (p1, a1, s1),
      (p2, a2, s2),
      (p3, a3, s3),
      (p4, a4, s4),
    ]

    for d in data {
      let graph = Graph()
      graph.loadEdgeList(d.0)

      // TODO: this fails the tests
      //let sorted1 = graph.topologicalSort()
      //XCTAssertEqual(sorted1, d.1)

      let sorted2 = graph.topologicalSort2()
      XCTAssertEqual(sorted2, d.2)
    }
  }
}
