func minimum<T: Comparable>(var array: [T]) -> T? {
  var minimum = array.removeFirst()
  for element in array {
    minimum = element < minimum ? element : minimum
  }
  return minimum
}

func maximum<T: Comparable>(var array: [T]) -> T? {
  var maximum = array.removeFirst()
  for element in array {
    maximum = element > maximum ? element : maximum
  }
  return maximum
}

// Simple test of minimum and maximum functions
let array = [ 8, 3, 9, 4, 6 ]
minimum(array)
maximum(array)

// Built-in Swift functions
array.minElement()
array.maxElement()
