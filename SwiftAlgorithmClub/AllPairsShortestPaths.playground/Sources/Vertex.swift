//
//  Vertex.swift
//  Graph
//
//  Created by Andrew McKnight on 5/8/16.
//

public struct Vertex<T: Hashable> {
  public var data: T
  public let index: Int
}

extension Vertex: CustomStringConvertible {
  public var description: String {
    "\(index): \(data)"
  }
}

extension Vertex: Hashable {}
extension Vertex: Equatable {}
