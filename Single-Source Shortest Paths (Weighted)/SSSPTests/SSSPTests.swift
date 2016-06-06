//
//  SSSPTests.swift
//  SSSPTests
//
//  Created by Andrew McKnight on 5/8/16.
//

import Graph
import XCTest
@testable import SSSP

class SSSPTests: XCTestCase {

  /**
   See Figure 24.4 of “Introduction to Algorithms” by Cormen et al, 3rd ed., pg 652
   */
  func testExampleFromBook() {
    let graph = AdjacencyMatrixGraph<String>()
    let s = graph.createVertex("s")
    let t = graph.createVertex("t")
    let x = graph.createVertex("x")
    let y = graph.createVertex("y")
    let z = graph.createVertex("z")

    graph.addDirectedEdge(s, to: t, withWeight: 6)
    graph.addDirectedEdge(s, to: y, withWeight: 7)

    graph.addDirectedEdge(t, to: x, withWeight: 5)
    graph.addDirectedEdge(t, to: y, withWeight: 8)
    graph.addDirectedEdge(t, to: z, withWeight: -4)

    graph.addDirectedEdge(x, to: t, withWeight: -2)

    graph.addDirectedEdge(y, to: x, withWeight: -3)
    graph.addDirectedEdge(y, to: z, withWeight: 9)

    graph.addDirectedEdge(z, to: s, withWeight: 2)
    graph.addDirectedEdge(z, to: x, withWeight: 7)

    let result = BellmanFord<String>.apply(graph, source: s)!

    let expectedPath = ["s", "y", "x", "t", "z"]
    let computedPath = result.path(z, inGraph: graph)!
    XCTAssertEqual(expectedPath, computedPath, "expected path of \(expectedPath) but got \(computedPath)")

    let expectedWeight = -2.0
    let computedWeight = result.distance(z)
    XCTAssertEqual(expectedWeight, computedWeight, "expected weight of \(expectedWeight) but got \(computedWeight)")
  }

  func testSimpleExample() {
    let graph = AdjacencyMatrixGraph<String>()
    let a = graph.createVertex("a")
    let b = graph.createVertex("b")
    let c = graph.createVertex("c")
    let d = graph.createVertex("d")
    let e = graph.createVertex("e")

    graph.addDirectedEdge(a, to: b, withWeight: 4)
    graph.addDirectedEdge(a, to: c, withWeight: 5)
    graph.addDirectedEdge(a, to: d, withWeight: 8)

    graph.addDirectedEdge(b, to: c, withWeight: -2)

    graph.addDirectedEdge(c, to: e, withWeight: 4)

    graph.addDirectedEdge(d, to: e, withWeight: 2)

    graph.addDirectedEdge(e, to: d, withWeight: 1)

    let result = BellmanFord<String>.apply(graph, source: a)!

    let expectedPath = ["a", "b", "c", "e", "d"]
    let computedPath = result.path(d, inGraph: graph)!
    XCTAssertEqual(expectedPath, computedPath, "expected path of \(expectedPath) but got \(computedPath)")

    let expectedWeight = 7.0
    let computedWeight = result.distance(d)
    XCTAssertEqual(expectedWeight, computedWeight, "expected weight of \(expectedWeight) but got \(computedWeight)")
  }

  /**
   Construct a nearly bipartite graph, except one vertex only has out-edges. Then no path should exist from the source to that vertex.
   */
  func testGraphWithUnreachableVertex() {
    let graph = AdjacencyMatrixGraph<String>()
    let a = graph.createVertex("a")
    let b = graph.createVertex("b")
    let s = graph.createVertex("s")
    let t = graph.createVertex("t")

    graph.addDirectedEdge(a, to: s, withWeight: 9)
    graph.addDirectedEdge(a, to: t, withWeight: 2)

    graph.addDirectedEdge(b, to: a, withWeight: 1)
    graph.addDirectedEdge(b, to: s, withWeight: 2)
    graph.addDirectedEdge(b, to: t, withWeight: 3)

    graph.addDirectedEdge(s, to: a, withWeight: 4)
    graph.addDirectedEdge(s, to: t, withWeight: 1)

    graph.addDirectedEdge(t, to: a, withWeight: 7)
    graph.addDirectedEdge(t, to: s, withWeight: 5)

    let result = BellmanFord<String>.apply(graph, source: a)!

    XCTAssertNil(result.path(b, inGraph: graph), "a path should not be defined from a ~> b")
    XCTAssertNil(result.distance(b), "a path should not be defined from a ~> b")
    XCTAssertNotNil(result.path(s, inGraph: graph), "a path should be defined from a ~> s")
    XCTAssertNotNil(result.distance(s), "a path should be defined from a ~> s")
    XCTAssertNotNil(result.path(t, inGraph: graph), "a path should be defined from a ~> t")
    XCTAssertNotNil(result.distance(t), "a path should be defined from a ~> t")
  }

  func testNegativeWeightCycle() {
    let graph = AdjacencyMatrixGraph<String>()
    let a = graph.createVertex("a")
    let b = graph.createVertex("b")
    let s = graph.createVertex("s")
    let t = graph.createVertex("t")

    graph.addDirectedEdge(a, to: t, withWeight: 2)

    graph.addDirectedEdge(b, to: t, withWeight: 5)

    graph.addDirectedEdge(s, to: a, withWeight: 4)
    graph.addDirectedEdge(s, to: b, withWeight: 4)

    graph.addDirectedEdge(t, to: s, withWeight: -15)

    XCTAssertNil(BellmanFord<String>.apply(graph, source: s), "negative weight cycle not reported")
  }

}
