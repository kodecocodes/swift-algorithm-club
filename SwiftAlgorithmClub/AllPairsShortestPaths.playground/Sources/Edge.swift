//
//  Edge.swift
//  Graph
//
//  Created by Andrew McKnight on 5/8/16.
//

public struct Edge<T: Hashable> {
  public let from: Vertex<T>
  public let to: Vertex<T>
  public let weight: Double?
}

extension Edge: CustomStringConvertible {
  public var description: String {
    guard let unwrappedWeight = weight else {
      return "\(from.description) -> \(to.description)"
    }
    return "\(from.description) -(\(unwrappedWeight))-> \(to.description)"
  }
}

extension Edge: Hashable {}
extension Edge: Equatable {}
