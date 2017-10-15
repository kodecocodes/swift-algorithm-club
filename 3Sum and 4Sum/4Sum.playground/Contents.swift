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

func fourSum<T: BidirectionalCollection>(_ collection: T, target: T.Element) -> [[T.Element]] where T.Element: Numeric & Comparable {
  let sorted = collection.sorted()
  var ret: [[T.Element]] = []
  
  var l = sorted.startIndex
  FourSum: while l < sorted.endIndex { defer { sorted.formUniqueIndex(after: &l) }
    var ml = sorted.index(after: l)
                                      
    ThreeSum: while ml < sorted.endIndex { defer { sorted.formUniqueIndex(after: &ml) }
      var mr = sorted.index(after: ml)
      var r = sorted.index(before: sorted.endIndex)
      
      TwoSum: while mr < r && r < sorted.endIndex {
        let sum = sorted[l] + sorted[ml] + sorted[mr] + sorted[r]
        if sum == target {
          ret.append([sorted[l], sorted[ml], sorted[mr], sorted[r]])
          sorted.formUniqueIndex(after: &mr)
          sorted.formUniqueIndex(before: &r)
        } else if sum < target {
          sorted.formUniqueIndex(after: &mr)
        } else {
          sorted.formUniqueIndex(before: &r)
        }
      }
    }
  }
  return ret
}

// answer: [[-2, -1, 1, 2], [-2, 0, 0, 2], [-1, 0, 0, 1]]
fourSum([1, 0, -1, 0, -2, 2], target: 0)
