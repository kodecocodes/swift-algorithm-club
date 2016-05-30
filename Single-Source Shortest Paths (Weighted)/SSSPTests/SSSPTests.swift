//
//  SSSPTests.swift
//  SSSPTests
//
//  Created by Andrew McKnight on 5/8/16.
//  Copyright © 2016 Andrew McKnight. All rights reserved.
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

    let result = BellmanFord<String>.apply(graph, source: s)

    let expectedPath = ["s", "y", "x", "t", "z"]
    let computedPath = result.path(z, inGraph: graph)!
    XCTAssertEqual(expectedPath, computedPath, "expected path of \(expectedPath) but got \(computedPath)")

    let expectedWeight = -2.0
    let computedWeight = result.distance(z)
    XCTAssertEqual(expectedWeight, computedWeight, "expected weight of \(expectedWeight) but got \(computedWeight)")
  }

}
