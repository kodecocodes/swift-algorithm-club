//
//  Graph.swift
//  Graph
//
//  Created by Andrew McKnight on 5/8/16.
//

import Foundation

public class AbstractGraph<T where T: Equatable, T: Hashable>: CustomStringConvertible {

  public required init() {}

  public required init(fromGraph graph: AbstractGraph<T>) {
    for edge in graph.edges {
      let from = createVertex(edge.from.data)
      let to = createVertex(edge.to.data)

      addDirectedEdge(from, to: to, withWeight: edge.weight)
    }
  }

  public var description: String {
    get {
      fatalError("abstract property accessed")
    }
  }

  public var vertices: [Vertex<T>] {
    get {
      fatalError("abstract property accessed")
    }
  }

  public var edges: [Edge<T>] {
    get {
      fatalError("abstract property accessed")
    }
  }

  // Adds a new vertex to the matrix.
  // Performance: possibly O(n^2) because of the resizing of the matrix.
  public func createVertex(data: T) -> Vertex<T> {
    fatalError("abstract function called")
  }

  public func addDirectedEdge(from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
    fatalError("abstract function called")
  }

  public func addUndirectedEdge(vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
    fatalError("abstract function called")
  }

  public func weightFrom(sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
    fatalError("abstract function called")
  }

  public func edgesFrom(sourceVertex: Vertex<T>) -> [Edge<T>] {
    fatalError("abstract function called")
  }
}
