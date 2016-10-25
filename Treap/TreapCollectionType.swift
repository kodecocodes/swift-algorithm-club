//
//  TreapCollectionType.swift
//  Treap
//
//  Created by Robert Thompson on 2/18/16.
//  Copyright © 2016 Robert Thompson
/* Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.*/

import Foundation

extension Treap: MutableCollection {
  
  public typealias Index = TreapIndex<Key>
  
  public subscript(index: TreapIndex<Key>) -> Element {
    get {
      guard let result = self.get(index.keys[index.keyIndex]) else {
        fatalError("Invalid index!")
      }
      
      return result
    }
    
    mutating set {
      let key = index.keys[index.keyIndex]
      self = self.set(key: key, val: newValue)
    }
  }
  
  public subscript(key: Key) -> Element? {
    get {
      return self.get(key)
    }
    
    mutating set {
      guard let value = newValue else {
        let _ = try? self.delete(key: key)
        return
      }
      
      self = self.set(key: key, val: value)
    }
  }
  
  public var startIndex: TreapIndex<Key> {
    return TreapIndex<Key>(keys: keys, keyIndex: 0)
  }
  
  public var endIndex: TreapIndex<Key> {
    let keys = self.keys
    return TreapIndex<Key>(keys: keys, keyIndex: keys.count)
  }
  
  public func index(after i: TreapIndex<Key>) -> TreapIndex<Key> {
    return i.successor()
  }
  
  fileprivate var keys: [Key] {
    var results: [Key] = []
    if case let .node(key, _, _, left, right) = self {
      results.append(contentsOf: left.keys)
      results.append(key)
      results.append(contentsOf: right.keys)
    }
    
    return results
  }
}

public struct TreapIndex<Key: Comparable>: Comparable {
  
  public static func <(lhs: TreapIndex<Key>, rhs: TreapIndex<Key>) -> Bool {
    return lhs.keyIndex < rhs.keyIndex
  }
  
  fileprivate let keys: [Key]
  fileprivate let keyIndex: Int
  
  public func successor() -> TreapIndex {
    return TreapIndex(keys: keys, keyIndex: keyIndex + 1)
  }
  
  public func predecessor() -> TreapIndex {
    return TreapIndex(keys: keys, keyIndex: keyIndex - 1)
  }
  
  fileprivate init(keys: [Key] = [], keyIndex: Int = 0) {
    self.keys = keys
    self.keyIndex = keyIndex
  }
}

public func ==<Key: Comparable>(lhs: TreapIndex<Key>, rhs: TreapIndex<Key>) -> Bool {
  return lhs.keys == rhs.keys && lhs.keyIndex == rhs.keyIndex
}
