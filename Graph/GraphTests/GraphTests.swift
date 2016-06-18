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

  func testEdgesFromReturnsCorrectEdgeInSingleEdgeDirecedGraphWithType(graphType: AbstractGraph<Int>.Type) {
    let graph = graphType.init()

    let a = graph.createVertex(1)
    let b = graph.createVertex(2)

    graph.addDirectedEdge(a, to: b, withWeight: 1.0)

    let edgesFromA = graph.edgesFrom(a)
    let edgesFromB = graph.edgesFrom(b)

    XCTAssertEqual(edgesFromA.count, 1)
    XCTAssertEqual(edgesFromB.count, 0)

    XCTAssertEqual(edgesFromA.first?.to, b)
  }

  func testEdgesFromReturnsCorrectEdgeInSingleEdgeUndirectedGraphWithType(graphType: AbstractGraph<Int>.Type) {
    let graph = graphType.init()

    let a = graph.createVertex(1)
    let b = graph.createVertex(2)

    graph.addUndirectedEdge((a, b), withWeight: 1.0)

    let edgesFromA = graph.edgesFrom(a)
    let edgesFromB = graph.edgesFrom(b)

    XCTAssertEqual(edgesFromA.count, 1)
    XCTAssertEqual(edgesFromB.count, 1)

    XCTAssertEqual(edgesFromA.first?.to, b)
    XCTAssertEqual(edgesFromB.first?.to, a)
  }

  func testEdgesFromReturnsNoEdgesInNoEdgeGraphWithType(graphType: AbstractGraph<Int>.Type) {
    let graph = graphType.init()

    let a = graph.createVertex(1)
    let b = graph.createVertex(2)

    XCTAssertEqual(graph.edgesFrom(a).count, 0)
    XCTAssertEqual(graph.edgesFrom(b).count, 0)
  }

  func testEdgesFromReturnsCorrectEdgesInBiggerGraphInDirectedGraphWithType(graphType: AbstractGraph<Int>.Type) {
    let graph = graphType.init()
    let verticesCount = 100
    var vertices: [Vertex<Int>] = []

    for i in 0..<verticesCount {
      vertices.append(graph.createVertex(i))
    }

    for i in 0..<verticesCount {
      for j in i+1..<verticesCount {
        graph.addDirectedEdge(vertices[i], to: vertices[j], withWeight: 1)
      }
    }

    for i in 0..<verticesCount {
      let outEdges = graph.edgesFrom(vertices[i])
      let toVertices = outEdges.map {return $0.to}
      XCTAssertEqual(outEdges.count, verticesCount - i - 1)
      for j in i+1..<verticesCount {
        XCTAssertTrue(toVertices.contains(vertices[j]))
      }
    }
  }

  func testEdgesFromReturnsCorrectEdgeInSingleEdgeDirecedMatrixGraph() {
    testEdgesFromReturnsCorrectEdgeInSingleEdgeDirecedGraphWithType(AdjacencyMatrixGraph<Int>)
  }

  func testEdgesFromReturnsCorrectEdgeInSingleEdgeUndirectedMatrixGraph() {
    testEdgesFromReturnsCorrectEdgeInSingleEdgeUndirectedGraphWithType(AdjacencyMatrixGraph<Int>)
  }

  func testEdgesFromReturnsNoInNoEdgeMatrixGraph() {
    testEdgesFromReturnsNoEdgesInNoEdgeGraphWithType(AdjacencyMatrixGraph<Int>)
  }

  func testEdgesFromReturnsCorrectEdgesInBiggerGraphInDirectedMatrixGraph() {
    testEdgesFromReturnsCorrectEdgesInBiggerGraphInDirectedGraphWithType(AdjacencyMatrixGraph<Int>)
  }

  func testEdgesFromReturnsCorrectEdgeInSingleEdgeDirecedListGraph() {
    testEdgesFromReturnsCorrectEdgeInSingleEdgeDirecedGraphWithType(AdjacencyListGraph<Int>)
  }

  func testEdgesFromReturnsCorrectEdgeInSingleEdgeUndirectedListGraph() {
    testEdgesFromReturnsCorrectEdgeInSingleEdgeUndirectedGraphWithType(AdjacencyListGraph<Int>)
  }

  func testEdgesFromReturnsNoInNoEdgeListGraph() {
    testEdgesFromReturnsNoEdgesInNoEdgeGraphWithType(AdjacencyListGraph<Int>)
  }

  func testEdgesFromReturnsCorrectEdgesInBiggerGraphInDirectedListGraph() {
    testEdgesFromReturnsCorrectEdgesInBiggerGraphInDirectedGraphWithType(AdjacencyListGraph<Int>)
  }
}
