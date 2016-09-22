# Ordered Array

This is an array that is always sorted from low to high. Whenever you add a new item to this array, it is inserted in its sorted position.

An ordered array is useful for when you want your data to be sorted and you're inserting new items relatively rarely. In that case, it's faster than sorting the entire array. However, if you need to change the array often, it's probably faster to use a regular array and sort it manually.

The implementation is quite basic. It's simply a wrapper around Swift's built-in array:

```swift
public struct OrderedArray<T: Comparable> {
  fileprivate var array = [T]()

  public init(array: [T]) {
    self.array = array.sorted()
  }

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var count: Int {
    return array.count
  }

  public subscript(index: Int) -> T {
    return array[index]
  }

  public mutating func removeAtIndex(index: Int) -> T {
    return array.remove(at: index)
  }

  public mutating func removeAll() {
    array.removeAll()
  }
}

extension OrderedArray: CustomStringConvertible {
  public var description: String {
    return array.description
  }
}
```

As you can see, all these methods simply call the corresponding method on the internal `array` variable.

What remains is the `insert()` function. Here is an initial stab at it:

```swift
  public mutating func insert(_ newElement: T) -> Int {
    let i = findInsertionPoint(newElement)
    array.insert(newElement, at: i)
    return i
  }

  private func findInsertionPoint(_ newElement: T) -> Int {
    for i in 0..<array.count {
      if newElement <= array[i] {
        return i
      }
    }
    return array.count  // insert at the end
  }
```

The helper function `findInsertionPoint()` simply iterates through the entire array, looking for the right place to insert the new element.

> **Note:** Quite conveniently, `array.insert(... atIndex: array.count)` adds the new object to the end of the array, so if no suitable insertion point was found we can simply return `array.count` as the index.

Here's how you can test it in a playground:

```swift
var a = OrderedArray<Int>(array: [5, 1, 3, 9, 7, -1])
a              // [-1, 1, 3, 5, 7, 9]

a.insert(4)    // inserted at index 3
a              // [-1, 1, 3, 4, 5, 7, 9]

a.insert(-2)   // inserted at index 0
a.insert(10)   // inserted at index 8
a              // [-2, -1, 1, 3, 4, 5, 7, 9, 10]
```

The array's contents will always be sorted from low to high, now matter what.

Unfortunately, the current `findInsertionPoint()` function is a bit slow. In the worst case, it needs to scan through the entire array. We can speed this up by using a [binary search](../Binary Search) to find the insertion point.

Here is the new version:

```swift
  private func findInsertionPoint(_ newElement: T) -> Int {
    var startIndex = 0
    var endIndex = array.count

    while startIndex < endIndex {
        let midIndex = startIndex + (endIndex - startIndex) / 2
        if array[midIndex] == newElement {
            return midIndex
        } else if array[midIndex] < newElement {
            startIndex = midIndex + 1
        } else {
            endIndex = midIndex
        }
    }
    return startIndex
  }
```

The big difference with a regular binary search is that this doesn't return `nil` when the value can't be found, but the array index where the element would have been. That's where we insert the new object.

Note that using binary search doesn't change the worst-case running time complexity of `insert()`. The binary search itself takes only **O(log n)** time, but inserting a new object in the middle of an array still involves shifting all remaining elements in memory. So overall, the time complexity is still **O(n)**. But in practice this new version definitely is a lot faster, especially on large arrays.

*Written for Swift Algorithm Club by Matthijs Hollemans*
