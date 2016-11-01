# Fixed-Size Arrays

Early programming languages didn't have very fancy arrays. You'd create the array with a specific size and from that moment on it would never grow or shrink. Even the standard arrays in C and Objective-C are still of this type.

When you define an array like so,

	int myArray[10];

the compiler allocates one contiguous block of memory that can hold 40 bytes (assuming an `int` is 4 bytes):

![An array with room for 10 elements](Images/array.png)

That's your array. It will always be this size. If you need to fit more than 10 elements, you're out of luck... there is no room for it.

To get an array that grows when it gets full you need to use a [dynamic array](https://en.wikipedia.org/wiki/Dynamic_array) object such as `NSMutableArray` in Objective-C or `std::vector` in C++, or a language like Swift whose arrays increase their capacity as needed.

A major downside of the old-style arrays is that they need to be big enough or you run out of space. But if they are too big you're wasting memory. And you need to be careful about security flaws and crashes due to buffer overflows. In summary, fixed-size arrays are not flexible and they leave no room for error.

That said, **I like fixed-size arrays** because they are simple, fast, and predictable.

The following operations are typical for an array:

- append a new element to the end
- insert a new element at the beginning or somewhere in the middle
- delete an element
- look up an element by index
- count the size of the array

For a fixed-size array, appending is easy as long as the array isn't full yet:

![Appending a new element](Images/append.png)

Looking up by index is also quick and easy:

![Indexing the array](Images/indexing.png)

These two operations have complexity **O(1)**, meaning the time it takes to perform them is independent of the size of the array.

For an array that can grow, appending is more involved: if the array is full, new memory must be allocated and the old contents copied over to the new memory buffer. On average, appending is still an **O(1)** operation, but what goes on under the hood is less predictable.

The expensive operations are inserting and deleting. When you insert an element somewhere that's not at the end, it requires moving up the remainder of the array by one position. That involves a relatively costly memory copy operation. For example, inserting the value `7` in the middle of the array:

![Insert requires a memory copy](Images/insert.png)

If your code was using any indexes into the array beyond the insertion point, these indexes are now referring to the wrong objects.

Deleting requires a copy the other way around:

![Delete also requires a memory copy](Images/delete.png)

This, by the way, is also true for `NSMutableArray` or Swift arrays. Inserting and deleting are **O(n)** operations -- the larger the array the more time it takes.

Fixed-size arrays are a good solution when:

1. You know beforehand the maximum number of elements you'll need. In a game this could be the number of sprites that can be active at a time. It's not unreasonable to put a limit on this. (For games it's a good idea to allocate all the objects you need in advance anyway.)
2. It is not necessary to have a sorted version of the array, i.e. the order of the elements does not matter.

If the array does not need to be sorted, then an `insertAt(index)` operation is not needed. You can simply append any new elements to the end, until the array is full.

The code for adding an element becomes:

```swift
func append(_ newElement: T) {
  if count < maxSize {
    array[count] = newElement
    count += 1
  }
}
```

The `count` variable keeps track of the size of the array and can be considered the index just beyond the last element. That's the index where you'll insert the new element.

Determining the number of elements in the array is just a matter of reading the `count` variable, a **O(1)** operation.

The code for removing an element is equally simple:

```swift
func removeAt(index: Int) {
  count -= 1
  array[index] = array[count]
}
```

This copies the last element on top of the element you want to remove, and then decrements the size of the array.

![Deleting just means copying one element](Images/delete-no-copy.png)

This is why the array is not sorted. To avoid an expensive copy of a potentially large portion of the array we copy just one element, but that does change the order of the elements.

There are now two copies of element `6` in the array, but what was previously the last element is no longer part of the active array. It's just junk data -- the next time you append an new element, this old version of `6` will be overwritten.

Under these two constraints -- a limit on the number of elements and an unsorted array -- fixed-size arrays are still perfectly suitable for use in modern software.

Here is an implementation in Swift:

```swift
struct FixedSizeArray<T> {
  private var maxSize: Int
  private var defaultValue: T
  private var array: [T]
  private (set) var count = 0
  
  init(maxSize: Int, defaultValue: T) {
    self.maxSize = maxSize
    self.defaultValue = defaultValue
    self.array = [T](repeating: defaultValue, count: maxSize)
  }
  
  subscript(index: Int) -> T {
    assert(index >= 0)
    assert(index < count)
    return array[index]
  }
  
  mutating func append(_ newElement: T) {
    assert(count < maxSize)
    array[count] = newElement
    count += 1
  }
  
  mutating func removeAt(index: Int) -> T {
    assert(index >= 0)
    assert(index < count)
    count -= 1
    let result = array[index]
    array[index] = array[count]
    array[count] = defaultValue
    return result
  }
  
  mutating func removeAll() {
    for i in 0..<count {
      array[i] = defaultValue
    }
    count = 0
  }
}
```

When creating the array, you specify the maximum size and a default value:

```swift
var a = FixedSizeArray(maxSize: 10, defaultValue: 0)
```

Note that `removeAt(index: Int)` overwrites the last element with this `defaultValue` to clean up the "junk" object that gets left behind. Normally it wouldn't matter to leave that duplicate object in the array, but if it's a class or a struct it may have strong references to other objects and it's good boyscout practice to zero those out.

*Written for Swift Algorithm Club by Matthijs Hollemans*
