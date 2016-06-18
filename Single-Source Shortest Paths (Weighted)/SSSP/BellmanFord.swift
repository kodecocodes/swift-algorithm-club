//
//  BellmanFord.swift
//  SSSP
//
//  Created by Andrew McKnight on 5/8/16.
//

import Foundation
import Graph

public struct BellmanFord<T where T: Hashable> {
  public typealias Q = T
}

/**
 Encapsulation of the Bellman-Ford Single-Source Shortest Paths algorithm,
 which operates on a general directed graph that may contain negative edge weights.

 - note: In all complexity bounds, `V` is the number of vertices in the graph, and `E` is the number of edges.
 */
extension BellmanFord: SSSPAlgorithm {

  /**
   Compute the shortest path from `source` to each other vertex in `graph`,
   if such paths exist. Also report negative weight cycles reachable from `source`,
   which are cycles whose sum of edge weights is negative.

   - precondition: `graph` must have no negative weight cycles
   - complexity: `O(VE)` time, `Θ(V)` space
   - returns a `BellmanFordResult` struct which can be queried for
   shortest paths and their total weights, or `nil` if a negative weight cycle exists
 */
  public static func apply(graph: AbstractGraph<T>, source: Vertex<Q>) -> BellmanFordResult<T>? {
    let vertices = graph.vertices
    let edges = graph.edges

    var predecessors = Array<Int?>(count: vertices.count, repeatedValue: nil)
    var weights = Array(count: vertices.count, repeatedValue: Double.infinity)
    predecessors[source.index] = source.index
    weights[source.index] = 0

    for _ in 0 ..< vertices.count - 1 {
      var weightsUpdated = false
      edges.forEach() { edge in
        let weight = edge.weight!
        let relaxedDistance = weights[edge.from.index] + weight
        let nextVertexIdx = edge.to.index
        if relaxedDistance < weights[nextVertexIdx] {
          predecessors[nextVertexIdx] = edge.from.index
          weights[nextVertexIdx] = relaxedDistance
          weightsUpdated = true
        }
      }
      if !weightsUpdated {
        break
      }
    }

    // check for negative weight cycles reachable from the source vertex
    // TO DO: modify to incorporate solution to 24.1-4, pg 654, to set the
    //       weight of a path containing a negative weight cycle to -∞,
    //       instead of returning nil for the entire result
    for edge in edges {
      if weights[edge.to.index] > weights[edge.from.index] + edge.weight! {
        return nil
      }
    }

    return BellmanFordResult(predecessors: predecessors, weights: weights)
  }

}

/**
 `BellmanFordResult` encapsulates the result of the computation,
 namely the minimized distances, and the predecessor indices.

 It conforms to the `SSSPResult` procotol which provides methods to
 retrieve distances and paths between given pairs of start and end nodes.
 */
public struct BellmanFordResult<T where T: Hashable> {

  private var predecessors: [Int?]
  private var weights: [Double]

}

extension BellmanFordResult: SSSPResult {

  /**
   - returns: the total weight of the path from the source vertex to a destination.
   This value is the minimal connected weight between the two vertices, or `nil` if no path exists
   - complexity: `Θ(1)` time/space
   */
  public func distance(to: Vertex<T>) -> Double? {
    let distance = weights[to.index]

    guard distance != Double.infinity else {
      return nil
    }

    return distance
  }

  /**
   - returns: the reconstructed path from the source vertex to a destination,
   as an array containing the data property of each vertex, or `nil` if no path exists
   - complexity: `Θ(V)` time, `Θ(V^2)` space
   */
  public func path(to: Vertex<T>, inGraph graph: AbstractGraph<T>) -> [T]? {
    guard weights[to.index] != Double.infinity else {
      return nil
    }

    guard let path = recursePath(to, inGraph: graph, path: [to]) else {
      return nil
    }

    return path.map() { vertex in
      return vertex.data
    }
  }

  /**
   The recursive component to rebuilding the shortest path between two vertices using predecessors.

   - returns: the list of predecessors discovered so far, or `nil` if the next vertex has no predecessor
   */
  private func recursePath(to: Vertex<T>, inGraph graph: AbstractGraph<T>, path: [Vertex<T>]) -> [Vertex<T>]? {
    guard let predecessorIdx = predecessors[to.index] else {
      return nil
    }

    let predecessor = graph.vertices[predecessorIdx]
    if predecessor.index == to.index {
      return [ to ]
    }

    guard let buildPath = recursePath(predecessor, inGraph: graph, path: path) else {
      return nil
    }

    return buildPath + [ to ]
  }

}
