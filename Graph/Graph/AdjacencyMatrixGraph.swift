//
//  AdjacencyMatrixGraph.swift
//  Graph
//
//  Created by Andrew McKnight on 5/13/16.
//

import Foundation

public class AdjacencyMatrixGraph<T where T: Equatable, T: Hashable>: AbstractGraph<T> {

  // If adjacencyMatrix[i][j] is not nil, then there is an edge from
  // vertex i to vertex j.
  private var adjacencyMatrix: [[Double?]] = []
  private var _vertices: [Vertex<T>] = []

  public required init() {
    super.init()
  }

  public required init(fromGraph graph: AbstractGraph<T>) {
    super.init(fromGraph: graph)
  }

  public override var vertices: [Vertex<T>] {
    get {
      return _vertices
    }
  }

  public override var edges: [Edge<T>] {
    get {
      var edges = [Edge<T>]()
      for row in 0 ..< adjacencyMatrix.count {
        for column in 0 ..< adjacencyMatrix.count {
          if let weight = adjacencyMatrix[row][column] {
            edges.append(Edge(from: vertices[row], to: vertices[column], weight: weight))
          }
        }
      }
      return edges
    }
  }

  // Adds a new vertex to the matrix.
  // Performance: possibly O(n^2) because of the resizing of the matrix.
  public override func createVertex(data: T) -> Vertex<T> {
    // check if the vertex already exists
    let matchingVertices = vertices.filter() { vertex in
      return vertex.data == data
    }

    if matchingVertices.count > 0 {
      return matchingVertices.last!
    }

    // if the vertex doesn't exist, create a new one
    let vertex = Vertex(data: data, index: adjacencyMatrix.count)

    // Expand each existing row to the right one column.
    for i in 0 ..< adjacencyMatrix.count {
      adjacencyMatrix[i].append(nil)
    }

    // Add one new row at the bottom.
    let newRow = [Double?](count: adjacencyMatrix.count + 1, repeatedValue: nil)
    adjacencyMatrix.append(newRow)

    _vertices.append(vertex)

    return vertex
  }

  public override func addDirectedEdge(from: Vertex<T>, to: Vertex<T>, withWeight weight: Double?) {
    adjacencyMatrix[from.index][to.index] = weight
  }

  public override func addUndirectedEdge(vertices: (Vertex<T>, Vertex<T>), withWeight weight: Double?) {
    addDirectedEdge(vertices.0, to: vertices.1, withWeight: weight)
    addDirectedEdge(vertices.1, to: vertices.0, withWeight: weight)
  }

  public override func weightFrom(sourceVertex: Vertex<T>, to destinationVertex: Vertex<T>) -> Double? {
    return adjacencyMatrix[sourceVertex.index][destinationVertex.index]
  }

  public override func edgesFrom(sourceVertex: Vertex<T>) -> [Edge<T>] {
    var outEdges = [Edge<T>]()
    let fromIndex = sourceVertex.index
    for column in 0..<adjacencyMatrix.count {
      if let weight = adjacencyMatrix[fromIndex][column] {
        outEdges.append(Edge(from: sourceVertex, to: vertices[column], weight: weight))
      }
    }
    return outEdges
  }

  public override var description: String {
    get {
      var grid = [String]()
      let n = self.adjacencyMatrix.count
      for i in 0..<n {
        var row = ""
        for j in 0..<n {
          if let value = self.adjacencyMatrix[i][j] {
            let number = NSString(format: "%.1f", value)
            row += "\(value >= 0 ? " " : "")\(number) "
          } else {
            row += "  ø  "
          }
        }
        grid.append(row)
      }
      return (grid as NSArray).componentsJoinedByString("\n")
    }
  }

}
