# Linear Search

Goal: Find a particular value in an array.

We have an array of generic objects and we iterate over all the objects by comparing each one to the object we're looking for. If the two objects are equal, we stop and we return the index of the object in the array. If not, we continue to look for the next object as long as we have objects in the array.

### An example

Let's say we have an array of numbers `[5, 2, 4, 7]` and we want to check if the array contains the number `2`.

We start by comparing the first number in the array, `5` with the number we're looking for, `2`. They are obviously not the same number and so we continue by taking the second element in the array. We compare the number `2` to our number `2` and we notice that they are the same. We stop our iteration and we return `1`, which is the index of the number `2` in the array.

### The code

Here is a simple implementation of linear search in Swift:

```swift
func linearSearch<T: Equatable>(array: [T], _ object: T) -> Int? {
  for (index, obj) in array.enumerate() where obj == object {
    return index
  }
  return nil
}
```

Put this code in a playground and test it like so:

```swift
let array = [5, 2, 4, 7]
linearSearch(array, 2) 	// This will return 1
```

### Performance

Linear search runs at **O(n)**. It compares the object we are looking for with each object in the array and so the time it takes is proportional to the array length.

The best-case performance is **O(1)** but this case is rare because the object we're looking for has to be positioned at the start of the array to be immediately found.

### See also

See also [Wikipedia](https://en.wikipedia.org/wiki/Linear_search).

*Written by [Patrick Balestra](http://www.github.com/BalestraPatrick)*
