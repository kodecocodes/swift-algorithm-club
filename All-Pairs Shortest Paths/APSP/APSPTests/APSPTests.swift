//
//  APSPTests.swift
//  APSPTests
//
//  Created by Andrew McKnight on 5/6/16.
//  Copyright © 2016 Andrew McKnight. All rights reserved.
//

import APSP
import XCTest

struct TestCase<T> {

  var from: Vertex<T>
  var to: Vertex<T>
  var expectedPath: [T]
  var expectedDistance: Double

}

class APSPTests: XCTestCase {

  func testExampleFromBook() {

    var graph = Graph<String>()
    let v1 = graph.createVertex("Montreal")
    let v2 = graph.createVertex("New York")
    let v3 = graph.createVertex("Boston")
    let v4 = graph.createVertex("Portland")
    let v5 = graph.createVertex("Portsmouth")

    graph.connect(v1, to: v2, withWeight: 3)
    graph.connect(v1, to: v5, withWeight: -4)
    graph.connect(v1, to: v3, withWeight: 8)

    graph.connect(v2, to: v4, withWeight: 1)
    graph.connect(v2, to: v5, withWeight: 7)

    graph.connect(v3, to: v2, withWeight: 4)

    graph.connect(v4, to: v1, withWeight: 2)
    graph.connect(v4, to: v3, withWeight: -5)

    graph.connect(v5, to: v4, withWeight: 6)

    let result = FloydWarshall<String>.apply(graph)

    let cases = [
      TestCase<String>(from: v1, to: v4, expectedPath: ["Montreal", "Portsmouth", "Portland"], expectedDistance: 2),
      TestCase<String>(from: v1, to: v5, expectedPath: ["Montreal", "Portsmouth"], expectedDistance: -4),
      TestCase<String>(from: v2, to: v1, expectedPath: ["New York", "Portland", "Montreal"], expectedDistance: 3),
      TestCase<String>(from: v2, to: v3, expectedPath: ["New York", "Portland", "Boston"], expectedDistance: -4),
      TestCase<String>(from: v2, to: v4, expectedPath: ["New York", "Portland"], expectedDistance: 1),
      TestCase<String>(from: v2, to: v5, expectedPath: ["New York", "Portland", "Montreal", "Portsmouth"], expectedDistance: -1),
      TestCase<String>(from: v3, to: v1, expectedPath: ["Boston", "New York", "Portland", "Montreal"], expectedDistance: 7),
      TestCase<String>(from: v3, to: v2, expectedPath: ["Boston", "New York"], expectedDistance: 4),
      TestCase<String>(from: v3, to: v4, expectedPath: ["Boston", "New York", "Portland"], expectedDistance: 5),
      TestCase<String>(from: v3, to: v5, expectedPath: ["Boston", "New York", "Portland", "Montreal", "Portsmouth"], expectedDistance: 3),
      TestCase<String>(from: v4, to: v1, expectedPath: ["Portland", "Montreal"], expectedDistance: 2),
      TestCase<String>(from: v4, to: v2, expectedPath: ["Portland", "Boston", "New York"], expectedDistance: -1),
      TestCase<String>(from: v4, to: v3, expectedPath: ["Portland", "Boston"], expectedDistance: -5),
      TestCase<String>(from: v4, to: v5, expectedPath: ["Portland", "Montreal", "Portsmouth"], expectedDistance: -2),
      TestCase<String>(from: v5, to: v1, expectedPath: ["Portsmouth", "Portland", "Montreal"], expectedDistance: 8),
      TestCase<String>(from: v5, to: v2, expectedPath: ["Portsmouth", "Portland", "Boston", "New York"], expectedDistance: 5),
      TestCase<String>(from: v5, to: v3, expectedPath: ["Portsmouth", "Portland", "Boston"], expectedDistance: 1),
      TestCase<String>(from: v5, to: v4, expectedPath: ["Portsmouth", "Portland"], expectedDistance: 6),
      ]

    for testCase: TestCase<String> in cases {
      if let computedPath = result.path(fromVertex: testCase.from, toVertex: testCase.to, inGraph: graph),
              computedDistance = result.distance(fromVertex: testCase.from, toVertex: testCase.to) {
        XCTAssert(computedDistance == testCase.expectedDistance, "expected distance \(testCase.expectedDistance) but got \(computedDistance)")
        XCTAssert(computedPath == testCase.expectedPath, "expected path \(testCase.expectedPath) but got \(computedPath)")
      }
    }

  }

  func testExampleFromReadme() {

    var graph = Graph<Int>()
    let v1 = graph.createVertex(1)
    let v2 = graph.createVertex(2)
    let v3 = graph.createVertex(3)
    let v4 = graph.createVertex(4)

    graph.connect(v1, to: v2, withWeight: 4)
    graph.connect(v1, to: v3, withWeight: 1)
    graph.connect(v1, to: v4, withWeight: 3)

    graph.connect(v2, to: v3, withWeight: 8)
    graph.connect(v2, to: v4, withWeight: -2)

    graph.connect(v3, to: v4, withWeight: -5)

    let result = FloydWarshall<Int>.apply(graph)

    let cases = [
      TestCase<Int>(from: v1, to: v2, expectedPath: [1, 2], expectedDistance: 4),
      TestCase<Int>(from: v1, to: v3, expectedPath: [1, 3], expectedDistance: 1),
      TestCase<Int>(from: v1, to: v4, expectedPath: [1, 3, 4], expectedDistance: -4),

      TestCase<Int>(from: v2, to: v3, expectedPath: [2, 3], expectedDistance: 8),
      TestCase<Int>(from: v2, to: v4, expectedPath: [2, 4], expectedDistance: -2),

      TestCase<Int>(from: v3, to: v4, expectedPath: [3, 4], expectedDistance: -5),
    ]

    for testCase: TestCase<Int> in cases {
      if let computedPath = result.path(fromVertex: testCase.from, toVertex: testCase.to, inGraph: graph),
        computedDistance = result.distance(fromVertex: testCase.from, toVertex: testCase.to) {
        XCTAssert(computedDistance == testCase.expectedDistance, "expected distance \(testCase.expectedDistance) but got \(computedDistance)")
        XCTAssert(computedPath == testCase.expectedPath, "expected path \(testCase.expectedPath) but got \(computedPath)")
      }
    }

  }

}
