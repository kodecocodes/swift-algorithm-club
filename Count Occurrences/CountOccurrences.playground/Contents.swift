
func countOccurrences<T: Comparable>(of key: T, in array: [T]) -> Int {
  var leftBoundary: Int {
    var low = 0
    var high = array.count
    while low < high {
      let midIndex = low + (high - low)/2
      if array[midIndex] < key {
        low = midIndex + 1
      } else {
        high = midIndex
      }
    }
    return low
  }

  var rightBoundary: Int {
    var low = 0
    var high = array.count
    while low < high {
      let midIndex = low + (high - low)/2
      if array[midIndex] > key {
        high = midIndex
      } else {
        low = midIndex + 1
      }
    }
    return low
  }

  return rightBoundary - leftBoundary
}

// Simple test

let a = [ 0, 1, 1, 3, 3, 3, 3, 6, 8, 10, 11, 11 ]
countOccurrences(of: 3, in: a)

// Test with arrays of random size and contents (see debug output)

import Foundation

func createArray() -> [Int] {
  var a = [Int]()
  for i in 0...5 {
    if i != 2 {  // don't include the number 2
      let count = Int(arc4random_uniform(UInt32(6))) + 1
      for _ in 0..<count {
        a.append(i)
      }
    }
  }
  return a.sorted()
}

for _ in 0..<10 {
  let a = createArray()
  print(a)

  // Note: we also test -1 and 6 to check the edge cases.
  for k in -1...6 {
    print("\t\(k): \(countOccurrences(of: k, in: a))")
  }
}
