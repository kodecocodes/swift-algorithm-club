/**
 Binary Search
 
 Recursively splits the collection in half until the value is found.
 
 If there is more than one occurrence of the search key in the collection, then
 there is no guarantee which one it finds.
 
 Note: The collection must be sorted!
 **/

// The recursive version of binary search.

extension Collection where Element: Comparable, SubSequence: Collection {
  /// Recursively searches the collection for the given key using a binary
  /// search algorithm.
  ///
  /// If the collection is not sorted, the behavior is undefined.
  ///
  /// - Parameter key: The search key.
  /// - Returns: The index of the search key or `nil` if the key does not exist
  /// in the collection.
  ///
  /// - Complexity: O(log *n*), where *n* is the number of elements in the
  ///   collection.
  public func binarySearchRecursive(key: Element) -> Index? {
    guard !isEmpty else { return nil }
    let midIndex = index(startIndex, offsetBy: distance(from: startIndex, to: endIndex) / 2)
    if self[midIndex] > key {
      return self[..<midIndex].binarySearchRecursive(key: key)
    } else if self[midIndex] < key {
      return self[index(after: midIndex)...].binarySearchRecursive(key: key)
    } else {
      return midIndex
    }
  }
}

/**
 The iterative version of binary search.
 
 Notice how similar these functions are. The difference is that this one
 uses a while loop, while the other calls itself recursively.
 **/

extension Collection where Element: Comparable {
  /// Iteratively searches the collection for the given key using a binary
  /// search algorithm.
  ///
  /// If the collection is not sorted, the behavior is undefined.
  ///
  /// - Parameter key: The search key.
  /// - Returns: The index of the search key or `nil` if the key does not exist
  /// in the collection.
  ///
  /// - Complexity: O(log *n*), where *n* is the number of elements in the
  ///   collection.
  public func binarySearchIterative(key: Element) -> Index? {
    var lowerBound = startIndex
    var upperBound = endIndex
    while lowerBound < upperBound {
      let midIndex = index(lowerBound, offsetBy: distance(from: lowerBound, to: upperBound) / 2)
      if self[midIndex] > key {
        upperBound = midIndex
      } else if self[midIndex] < key {
        lowerBound = index(after: midIndex)
      } else {
        return midIndex
      }
    }
    return nil
  }
}
