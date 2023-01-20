// last checked with Xcode 10.1
#if swift(>=4.2)
print("Hello, Swift 4.2!")
#endif



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
    FourSum: while l < sorted.endIndex {
        // Skip over any repeated elements
        while l < sorted.endIndex - 1, sorted[l] == sorted[sorted.index(after: l)] {
            sorted.formIndex(after: &l)
        }
        defer { sorted.formIndex(after: &l) }
        var ml = sorted.index(after: l)
                                      
        ThreeSum: while ml < sorted.endIndex {
            // Skip over any repeated elements
            while ml < sorted.endIndex - 1, sorted[ml] == sorted[sorted.index(after: ml)] {
                sorted.formIndex(after: &ml)
            }
            defer { sorted.formIndex(after: &ml) }
            var mr = sorted.index(after: ml)
            var r = sorted.index(before: sorted.endIndex)
      
            TwoSum: while mr < r && r < sorted.endIndex {
                let sum = sorted[l] + sorted[ml] + sorted[mr] + sorted[r]
                if sum == target {
                    ret.append([sorted[l], sorted[ml], sorted[mr], sorted[r]])
                    // Skip over any repeated elements
                    while mr < r, sorted[mr] == sorted[sorted.index(after: mr)] {
                        sorted.formIndex(after: &mr)
                    }
                    while mr < r, sorted[r] == sorted[sorted.index(before: r)] {
                        sorted.formIndex(before: &r)
                    }
                } else if sum < target {
                    sorted.formIndex(after: &mr)
                } else {
                    sorted.formIndex(before: &r)
                }
            }
        }
    }
    return ret
}


// answer: [[-2, -1, 1, 2], [-2, 0, 0, 2], [-1, 0, 0, 1]]
fourSum([1, 0, -1, 0, -2, 2], target: 0)
