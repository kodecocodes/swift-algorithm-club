/*
  Union-Find Data Structure

  Performance:
    adding new set is almost O(1)
    finding set of element is almost O(1)
    union sets is almost O(1)
*/


public struct UnionFind<T: Hashable> {
  
  private var index = [T:Int]()
  private var parent = [Int]()
  private var size = [Int]()
  
  
  public mutating func addSetWithElement(element: T) {
    index[element] = parent.count
    parent.append(parent.count)
    size.append(1)
  }
  
  private mutating func findSetByIndexOfElement(index: Int) -> Int {
    if parent[index] == index {
      return index
    } else {
      parent[index] = findSetByIndexOfElement(parent[index])
      return parent[index]
    }
  }
  
  public mutating func findSetOfElement(element: T) -> Int? {
    if let indexOfElement = index[element] {
      return findSetByIndexOfElement(indexOfElement)
    } else {
      return nil
    }
  }
  
  public mutating func unionSetsWithElement(firstElement: T, andSecondElement secondElement: T) {
    if let firstSet = findSetOfElement(firstElement), secondSet = findSetOfElement(secondElement) {
      if (firstSet != secondSet) {
        if (size[firstSet] < size[secondSet]) {
          parent[firstSet] = secondSet;
          size[secondSet] += size[firstSet]
        } else {
          parent[secondSet] = firstSet;
          size[firstSet] += size[secondSet]
        }
      }
    }
  }
}