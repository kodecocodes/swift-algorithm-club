// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

// Compare each item to find minimum
func minimum<T: Comparable>(_ array: [T]) -> T? {
  guard var minimum = array.first else {
    return nil
  }
  
  for element in array.dropFirst() {
    minimum = element < minimum ? element : minimum
  }
  return minimum
}

// Compare each item to find maximum
func maximum<T: Comparable>(_ array: [T]) -> T? {
  guard var maximum = array.first else {
    return nil
  }
  
  for element in array.dropFirst() {
    maximum = element > maximum ? element : maximum
  }
  return maximum
}

// Compare in pairs to find minimum and maximum
func minimumMaximum<T: Comparable>(_ array: [T]) -> (minimum: T, maximum: T)? {
  guard !array.isEmpty else {
    return nil
  }

  var minimum = array.first!
  var maximum = array.first!

  // if 'array' has an odd number of items, let 'minimum' or 'maximum' deal with the leftover
  let start = array.count % 2 // 1 if odd, skipping the first element
  for i in stride(from: start, to: array.count, by: 2) {
    let pair = (array[i], array[i+1])

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
array.min()
array.max()
