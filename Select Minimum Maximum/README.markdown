# Select Minimum / Maximum

Goal: Find the minimum/maximum object in an unsorted array.

We have an array of generic objects and we iterate over all the objects keeping track of the minimum/maximum element so far.

### Maximum or minimum

#### An example

Let's say the we want to find the maximum value in the unsorted list `[ 8, 3, 9, 4, 6 ]`.

Pick the first number, `8`, and store it as the maximum element so far. 

Pick the next number from the list, `3`, and compare it to the current maximum `8`. `3` is less than `8` so the maximum `8` does not change.

Pick the next number from the list, `9`, and compare it to the current maximum `8`. `9` is greater than `8` so we store `9` as the maximum.

Repeat this process until the all elements in the list have been processed.

#### The code

Here is a simple implementation in Swift:

```swift
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
```

Put this code in a playground and test it like so:

```swift
let array = [ 8, 3, 9, 4, 6 ]
minimum(array) // This will return 3
maximum(array) // This will return 9
```

### Maximum and minimum

To find both the maximum and minimum values contained in array while minimizing the number of comparisons we can compare the items in pairs. 

```swift
func minimumMaximum<T: Comparable>(var array: [T]) -> (minimum: T, maximum: T)
{
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
```

Put this code in a playground and test it like so:

```swift

let result = minimumMaximum(array)
result.minimum // This will return 3
result.maximum // This will return 9
```

By picking elements in pairs and comparing their maximum and minimum with the running minimum and maximum we reduce the number of comparisons to 3 for every 2 elements.

### Performance

These algorithms run at **O(n)**. Each object in the array is compared with the running minimum/maximum so the time it takes is proportional to the array length.

### Swift library

The Swift library already contains an extension to `SequenceType` that returns the minimum/maximum element in a sequence.

```swift
let array = [ 8, 3, 9, 4, 6 ]
array.minElement() // This will return 3
array.maxElement() // This will return 9
```
