/*
  Finds the maximum value in an array in O(n) time.
  The array must not be empty.
*/

func maximum<T: Comparable>(var array: [T]) -> T? {
  var maximum = array.removeFirst()
  for element in array {
    maximum = element > maximum ? element : maximum
  }
  return maximum
}
