//
//  Multiset.swift
//  Multiset
//
//  Created by Simon Whitaker on 28/08/2017.
//

import Foundation

public struct Multiset<Element: Hashable> {
  private var storage: [Element: UInt] = [:]
  public private(set) var count: UInt = 0

  public init() {}

  public mutating func add (_ elem: Element) {
    storage[elem, default: 0] += 1
    count += 1
  }

  public mutating func remove (_ elem: Element) {
    if let currentCount = storage[elem] {
      if currentCount > 1 {
        storage[elem] = currentCount - 1
      } else {
        storage.removeValue(forKey: elem)
      }
      count -= 1
    }
  }

  public func isSubSet (of superset: Multiset<Element>) -> Bool {
    for (key, count) in storage {
      let supersetcount = superset.storage[key] ?? 0
      if count > supersetcount {
        return false
      }
    }
    return true
  }

  public func count(for key: Element) -> UInt {
    return storage[key] ?? 0
  }

  public var allItems: [Element] {
    var result = [Element]()
    for (key, count) in storage {
      for _ in 0 ..< count {
        result.append(key)
      }
    }
    return result
  }
}

// MARK: - Equatable
extension Multiset: Equatable {
  public static func == (lhs: Multiset<Element>, rhs: Multiset<Element>) -> Bool {
    if lhs.storage.count != rhs.storage.count {
      return false
    }
    for (lkey, lcount) in lhs.storage {
      let rcount = rhs.storage[lkey] ?? 0
      if lcount != rcount {
        return false
      }
    }
    return true
  }
}
