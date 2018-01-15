//
//  EncodeAndDecodeTree.swift
//
//
//  Created by Kai Chen on 19/07/2017.
//
//

import Foundation

protocol BinaryNodeEncoder {
  func encode<T>(_ node: BinaryNode<T>?) throws -> String
}

protocol BinaryNodeDecoder {
  func decode<T>(from string: String) -> BinaryNode<T>?
}

public class BinaryNodeCoder<T: Comparable>: BinaryNodeEncoder, BinaryNodeDecoder {

  // MARK: Private

  private let separator: Character = ","
  private let nilNode = "X"

  private func decode<T>(from array: inout [String]) -> BinaryNode<T>? {
    guard !array.isEmpty else {
      return nil
    }

    let value = array.removeLast()

    guard value != nilNode, let val = value as? T else {
      return nil
    }

    let node = BinaryNode<T>(val)
    node.left = decode(from: &array)
    node.right = decode(from: &array)

    return node
  }

  // MARK: Public

  public init() {}

  public func encode<T>(_ node: BinaryNode<T>?) throws -> String {
    var str = ""
    node?.preOrderTraversal { data in
      if let data = data {
        let string = String(describing: data)
        str.append(string)
      } else {
        str.append(nilNode)
      }
      str.append(separator)
    }

    return str
  }

  public func decode<T>(from string: String) -> BinaryNode<T>? {
    var components = string.split(separator: separator).reversed().map(String.init)
    return decode(from: &components)
  }
}

public class BinaryNode<Element: Comparable> {
  public var val: Element
  public var left: BinaryNode?
  public var right: BinaryNode?

  public init(_ val: Element, left: BinaryNode? = nil, right: BinaryNode? = nil) {
    self.val = val
    self.left = left
    self.right = right
  }

  public func preOrderTraversal(visit: (Element?) throws -> ()) rethrows {
    try visit(val)

    if let left = left {
      try left.preOrderTraversal(visit: visit)
    } else {
      try visit(nil)
    }

    if let right = right {
      try right.preOrderTraversal(visit: visit)
    } else {
      try visit(nil)
    }
  }
}
