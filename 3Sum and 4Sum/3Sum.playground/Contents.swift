extension Collection where Element: Equatable {
  
  /// Returns next index with unique value. Works only on sorted arrays.
  ///
  /// - Parameter index: The current `Int` index.
  /// - Returns: The new index. Will return `nil` if new index happens to be the `endIndex` (out of bounds)
  func uniqueIndex(after index: Index) -> Index? {
    guard index < endIndex else { return nil }
    var index = index
    var nextIndex = self.index(after: index)
    while nextIndex < endIndex && self[index] == self[nextIndex] {
      formIndex(after: &index)
      formIndex(after: &nextIndex)
    }
    return nextIndex != endIndex ? nextIndex : nil
  }
}

extension BidirectionalCollection where Element: Equatable {
  
  /// Returns next index with unique value. Works only on sorted arrays.
  ///
  /// - Parameter index: The current index.
  /// - Returns: The new index. Will return `nil` if new index happens to come before the `startIndex` (out of bounds)
  func uniqueIndex(before index: Index) -> Index? {
    return indices[..<index].reversed().first { index -> Bool in
      let nextIndex = self.index(after: index)
      guard nextIndex >= startIndex && self[index] != self[nextIndex] else { return false }
      return true
    }
  }
}

func threeSum<T: BidirectionalCollection>(_ collection: T, target: T.Element) -> [[T.Element]] where T.Element: Numeric & Comparable {
  let sorted = collection.sorted()
  var ret: [[T.Element]] = []
  
  ThreeSum: for l in sequence(first: sorted.startIndex, next: sorted.uniqueIndex(after:)) {
    var m = sorted.index(after: l)
    var r = sorted.index(before: sorted.endIndex)

    TwoSum: while m < r {
      let sum = sorted[l] + sorted[m] + sorted[r]
      switch target {
      case sum:
        ret.append([sorted[l], sorted[m], sorted[r]])
        guard let nextMid = sorted.uniqueIndex(after: m), let nextRight = sorted.uniqueIndex(before: r) else { break TwoSum }
        m = nextMid
        r = nextRight
      case ..<target:
        guard let nextMid = sorted.uniqueIndex(after: m) else { break TwoSum }
        m = nextMid
      case target...:
        guard let nextRight = sorted.uniqueIndex(before: r) else { break TwoSum }
        r = nextRight
      default: fatalError("Swift isn't smart enough to detect that this switch statement is exhausive")
      }
    }
  }
  
  return ret
}

// Answer: [[-1, 0, 1], [-1, -1, 2]]
threeSum([-1, 0, 1, 2, -1, -4], target: 0)

// Answer: [[-1, -1, 2], [-1, 0, 1]]
threeSum([-1, -1, -1, -1, 2, 1, -4, 0], target: 0)

// Answer: [[-1, -1, 2]]
threeSum([-1, -1, -1, -1, -1, -1, 2], target: 0)
