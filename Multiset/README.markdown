# Multiset

A multiset (also known as a bag) is a data structure similar to a regular set, but it can store multiple instances of the same element.

The following all represent the same *set*, but do not represent the same *multiset*.

```
[1, 3, 2]
[1, 3, 2, 2]
```

In this multiset implementation, ordering is unimportant. So these two multisets are identical:

```
[1, 2, 2]
[2, 1, 2]
```

Typical operations on a multiset are:

- Add an element
- Remove an element
- Get the count for an element (the number of times it's been added)
- Get the count for the whole set (the number of items that have been added)
- Check whether it is a subset of another multiset

## Implementation

Under the hood, this implementation of Multiset uses a dictionary to store a mapping of elements to the number of times they've been added.

Here's the essence of it:

``` swift
public struct Multiset<Element: Hashable> {
  public private(set) var storage: [Element: UInt] = [:]
  
  public init() {}
```

And here's how you'd use this class to create a multiset of strings:

``` swift
var set = Multiset<String>()
```

Adding an element is a case of incrementing the counter for that element, or setting it to 1 if it doesn't already exist:

``` swift
public mutating func add (_ elem: Element) {
  storage[elem, default: 0] += 1
}
```

Here's how you'd use this method to add to the set we created earlier:

```swift
set.add("foo")
set.add("foo") 
```

Our set now contains two elements, both the string "foo".

Removing an element works much the same way as adding; decrement the counter for the element, or remove it from the underlying dictionary if its value is 1 before removal.

``` swift
public mutating func remove (_ elem: Element) {
  if let currentCount = storage[elem] {
    if currentCount > 1 {
      storage[elem] = currentCount - 1
    } else {
      storage.removeValue(forKey: elem)
    }
  }
}
```

Getting the count for an item is simple: we just return the value for the given item in the internal dictionary.

``` swift
public func count(for key: Element) -> UInt {
  return storage[key] ?? 0
}
```

*Written for the Swift Algorithm Club by Simon Whitaker*
