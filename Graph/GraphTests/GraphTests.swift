//
//  GraphTests.swift
//  GraphTests
//
//  Created by Andrew McKnight on 5/8/16.
//

import XCTest
@testable import Graph

class GraphTests: XCTestCase {

  func testAdjacencyMatrixGraphDescription() {

    let graph = AdjacencyMatrixGraph<String>()

    let a = graph.createVertex("a")
    let b = graph.createVertex("b")
    let c = graph.createVertex("c")

    graph.addDirectedEdge(a, to: b, withWeight: 1.0)
    graph.addDirectedEdge(b, to: c, withWeight: 2.0)

    let expectedValue = "  ø   1.0   ø  \n  ø    ø   2.0 \n  ø    ø    ø  "
    XCTAssertEqual(graph.description, expectedValue)
  }

  func testAdjacencyListGraphDescription() {

    let graph = AdjacencyListGraph<String>()

    let a = graph.createVertex("a")
    let b = graph.createVertex("b")
    let c = graph.createVertex("c")

    graph.addDirectedEdge(a, to: b, withWeight: 1.0)
    graph.addDirectedEdge(b, to: c, withWeight: 2.0)
    graph.addDirectedEdge(a, to: c, withWeight: -5.5)

    let expectedValue = "a -> [(b: 1.0), (c: -5.5)]\nb -> [(c: 2.0)]"
    XCTAssertEqual(graph.description, expectedValue)
  }

  func testAddingPreexistingVertex() {
    let adjacencyList = AdjacencyListGraph<String>()
    let adjacencyMatrix = AdjacencyMatrixGraph<String>()

    for graph in [adjacencyList, adjacencyMatrix] {
      let a = graph.createVertex("a")
      let b = graph.createVertex("a")

      XCTAssertEqual(a, b, "Should have returned the same vertex when creating a new one with identical data")
      XCTAssertEqual(graph.vertices.count, 1, "Graph should only contain one vertex after trying to create two vertices with identical data")
    }
  }

}
