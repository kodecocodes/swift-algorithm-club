/*
  Union-Find Data Structure

  Performance:
    adding new set is almost O(1)
    finding set of element is almost O(1)
    union sets is almost O(1)
*/

public struct UnionFind<T: Hashable> {
  private var index = [T: Int]()
  private var parent = [Int]()
  private var size = [Int]()

  public mutating func addSetWith(_ element: T) {
    index[element] = parent.count
    parent.append(parent.count)
    size.append(1)
  }

  private mutating func setByIndex(_ index: Int) -> Int {
    if parent[index] == index {
      return index
    } else {
      parent[index] = setByIndex(parent[index])
      return parent[index]
    }
  }

  public mutating func setOf(_ element: T) -> Int? {
    if let indexOfElement = index[element] {
      return setByIndex(indexOfElement)
    } else {
      return nil
    }
  }

  public mutating func unionSetsContaining(_ firstElement: T, and secondElement: T) {
    if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
      if firstSet != secondSet {
        if size[firstSet] < size[secondSet] {
          parent[firstSet] = secondSet
          size[secondSet] += size[firstSet]
        } else {
          parent[secondSet] = firstSet
          size[firstSet] += size[secondSet]
        }
      }
    }
  }

  public mutating func inSameSet(_ firstElement: T, and secondElement: T) -> Bool {
    if let firstSet = setOf(firstElement), let secondSet = setOf(secondElement) {
      return firstSet == secondSet
    } else {
      return false
    }
  }
}
