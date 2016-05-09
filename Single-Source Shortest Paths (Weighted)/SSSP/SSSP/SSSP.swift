//
//  SSSP.swift
//  SSSP
//
//  Created by Andrew McKnight on 5/8/16.
//  Copyright © 2016 Andrew McKnight. All rights reserved.
//

import Foundation

/**
 APSPAlgorithm is a protocol for encapsulating an All-Pairs Shortest Paths algorithm. It provides a single function `apply` that accepts a `Graph` and returns an object conforming to `APSPResult`.
 */
protocol SSSPAlgorithm {

  associatedtype Q

  static func apply(graph: Graph<Q>) -> SSSPResult<Q>

}

/**
 APSPResult is a protocol defining functions `distance` and `path`, allowing for opaque queries into the actual data structures that represent the APSP solution according to the algorithm used.
 */
struct SSSPResult<T> {
  var weight: Double
  var path: [T]
}
