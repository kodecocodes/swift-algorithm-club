//
//  Edge.swift
//  Graph
//
//  Created by Andrew McKnight on 5/8/16.
//

import Foundation

public struct Edge<T where T: Equatable, T: Hashable>: Equatable {

  public let from: Vertex<T>
  public let to: Vertex<T>

  public let weight: Double?

}

extension Edge: CustomStringConvertible {

  public var description: String {
    get {
      guard let unwrappedWeight = weight else {
        return "\(from.description) -> \(to.description)"
      }
      return "\(from.description) -(\(unwrappedWeight))-> \(to.description)"
    }
  }

}

extension Edge: Hashable {

  public var hashValue: Int {
    get {
      var string = "\(from.description)\(to.description)"
      if weight != nil {
        string.appendContentsOf("\(weight!)")
      }
      return string.hashValue
    }
  }

}

public func == <T>(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
  guard lhs.from == rhs.from else {
    return false
  }

  guard lhs.to == rhs.to else {
    return false
  }

  guard lhs.weight == rhs.weight else {
    return false
  }

  return true
}
