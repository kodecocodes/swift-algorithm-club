//: Playground - noun: a place where people can play

// An unsorted array of numbers
let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]

// Binary search requires that the array is sorted from low to high
let sorted = numbers.sort()

/*
  The recursive version of binary search.
*/
func binarySearch<T: Comparable>(a: [T], key: T, range: Range<Int>) -> Int? {
  if range.startIndex >= range.endIndex {
    return nil
  } else {
    let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
    if a[midIndex] > key {
      return binarySearch(a, key: key, range: range.startIndex ..< midIndex)
    } else if a[midIndex] < key {
      return binarySearch(a, key: key, range: midIndex + 1 ..< range.endIndex)
    } else {
      return midIndex
    }
  }
}

binarySearch(sorted, key: 2, range: 0 ..< sorted.count)   // gives 0
binarySearch(sorted, key: 67, range: 0 ..< sorted.count)  // gives 18
binarySearch(sorted, key: 43, range: 0 ..< sorted.count)  // gives 13
binarySearch(sorted, key: 42, range: 0 ..< sorted.count)  // nil

/*
  The iterative version of binary search.

  Notice how similar these functions are. The difference is that this one
  uses a while loop, while the other calls itself recursively.
*/
func binarySearch<T: Comparable>(a: [T], key: T) -> Int? {
  var range = 0..<a.count
  while range.startIndex < range.endIndex {
    let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
    if a[midIndex] == key {
      return midIndex
    } else if a[midIndex] < key {
      range.startIndex = midIndex + 1
    } else {
      range.endIndex = midIndex
    }
  }
  return nil
}

binarySearch(sorted, key: 2)   // gives 0
binarySearch(sorted, key: 67)  // gives 18
binarySearch(sorted, key: 43)  // gives 13
binarySearch(sorted, key: 42)  // nil
