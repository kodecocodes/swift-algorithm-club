# Select Minimum / Maximum

Goal: Find the minimum/maximum object in an unsorted array.

## Maximum or minimum

We have an array of generic objects and we iterate over all the objects keeping track of the minimum/maximum element so far.

### An example

Let's say the we want to find the maximum value in the unsorted list `[ 8, 3, 9, 4, 6 ]`.

Pick the first number, `8`, and store it as the maximum element so far. 

Pick the next number from the list, `3`, and compare it to the current maximum. `3` is less than `8` so the maximum `8` does not change.

Pick the next number from the list, `9`, and compare it to the current maximum. `9` is greater than `8` so we store `9` as the maximum.

Repeat this process until the all elements in the list have been processed.

### The code

Here is a simple implementation in Swift:

```swift
func minimum<T: Comparable>(_ array: [T]) -> T? {
  guard var minimum = array.first else {
    return nil
  }

  for element in array.dropFirst() {
    minimum = element < minimum ? element : minimum
  }
  return minimum
}

func maximum<T: Comparable>(_ array: [T]) -> T? {
  guard var maximum = array.first else {
    return nil
  }

  for element in array.dropFirst() {
    maximum = element > maximum ? element : maximum
  }
  return maximum
}
```

Put this code in a playground and test it like so:

```swift
let array = [ 8, 3, 9, 4, 6 ]
minimum(array)   // This will return 3
maximum(array)   // This will return 9
```

### In the Swift standard library

The Swift library already contains an extension to `SequenceType` that returns the minimum/maximum element in a sequence.

```swift
let array = [ 8, 3, 9, 4, 6 ]
array.minElement()   // This will return 3
array.maxElement()   // This will return 9
```

```swift
let array = [ 8, 3, 9, 4, 6 ]
//swift3
array.min()   // This will return 3
array.max()   // This will return 9
```

## Maximum and minimum

To find both the maximum and minimum values contained in array while minimizing the number of comparisons we can compare the items in pairs. 

### An example

Let's say the we want to find the minimum and maximum value in the unsorted list `[ 8, 3, 9, 6, 4 ]`.

Pick the first number, `8`, and store it as the minimum and maximum element so far. 

Because we have an odd number of items we remove `8` from the list which leaves the pairs `[ 3, 9 ]` and `[ 6, 4 ]`.

Pick the next pair of numbers from the list, `[ 3, 9 ]`. Of these two numbers, `3` is the smaller one, so we compare `3` to the current minimum `8`, and we compare `9` to the current maximum `8`. `3` is less than `8` so the new minimum is `3`. `9` is greater than `8` so the new maximum is `9`.

Pick the next pair of numbers from the list, `[ 6, 4 ]`. Here, `4` is the smaller one, so we compare `4` to the current minimum `3`, and we compare `6` to the current maximum `9`. `4` is greater than `3` so the minimum does not change. `6` is less than `9` so the maximum does not change.

The result is a minimum of `3` and a maximum of `9`.

### The code

Here is a simple implementation in Swift:

```swift
func minimumMaximum<T: Comparable>(_ array: [T]) -> (minimum: T, maximum: T)? {
  guard var minimum = array.first else {
    return nil
  }
  var maximum = minimum

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
```

Put this code in a playground and test it like so:

```swift
let result = minimumMaximum(array)!
result.minimum   // This will return 3
result.maximum   // This will return 9
```

By picking elements in pairs and comparing their maximum and minimum with the running minimum and maximum we reduce the number of comparisons to 3 for every 2 elements.

## Performance

These algorithms run at **O(n)**. Each object in the array is compared with the running minimum/maximum so the time it takes is proportional to the array length.

*Written by [Chris Pilcher](https://github.com/chris-pilcher)*
