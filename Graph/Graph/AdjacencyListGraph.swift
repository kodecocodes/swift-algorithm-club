//
//  AdjacencyListGraph.swift
//  Graph
//
//  Created by Andrew McKnight on 5/13/16.
//

import Foundation

private class EdgeList<T where T: Equatable, T: Hashable> {

  var vertex: Vertex<T>
  var edges: [Edge<T>]? = nil

  init(vertex: Vertex<T>) {
    self.vertex = vertex
  }

  func addEdge(edge: Edge<T>) {
    edges?.append(edge)
  }

}

public class AdjacencyListGraph<T where T: Equatable, T: Hashable>: AbstractGraph<T> {

  private var adjacencyList: [EdgeList<T>] = []

  public required init() {
    super.init()
  }

  public required init(fromGraph graph: AbstractGraph<T>) {
    super.init(fromGraph: graph)
  }

  public override var vertices: [Vertex<T>] {
    get {
      var vertices = [Vertex<T>]()
      for edgeList in adjacencyList {
        vertices.append(edgeList.vertex)
      }
      return vertices
    }
  }

  public override var edges: [Edge<T>] {
    get {
      var allEdges = Set<Edge<T>>()
      for edgeList in adjacencyList {
        guard let edges = edgeList.edges else {
          continue
        }

        for edge in edges {
          allEdges.insert(edge)
        }
      }
      return Array(allEdges)
    }
  }

  public override func createVertex(data: T) -> Vertex<T> {
    // check if the vertex already exists
    let matchingVertices = vertices.filter() { vertex in
      return vertex.data == data
    }

    if matchingVertices.count > 0 {
      return matchingVertices.last!
    }

    // if the vertex doesn't exist, create a new one
    let vertex = Vertex(data: data, index: adjacencyList.count)
    adjacencyList.append(EdgeList(vertex: vertex))
    return vertex
  }

  public override func addDirectedEdge(from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
    // works
    let edge = Edge(from: from, to: to, weight: weight)
    let edgeList = adjacencyList[from.index]
    if edgeList.edges?.count > 0 {
      edgeList.addEdge(edge)
    } else {
      edgeList.edges = [edge]
    }
  }

  public override func addUndirectedEdge(vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
    addDirectedEdge(vertices.0, to: vertices.1, withWeight: weight)
    addDirectedEdge(vertices.1, to: vertices.0, withWeight: weight)
  }


  public override func weightFrom(sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
    guard let edges = adjacencyList[sourceVertex.index].edges else {
      return nil
    }

    for edge: Edge<T> in edges {
      if edge.to == destinationVertex {
        return edge.weight
      }
    }

    return nil
  }

  public override func edgesFrom(sourceVertex: Vertex<T>) -> [Edge<T>] {
    return adjacencyList[sourceVertex.index].edges ?? []
  }

  public override var description: String {
    get {
      var rows = [String]()
      for edgeList in adjacencyList {

        guard let edges = edgeList.edges else {
          continue
        }

        var row = [String]()
        for edge in edges {
          var value = "\(edge.to.data)"
          if edge.weight != nil {
            value = "(\(value): \(edge.weight!))"
          }
          row.append(value)
        }

        rows.append("\(edgeList.vertex.data) -> [\(row.joinWithSeparator(", "))]")
      }

      return rows.joinWithSeparator("\n")
    }
  }
}
