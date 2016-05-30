//
//  BellmanFord.swift
//  SSSP
//
//  Created by Andrew McKnight on 5/8/16.
//  Copyright © 2016 Andrew McKnight. All rights reserved.
//

import Foundation
import Graph

public struct BellmanFord<T where T: Hashable> {
  typealias Q = T
}

extension BellmanFord: SSSPAlgorithm {

  static func apply(graph: AbstractGraph<T>, source: Vertex<Q>) -> BellmanFordResult<T> {
    let vertices = graph.vertices
    let edges = graph.edges

    var predecessors = Array(count: vertices.count, repeatedValue: source.index)
    var weights = Array(count: vertices.count, repeatedValue: Double.infinity)
    weights[0] = 0.0

    vertices.forEach() { _ in
      edges.forEach() { edge in
        let weight = edge.weight!
        let relaxedDistance = weights[edge.from.index] + weight
        let nextVertexIdx = edge.to.index
        if relaxedDistance < weights[nextVertexIdx] {
          predecessors[nextVertexIdx] = edge.from.index
          weights[nextVertexIdx] = relaxedDistance
        }
      }
    }

    return BellmanFordResult(predecessors: predecessors, weights: weights)
  }

}

public struct BellmanFordResult<T where T: Hashable>: SSSPResult {

  private var predecessors: [Int]
  private var weights: [Double]

  func distance(to: Vertex<T>) -> Double? {
    let distance = weights[to.index]

    guard distance != Double.infinity else {
      return nil
    }

    return distance
  }

  func path(to: Vertex<T>, inGraph graph: AbstractGraph<T>) -> [T]? {

    guard weights[to.index] != Double.infinity else {
      return nil
    }

    let path = recursePath(to, inGraph: graph, path: [to])
    return path.map() { vertex in
      return vertex.data
    }
  }

  private func recursePath(to: Vertex<T>, inGraph graph: AbstractGraph<T>, path: [Vertex<T>]) -> [Vertex<T>] {
    let predecessor = graph.vertices[predecessors[to.index]]
    if predecessor.index == to.index {
      return [ to ]
    }

    let buildPath = recursePath(predecessor, inGraph: graph, path: path)
    return buildPath + [ to ]
  }

}
