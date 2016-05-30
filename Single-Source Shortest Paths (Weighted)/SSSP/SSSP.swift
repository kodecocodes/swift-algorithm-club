//
//  SSSP.swift
//  SSSP
//
//  Created by Andrew McKnight on 5/8/16.
//  Copyright © 2016 Andrew McKnight. All rights reserved.
//

import Foundation
import Graph

/**

 */
protocol SSSPAlgorithm {

  associatedtype Q: Equatable, Hashable
  associatedtype P: SSSPResult

  static func apply(graph: AbstractGraph<Q>, source: Vertex<Q>) -> P

}

/**

 */
protocol SSSPResult {

  associatedtype T: Equatable, Hashable

  func distance(to: Vertex<T>) -> Double?
  func path(to: Vertex<T>, inGraph graph: AbstractGraph<T>) -> [T]?
}
