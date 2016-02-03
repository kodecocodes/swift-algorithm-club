/*
  Finds the minimum value in an array in O(n) time.
  The array must not be empty.
*/

func minimum<T: Comparable>(var array: [T]) -> T? {
  var minimum = array.removeFirst()
  for element in array {
    minimum = element < minimum ? element : minimum
  }
  return minimum
}
