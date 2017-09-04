//
//  Multiset.swift
//  Multiset
//
//  Created by Simon Whitaker on 28/08/2017.
//

import Foundation

public struct Multiset<T: Hashable> {
  fileprivate var storage: Dictionary<T, Int>
  private var _count: Int = 0

  public init() {
    storage = Dictionary<T, Int>()
  }

  public mutating func add (_ elem: T) {
    if let currentCount = self.storage[elem] {
      self.storage[elem] = currentCount + 1;
    } else {
      self.storage[elem] = 1
    }
    _count += 1
  }

  public mutating func remove (_ elem: T) {
    if let currentCount = self.storage[elem] {
      if currentCount > 1 {
        self.storage[elem] = currentCount - 1
      } else {
        self.storage.removeValue(forKey: elem)
      }
      _count -= 1
    }
  }

  public func isSubSet (of superset: Multiset<T>) -> Bool {
    for (key, count) in self.storage {
      let supersetcount = superset.storage[key] ?? 0
      if count > supersetcount {
        return false
      }
    }
    return true
  }

  public var count: Int {
    get {
      return _count
    }
  }

  public func count(for key: T) -> Int {
    return self.storage[key] ?? 0
  }

  public var allItems: [T] {
    get {
      var result = Array<T>()
      for (key, count) in self.storage {
        for _ in 0 ..< count {
          result.append(key)
        }
      }
      return result
    }
  }
}

extension Multiset: Equatable {
  public static func == (lhs: Multiset<T>, rhs: Multiset<T>) -> Bool {
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
