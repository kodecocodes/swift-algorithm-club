//
//  Edge.swift
//  Graph
//
//  Created by Andrew McKnight on 5/8/16.
//  Copyright © 2016 Andrew McKnight. All rights reserved.
//

import Foundation

public enum EdgeType {
  case Directed
  case Undirected
}

public struct Edge<T> {
  
  public let from: Vertex<T>
  public let to: Vertex<T>

  public let type: EdgeType

}

public struct WeightedEdge<T> {

  public let edge: Edge<T>
  public let weight: Double?

}
