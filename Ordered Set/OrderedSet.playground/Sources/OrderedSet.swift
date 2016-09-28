/*
  An Ordered Set is a collection where all items in the set follow an ordering,
  usually ordered from 'least' to 'most'. The way you value and compare items
  can be user-defined.
*/
public struct OrderedSet<T: Comparable> {
  private var internalSet = [T]()

  public init() { }

  // Returns the number of elements in the OrderedSet.
  public var count: Int {
    return internalSet.count
  }

  // Inserts an item. Performance: O(n)
  public mutating func insert(_ item: T) {
    if exists(item) {
      return  // don't add an item if it already exists
    }

    // Insert new the item just before the one that is larger.
    for i in 0..<count {
      if internalSet[i] > item {
        internalSet.insert(item, at: i)
        return
      }
    }

    // Append to the back if the new item is greater than any other in the set.
    internalSet.append(item)
  }

  // Removes an item if it exists. Performance: O(n)
  public mutating func remove(_ item: T) {
    if let index = index(of: item) {
      internalSet.remove(at: index)
    }
  }

  // Returns true if and only if the item exists somewhere in the set.
  public func exists(_ item: T) -> Bool {
    return index(of: item) != nil
  }

  // Returns the index of an item if it exists, or -1 otherwise.
  public func index(of item: T) -> Int? {
    var leftBound = 0
    var rightBound = count - 1

    while leftBound <= rightBound {
      let mid = leftBound + ((rightBound - leftBound) / 2)

      if internalSet[mid] > item {
        rightBound = mid - 1
      } else if internalSet[mid] < item {
        leftBound = mid + 1
      } else if internalSet[mid] == item {
        return mid
      } else {
        // When we get here, we've landed on an item whose value is equal to the
        // value of the item we're looking for, but the items themselves are not
        // equal. We need to check the items with the same value to the right
        // and to the left in order to find an exact match.

        // Check to the right.
        for j in stride(from: mid, to: count - 1, by: 1) {
          if internalSet[j + 1] == item {
            return j + 1
          } else if internalSet[j] < internalSet[j + 1] {
            break
          }
        }

        // Check to the left.
        for j in stride(from: mid, to: 0, by: -1) {
          if internalSet[j - 1] == item {
            return j - 1
          } else if internalSet[j] > internalSet[j - 1] {
            break
          }
        }
        return nil
      }
    }
    return nil
  }

  // Returns the item at the given index.
  // Assertion fails if the index is out of the range of [0, count).
  public subscript(index: Int) -> T {
    assert(index >= 0 && index < count)
    return internalSet[index]
  }

  // Returns the 'maximum' or 'largest' value in the set.
  public func max() -> T? {
    return count == 0 ? nil : internalSet[count - 1]
  }

  // Returns the 'minimum' or 'smallest' value in the set.
  public func min() -> T? {
    return count == 0 ? nil : internalSet[0]
  }

  // Returns the k-th largest element in the set, if k is in the range
  // [1, count]. Returns nil otherwise.
  public func kLargest(_ k: Int) -> T? {
    return k > count || k <= 0 ? nil : internalSet[count - k]
  }

  // Returns the k-th smallest element in the set, if k is in the range
  // [1, count]. Returns nil otherwise.
  public func kSmallest(_ k: Int) -> T? {
    return k > count || k <= 0 ? nil : internalSet[k - 1]
  }
}
