# Bloom Filter

## Introduction

A Bloom Filter is a space-efficient data structure that tells you whether or not an element is present in a set.

This is a probabilistic data structure: a query to a Bloom filter either returns `false`, meaning the element is definitely not in the set, or `true`, meaning that the element *might* be in the set.

There is a small probability of false positives, where the element isn't actually in the set even though the query returned `true`. But there will never any false negatives: you're guaranteed that if the query returns `false`, then the element really isn't in the set.

So a Bloom Filter tells you, "definitely not" or "probably yes".

At first, this may not seem too useful. However, it's important in applications like cache filtering and data synchronization.

An advantage of the Bloom Filter over a hash table is that the former maintains constant memory usage and constant-time insert and search. For sets with a large number of elements, the performance difference between a hash table and a Bloom Filter is significant, and it is a viable option if you do not need the guarantee of no false positives.

> **Note:** Unlike a hash table, the Bloom Filter does not store the actual objects. It just remembers what objects you’ve seen (with a degree of uncertainty) and which ones you haven’t.

## Inserting objects into the set

A Bloom Filter is essentially a fixed-length [bit vector](../Bit%20Set/), an array of bits. When we insert objects, we set some of these bits to `1`, and when we query for objects we check if certain bits are `0` or `1`. Both operations use hash functions.

To insert an element in the filter, the element is hashed with several different hash functions. Each hash function returns a value that we map to an index in the array. We then set the bits at these indices to `1` or true.

For example, let's say this is our array of bits. We have 17 bits and initially they are all `0` or false:

	[ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]

Now we want to insert the string `"Hello world!"` into the Bloom Filter. We apply two hash functions to this string. The first one gives the value 1999532104120917762. We map this hash value to an index into our array by taking the modulo of the array length: `1999532104120917762 % 17 = 4`. This means we set the bit at index 4 to `1` or true:

	[ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]

Then we hash the original string again but this time with a different hash function. It gives the hash value 9211818684948223801. Modulo 17 that is 12, and we set the bit at index 12 to `1` as well:

	[ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0 ]

These two 1-bits are enough to tell the Bloom Filter that it now contains the string `"Hello world!"`. Of course, it doesn't contain the actual string, so you can't ask the Bloom Filter, "give me a list of all the objects you contain". All it has is a bunch of ones and zeros.

## Querying the set

Querying, similarly to inserting, is accomplished by first hashing the expected value, which gives several array indices, and then checking to see if all of the bits at those indices are `1`. If even one of the bits is not `1`, the element could not have been inserted and the query returns `false`. If all the bits are `1`, the query returns `true`.

For example, if we query for the string `"Hello WORLD"`, then the first hash function returns 5383892684077141175, which modulo 17 is 12. That bit is `1`. But the second hash function gives 5625257205398334446, which maps to array index 9. That bit is `0`. This means the string `"Hello WORLD"` is not in the filter and the query returns `false`.

The fact that the first hash function mapped to a `1` bit is a coincidence (it has nothing to do with the fact that both strings start with `"Hello "`). Too many such coincidences can lead to "collisions". If there are collisions, the query may erroneously return `true` even though the element was not inserted -- bringing about the issue with false positives mentioned earlier.

Let's say we insert some other element, `"Bloom Filterz"`, which sets bits 7 and 9. Now the array looks like this:

	[ 0, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0, 0 ]

If you query for `"Hello WORLD"` again, the filter sees that bit 12 is true and bit 9 is now true as well. It reports that `"Hello WORLD"` is indeed present in the set, even though it isn't... because we never inserted that particular string. It's a false positive. This example shows why a Bloom Filter will never say, "definitely yes", only "probably yes".

You can fix such issues by using an array with more bits and using additional hash functions. Of course, the more hash functions you use the slower the Bloom Filter will be. So you have to strike a balance.

Deletion is not possible with a Bloom Filter, since any one bit might belong to multiple elements. Once you add an element, it's in there for good.

Performance of a Bloom Filter is **O(k)** where **k** is the number of hashing functions.

## The code

The code is quite straightforward. The internal bit array is set to a fixed length on initialization, which cannot be mutated once it is initialized.

```swift
public init(size: Int = 1024, hashFunctions: [(T) -> Int]) {
	self.array = [Bool](repeating: false, count: size)
  self.hashFunctions = hashFunctions
}
```

Several hash functions should be specified at initialization. Which hash functions you use will depend on the datatypes of the elements you'll be adding to the set. You can see some examples in the playground and the tests -- the `djb2` and `sdbm` hash functions for strings.

Insertion just flips the required bits to `true`:

```swift
public func insert(_ element: T) {
  for hashValue in computeHashes(element) {
    array[hashValue] = true
  }
}
```

This uses the `computeHashes()` function, which loops through the specified `hashFunctions` and returns an array of indices:

```swift
private func computeHashes(_ value: T) -> [Int] {
  return hashFunctions.map() { hashFunc in abs(hashFunc(value) % array.count) }
}
```

And querying checks to make sure the bits at the hashed values are `true`:

```swift
public func query(_ value: T) -> Bool {
  let hashValues = computeHashes(value)
  let results = hashValues.map() { hashValue in array[hashValue] }
	let exists = results.reduce(true, { $0 && $1 })
  return exists
}
```

If you're coming from another imperative language, you might notice the unusual syntax in the `exists` assignment. Swift makes use of functional paradigms when it makes code more consise and readable, and in this case `reduce` is a much more consise way to check if all the required bits are `true` than a `for` loop.

## Another approach

In the previous section, you learnt about how using multiple different hash functions can help reduce the chance of collisions in the bloom filter. However, good hash functions are difficult to design. A simple alternative to multiple hash functions is to use a set of random numbers.

As an example, let's say a bloom filter wants to hash each element 15 times during insertion. Instead of using 15 different hash functions, you can rely on just one hash function. The hash value can then be combined with 15 different values to form the indices for flipping. This bloom filter would initialize a set of 15 random numbers ahead of time and use these values during each insertion.

```
hash("Hello world!") >> hash(987654321) // would flip bit 8
hash("Hello world!") >> hash(123456789) // would flip bit 2
```

Since Swift 4.2, `Hasher` is now included in the Standard library, which is designed to reduce multiple hashes to a single hash in an efficient manner. This makes combining the hashes trivial.

```
private func computeHashes(_ value: T) -> [Int] {
  return randomSeeds.map() { seed in
		let hasher = Hasher()
		hasher.combine(seed)
		hasher.combine(value)
		let hashValue = hasher.finalize()
		return abs(hashValue % array.count)
	}
}
```

If you want to learn more about this approach, you can read about the [Hasher documentation](https://developer.apple.com/documentation/swift/hasher) or Soroush Khanlou's [Swift 4.2 Bloom filter](http://khanlou.com/2018/09/bloom-filters/) implementation.

*Written for Swift Algorithm Club by Jamil Dhanani. Edited by Matthijs Hollemans. Updated by Bruno Scheele.*
