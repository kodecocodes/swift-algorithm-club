import Foundation

extension Collection where Element: Equatable {
    /// Advances the index to the next unique element in a sorted collection.
    mutating func formUniqueIndex(after index: inout Index) {
        var prev = index
        repeat {
            prev = index
            formIndex(after: &index)
        } while index < endIndex && self[prev] == self[index]
    }
}

extension BidirectionalCollection where Element: Equatable {
    /// Moves the index to the previous unique element in a sorted collection.
    mutating func formUniqueIndex(before index: inout Index) {
        var prev = index
        repeat {
            prev = index
            formIndex(before: &index)
        } while index > startIndex && self[prev] == self[index]
    }
}

func threeSum<T: BidirectionalCollection>(_ collection: T, target: T.Element) -> [[T.Element]]
where T.Element: Numeric & Comparable {
    // Sort the collection first
    let sorted = collection.sorted()
    var results: [[T.Element]] = []

    var left = sorted.startIndex
    while left < sorted.endIndex {
        defer { sorted.formUniqueIndex(after: &left) }

        var middle = sorted.index(after: left)
        var right = sorted.index(before: sorted.endIndex)

        while middle < right {
            let sum = sorted[left] + sorted[middle] + sorted[right]

            if sum == target {
                results.append([sorted[left], sorted[middle], sorted[right]])
                sorted.formUniqueIndex(after: &middle)
                sorted.formUniqueIndex(before: &right)
            } else if sum < target {
                sorted.formUniqueIndex(after: &middle)
            } else {
                sorted.formUniqueIndex(before: &right)
            }
        }
    }

    return results
}

// Test Cases
print(threeSum([-1, 0, 1, 2, -1, -4], target: 0)) // Expected: [[-1, -1, 2], [-1, 0, 1]]
print(threeSum([-1, -1, -1, -1, 2, 1, -4, 0], target: 0)) // Expected: [[-1, -1, 2], [-1, 0, 1]]
print(threeSum([-1, -1, -1, -1, -1, -1, 2], target: 0)) // Expected: [[-1, -1, 2]]

     
     
  
     


