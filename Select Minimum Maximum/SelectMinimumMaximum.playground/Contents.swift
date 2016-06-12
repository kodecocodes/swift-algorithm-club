// Compare each item to find minimum
func minimum<T: Comparable>(var array: [T]) -> T? {
  guard !array.isEmpty else {
    return nil
  }

  var minimum = array.removeFirst()
  for element in array {
    minimum = element < minimum ? element : minimum
  }
  return minimum
}

// Compare each item to find maximum
func maximum<T: Comparable>(var array: [T]) -> T? {
  guard !array.isEmpty else {
    return nil
  }

  var maximum = array.removeFirst()
  for element in array {
    maximum = element > maximum ? element : maximum
  }
  return maximum
}

// Compare in pairs to find minimum and maximum
func minimumMaximum<T: Comparable>(var array: [T]) -> (minimum: T, maximum: T)? {
  guard !array.isEmpty else {
    return nil
  }

  var minimum = array.first!
  var maximum = array.first!

  let hasOddNumberOfItems = array.count % 2 != 0
  if hasOddNumberOfItems {
    array.removeFirst()
  }

  while !array.isEmpty {
    let pair = (array.removeFirst(), array.removeFirst())

    if pair.0 > pair.1 {
      if pair.0 > maximum {
        maximum = pair.0
      }
      if pair.1 < minimum {
        minimum = pair.1
      }
    } else {
      if pair.1 > maximum {
        maximum = pair.1
      }
      if pair.0 < minimum {
        minimum = pair.0
      }
    }
  }

  return (minimum, maximum)
}

// Test of minimum and maximum functions
let array = [ 8, 3, 9, 4, 6 ]
minimum(array)
maximum(array)

// Test of minimumMaximum function
let result = minimumMaximum(array)!
result.minimum
result.maximum

// Built-in Swift functions
array.minElement()
array.maxElement()
