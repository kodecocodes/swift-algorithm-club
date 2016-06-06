//
//  Vertex.swift
//  Graph
//
//  Created by Andrew McKnight on 5/8/16.
//

import Foundation

public struct Vertex<T where T: Equatable, T: Hashable>: Equatable {

  public var data: T
  public let index: Int

}

extension Vertex: CustomStringConvertible {

  public var description: String {
    get {
      return "\(index): \(data)"
    }
  }

}

extension Vertex: Hashable {

  public var hashValue: Int {
    get {
      return "\(data)\(index)".hashValue
    }
  }

}

public func ==<T: Equatable>(lhs: Vertex<T>, rhs: Vertex<T>) -> Bool {
  guard lhs.index == rhs.index else {
    return false
  }

  guard lhs.data == rhs.data else {
    return false
  }

  return true
}
