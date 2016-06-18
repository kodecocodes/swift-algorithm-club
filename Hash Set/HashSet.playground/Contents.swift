//: Playground - noun: a place where people can play

public struct HashSet<T: Hashable> {
  private var dictionary = Dictionary<T, Bool>()

  public mutating func insert(element: T) {
    dictionary[element] = true
  }

  public mutating func remove(element: T) {
    dictionary[element] = nil
  }

  public func contains(element: T) -> Bool {
    return dictionary[element] != nil
  }

  public func allElements() -> [T] {
    return Array(dictionary.keys)
  }

  public var count: Int {
    return dictionary.count
  }

  public var isEmpty: Bool {
    return dictionary.isEmpty
  }
}

var set = HashSet<String>()

set.insert("one")
set.insert("two")
set.insert("three")
set.allElements()

set.insert("two")
set.allElements()

set.contains("one")
set.remove("one")
set.allElements()
set.contains("one")



/* Union */

extension HashSet {
  public func union(otherSet: HashSet<T>) -> HashSet<T> {
    var combined = HashSet<T>()
    for obj in dictionary.keys {
      combined.insert(obj)
    }
    for obj in otherSet.dictionary.keys {
      combined.insert(obj)
    }
    return combined
  }
}


var setA = HashSet<Int>()
setA.insert(1)
setA.insert(2)
setA.insert(3)
setA.insert(4)

var setB = HashSet<Int>()
setB.insert(3)
setB.insert(4)
setB.insert(5)
setB.insert(6)

let union = setA.union(setB)
union.allElements()          // [5, 6, 2, 3, 1, 4]



/* Intersection */

extension HashSet {
  public func intersect(otherSet: HashSet<T>) -> HashSet<T> {
    var common = HashSet<T>()
    for obj in dictionary.keys {
      if otherSet.contains(obj) {
        common.insert(obj)
      }
    }
    return common
  }
}

let intersection = setA.intersect(setB)
intersection.allElements()               // [3, 4]



/* Difference */

extension HashSet {
  public func difference(otherSet: HashSet<T>) -> HashSet<T> {
    var diff = HashSet<T>()
    for obj in dictionary.keys {
      if !otherSet.contains(obj) {
        diff.insert(obj)
      }
    }
    return diff
  }
}

let difference1 = setA.difference(setB)
difference1.allElements()                // [2, 1]

let difference2 = setB.difference(setA)
difference2.allElements()                // [5, 6]
