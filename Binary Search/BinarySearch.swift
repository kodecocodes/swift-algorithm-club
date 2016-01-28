/*
  Binary Search

  Recursively splits the array in half until the value is found.

  If there is more than one occurrence of the search key in the array, then
  there is no guarantee which one it finds.

  Note: The array must be sorted!
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
