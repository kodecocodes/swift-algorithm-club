/// Counts the number of times a value appears in an array in O(log n) time.  The array must be sorted from low to high.
///
/// - Parameter key: the key to be searched for in the array
/// - Parameter array: the array to search
/// - Returns: the count of occurences of the key in the given array
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
