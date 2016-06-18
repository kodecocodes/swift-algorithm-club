//
//  Base.swift
//  APSP
//
//  Created by Andrew McKnight on 5/6/16.
//

import Foundation
import Graph

/**
 `APSPAlgorithm` is a protocol for encapsulating an All-Pairs Shortest Paths algorithm.
 It provides a single function `apply` that accepts a subclass of `AbstractGraph` and
 returns an object conforming to `APSPResult`.
 */
public protocol APSPAlgorithm {

  associatedtype Q: Hashable
  associatedtype P: APSPResult

  static func apply(graph: AbstractGraph<Q>) -> P

}

/**
 `APSPResult` is a protocol defining functions `distance` and `path`, allowing for opaque
 queries into the actual data structures that represent the APSP solution according to the algorithm used.
 */
public protocol APSPResult {

  associatedtype T: Hashable

  func distance(fromVertex from: Vertex<T>, toVertex to: Vertex<T>) -> Double?
  func path(fromVertex from: Vertex<T>, toVertex to: Vertex<T>, inGraph graph: AbstractGraph<T>) -> [T]?

}
