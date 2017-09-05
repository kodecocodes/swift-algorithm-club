# Multiset

A multiset (also known as a bag) is a data structure similar to a regular set, but it can store multiple instances of the same element.

For example, if I added the elements 1, 2, 2 to a regular set, the set would only contain two items, since adding 2 a second time has no effect.

```
var set = Set<Int>()
set.add(1) // set is now [1]
set.add(2) // set is now [1, 2]
set.add(2) // set is still [1, 2]
```

By comparison, after adding the elements 1, 2, 2 to a multiset, it would contain three items.

```
var set = Multiset<Int>()
set.add(1) // set is now [1]
set.add(2) // set is now [1, 2]
set.add(2) // set is now [1, 2, 2]
```

You might be thinking that this looks an awful lot like an array. So why would you use a multiset? Let's consider the differences between the two…

- Ordering: arrays maintain the order of items added to them, multisets do not
- Testing for membership: testing whether an element is a member of the collection is O(N) for arrays, O(1) for multisets.
- Testing for subset: testing whether collection X is a subset of collection Y is a simple operation for a multiset, but complex for arrays

Typical operations on a multiset are:

- Add an element
- Remove an element
- Get the count for an element (the number of times it's been added)
- Get the count for the whole set (the number of items that have been added)
- Check whether it is a subset of another multiset

One real-world use of multisets is to determine whether one string is a partial anagram of another. For example, the word "cacti" is a partial anagrams of "tactical". (In other words, I can rearrange the letters of "tactical" to make "cacti", with some letters left over.)

``` swift
var cacti = Multiset<Character>("cacti")
var tactical = Multiset<Character>("tactical")
cacti.isSubSet(of: tactical) // true!
```

## Implementation

Under the hood, this implementation of Multiset uses a dictionary to store a mapping of elements to the number of times they've been added.

Here's the essence of it:

``` swift
public struct Multiset<Element: Hashable> {
  private var storage: [Element: UInt] = [:]
  
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
set.allItems // returns ["foo", "foo"]
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
