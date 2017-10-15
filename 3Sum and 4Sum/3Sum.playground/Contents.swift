
extension Collection where Element: Equatable {
  
  /// In a sorted collection, replaces the given index with a successor mapping to a unique element.
  ///
  /// - Parameter index: A valid index of the collection. `index` must be less than `endIndex`
  func formUniqueIndex(after index: inout Index) {
    var prev = index
    repeat {
      prev = index
      formIndex(after: &index)
    } while index < endIndex && self[prev] == self[index]
  }
}

extension BidirectionalCollection where Element: Equatable {
  
  /// In a sorted collection, replaces the given index with a predecessor that maps to a unique element.
  ///
  /// - Parameter index: A valid index of the collection. `index` must be greater than `startIndex`.
  func formUniqueIndex(before index: inout Index) {
    var prev = index
    repeat {
      prev = index
      formIndex(before: &index)
    } while index > startIndex && self[prev] == self[index]
  }
}

func threeSum<T: BidirectionalCollection>(_ collection: T, target: T.Element) -> [[T.Element]] where T.Element: Numeric & Comparable {
  let sorted = collection.sorted()
  var ret: [[T.Element]] = []
  var l = sorted.startIndex
  
  while l < sorted.endIndex {
    var m = sorted.index(after: l)
    var r = sorted.index(before: sorted.endIndex)
    
    while m < r && r < sorted.endIndex {
      let sum = sorted[l] + sorted[m] + sorted[r]
      switch target {
      case sum:
        ret.append([sorted[l], sorted[m], sorted[r]])
        sorted.formUniqueIndex(after: &m)
        sorted.formUniqueIndex(before: &r)
      case ..<target:
        sorted.formUniqueIndex(after: &m)
      case target...:
        sorted.formUniqueIndex(before: &r)
      default: fatalError("Swift isn't smart enough to detect that this switch statement is exhausive")
      }
    }
    sorted.formUniqueIndex(after: &l)
  }
  
  return ret
}

// Answer: [[-1, 0, 1], [-1, -1, 2]]
threeSum([-1, 0, 1, 2, -1, -4], target: 0)

// Answer: [[-1, -1, 2], [-1, 0, 1]]
threeSum([-1, -1, -1, -1, 2, 1, -4, 0], target: 0)

// Answer: [[-1, -1, 2]]
threeSum([-1, -1, -1, -1, -1, -1, 2], target: 0)
