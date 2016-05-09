//
//  Vertex.swift
//  Graph
//
//  Created by Andrew McKnight on 5/8/16.
//  Copyright © 2016 Andrew McKnight. All rights reserved.
//

import Foundation

public struct Vertex<T> {

  public var data: T
  public let index: Int

  private(set) public var edges: [Edge<T>] = []   // the adjacency list

  public init(data: T, index: Int) {
    self.data = data
    self.index = index
  }

}

extension Vertex {

  // Creates the directed edge: self -----> dest
  public mutating func createDirectedEdgeTo(destinationVertex: Vertex<T>, withWeight weight: Double? = nil) {

    edges.append(Edge(from: self, to: destinationVertex, weight: weight))

  }

  // Creates an undirected edge by making two directed edges: self ----> other, and other ----> self
  public mutating func createUndirectedEdgeWith(inout otherVertex: Vertex<T>, withWeight weight: Double? = nil) {

    createDirectedEdgeTo(otherVertex, withWeight: weight)
    otherVertex.createDirectedEdgeTo(self, withWeight: weight)

  }

  // Does this vertex have an edge -----> otherVertex?
  public func edgeTo(otherVertex: Vertex<T>) -> Edge<T>? {

    for e in edges where e.to.index == otherVertex.index {
      return e
    }
    return nil
  }
  
}
