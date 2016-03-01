# Binary Tree

## Introduction

A Bloom Filter is a space-efficient data structure to check for an element in a set, that guarantees that there are no false negatives on queries. In other words, a query to a Bloom filter either returns "false", meaning the element is definitely not in the set, or "true", meaning that the element could be in the set. At first, this may not seem too useful. However, it's important in applications like cache filtering and data synchronization.

An advantage of the Bloom Filter over a hash table is that the former maintains constant memory usage and constant-time insert and search. For a large number of elements in a set, the performance difference between a hash table and a Bloom Filter is significant, and it is a viable option if you do not need the guarantee of no false positives.

## Implementation

A Bloom Filter is essentially a fixed-length bit vector. To insert an element in the filter, it is hashed with *m* different hash functions, which map to indices in the array. The bits at these indices are set to `1`, or `true`, when an element is inserted.

Querying, similarly, is accomplished by hashing the expected value, and checking to see if all of the bits at the indices are `true`. If even one of the bits is not `true`, the element could not have been inserted - and the query returns `false`. If all the bits are `true`, the query returns likewise. If there are "collisions", the query may erroneously return `true` even though the element was not inserted - bringing about the issue with false positives mentioned earlier.

Deletion is not possible with a Bloom Filter, since any one bit might have been set by multiple elements inserted. Once you add an element, it's in there for good.

## The Code

The code is extremely straightforward, as you can imagine. The internal bit array is set to a fixed length on initialization, which cannot be mutated once it is initialized. Several hash functions should be specified at initialization, which will depend on the types you're using. You can see some examples in the tests - the djb2 and sdbm hash functions for strings.

```swift
public init(size: Int = 1024, hashFunctions: [T -> Int]) {
    self.arr = Array<Bool>(count: size, repeatedValue: false)
    self.hashFunctions = hashFunctions
}
```

Insertion just flips the required bits to `true`:

```swift
public func insert(toInsert: T) {
    let hashValues: [Int] = self.computeHashes(toInsert)

    for hashValue in hashValues {
        self.arr[hashValue] = true
    }
}
```

And querying checks to make sure the bits at the hashed values are `true`:

```swift
public func query(value: T) -> Bool {
    let hashValues = self.computeHashes(value)

    let results = hashValues.map() { hashValue in
        self.arr[hashValue]
    }

    let exists = results.reduce(true, combine: { $0 && $1 })

    return exists
}
```

If you're coming from another imperative language, you might notice the unusual syntax in the `exists` constant assignment. Swift makes use of functional paradigms when it makes code more consise and readable, and in this case, `reduce` is a much more consise way to check if all the required bits are `true` than a `for` loop. 

*Written for Swift Algorithm Club by Jamil Dhanani*
