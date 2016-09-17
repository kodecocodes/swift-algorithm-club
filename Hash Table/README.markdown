# Hash Table

A hash table allows you to store and retrieve objects by a "key".

Also called dictionary, map, associative array. There are other ways to implement these, such as with a tree or even a plain array, but hash table is the most common.

This should explain why Swift's built-in `Dictionary` type requires that keys conform to the `Hashable` protocol: internally it uses a hash table, just like the one you'll learn about here.

## How it works

At its most basic, a hash table is nothing more than an array. Initially, this array is empty. When you put a value into the hash table under a certain key, it uses that key to calculate an index in the array, like so:

```swift
hashTable["firstName"] = "Steve"

	The hashTable array:
	+--------------+
	| 0:           |
	+--------------+
	| 1:           |
	+--------------+
	| 2:           |
	+--------------+
	| 3: firstName |---> Steve
	+--------------+
	| 4:           |
	+--------------+
```

In this example, the key `"firstName"` maps to array index 3.

Adding a value under a different key puts it at another array index:

```swift
hashTable["hobbies"] = "Programming Swift"

	The hashTable array:
	+--------------+
	| 0:           |
	+--------------+
	| 1: hobbies   |---> Programming Swift
	+--------------+
	| 2:           |
	+--------------+
	| 3: firstName |---> Steve
	+--------------+
	| 4:           |
	+--------------+
```

The trick is in how the hash table calculates those array indices. That's where the hashing comes in. When you write,

```swift
hashTable["firstName"] = "Steve"
```

the hash table takes the key `"firstName"` and asks it for its `hashValue` property. That's why keys must be `Hashable`. 

When you do `"firstName".hashValue`, it returns a big integer: -4799450059917011053. Likewise, `"hobbies".hashValue` has the hash value 4799450060928805186. (The values you see may vary.)

Of course, these numbers are way too big to be used as indices into our array. One of them is even negative! A common way to make these big numbers more suitable is to first make the hash positive and then take the modulo with the array size.

Our array has size 5, so the index for the `"firstName"` key becomes `abs(-4799450059917011053) % 5 = 3`. You can calculate for yourself that the array index for `"hobbies"` is 1.

Using hashes in this manner is what makes the dictionary so efficient: to find an element in the hash table you only have to hash the key to get an array index and then look up the element in the underlying array. All these operations take a constant amount of time, so inserting, retrieving, and removing are all **O(1)**.

> **Note:** As you can see, it's hard to predict where in the array your objects end up. That's why dictionaries do not guarantee any particular order of the elements in the hash table.

## Avoiding collisions

There is one problem: because we take the modulo of the hash value with the size of the array, it can happen that two or more keys get assigned the same array index. This is called a collision.

One way to avoid collisions is to have a very large array. That reduces the likelihood of two keys mapping to the same index. Another trick is to use a prime number for the array size. However, collisions are bound to occur so you need some way to handle them.

Because our table is so small it's easy to show a collision. For example, the array index for the key `"lastName"` is also 3. That's a problem, as we don't want to overwrite the value that's already at this array index.

There are a few ways to handle collisions. A common one is to use chaining. The array now looks as follows:

```swift
	buckets:
	+-----+
	|  0  |
	+-----+     +----------------------------+
	|  1  |---> | hobbies: Programming Swift |
	+-----+     +----------------------------+
	|  2  |
	+-----+     +------------------+     +----------------+
	|  3  |---> | firstName: Steve |---> | lastName: Jobs |
	+-----+     +------------------+     +----------------+
	|  4  |
	+-----+
```

With chaining, keys and their values are not stored directly in the array. Instead, each array element is really a list of zero or more key/value pairs. The array elements are usually called the *buckets* and the lists are called the *chains*. So here we have 5 buckets and two of these buckets have chains. The other three buckets are empty.

If we now write the following to retrieve an item from the hash table,

```swift
let x = hashTable["lastName"]
```

then this first hashes the key `"lastName"` to calculate the array index, which is 3. Bucket 3 has a chain, so we step through that list to find the value with the key `"lastName"`. That is done by comparing the keys, so here that involves a string comparison. The hash table sees that this key belongs to the last item in the chain and returns the corresponding value, `"Jobs"`.

Common ways to implement this chaining mechanism are to use a linked list or another array. Technically speaking the order of the items in the chain doesn't matter, so you also can think of it as a set instead of a list. (Now you can also imagine where the term "bucket" comes from; we just dump all the objects together into the bucket.)

It's important that chains do not become too long or looking up items in the hash table becomes really slow. Ideally, we would have no chains at all but in practice it is impossible to avoid collisions. You can improve the odds by giving the hash table enough buckets and by using high-quality hash functions.

> **Note:** An alternative to chaining is "open addressing". The idea is this: if an array index is already taken, we put the element in the next unused bucket. Of course, this approach has its own upsides and downsides.

## The code

Let's look at a basic implementation of a hash table in Swift. We'll build it up step-by-step.

```swift
public struct HashTable<Key: Hashable, Value> {
  private typealias Element = (key: Key, value: Value)
  private typealias Bucket = [Element]
  private var buckets: [Bucket]

  private(set) public var count = 0
  
  public var isEmpty: Bool { return count == 0 }

  public init(capacity: Int) {
    assert(capacity > 0)
    buckets = Array<Bucket>(repeatElement([], count: capacity))
  }
```

The `HashTable` is a generic container and the two generic types are named `Key` (which must be `Hashable`) and `Value`. We also define two other types: `Element` is a key/value pair for use in a chain and `Bucket` is an array of such `Elements`.

The main array is named `buckets`. It has a fixed size, the so-called capacity, provided by the `init(capacity)` method. We're also keeping track of how many items have been added to the hash table using the `count` variable.

An example of how to create a new hash table object:

```swift
var hashTable = HashTable<String, String>(capacity: 5)
```

Currently the hash table doesn't do anything yet, so let's add the remaining functionality. First, add a helper method that calculates the array index for a given key:

```swift
  private func index(forKey key: Key) -> Int {
    return abs(key.hashValue) % buckets.count
  }
```

This performs the calculation you saw earlier: it takes the absolute value of the key's `hashValue` modulo the size of the buckets array. We've put this in a function of its own because it gets used in a few different places.

There are four common things you'll do with a hash table or dictionary: 

- insert a new element
- look up an element
- update an existing element
- remove an element

The syntax for these is:

```swift
hashTable["firstName"] = "Steve"   // insert
let x = hashTable["firstName"]     // lookup
hashTable["firstName"] = "Tim"     // update
hashTable["firstName"] = nil       // delete
```

We can do all these things with a `subscript` function:

```swift
  public subscript(key: Key) -> Value? {
    get {
      return value(forKey: key)
    }
    set {
      if let value = newValue {
        updateValue(value, forKey: key)
      } else {
        removeValue(forKey: key)
      }
    }
  }
```

This calls three helper functions to do the actual work. Let's take a look at `value(forKey:)` first, which retrieves an object from the hash table.

```swift
  public func value(forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    for element in buckets[index] {
      if element.key == key {
        return element.value
      }
    }
    return nil  // key not in hash table
  }
```

First it calls `index(forKey:)` to convert the key into an array index. That gives us the bucket number, but if there were collisions this bucket may be used by more than one key. So `value(forKey:)` loops through the chain from that bucket and compares the keys one-by-one. If found, it returns the corresponding value, otherwise it returns `nil`.

The code to insert a new element or update an existing element lives in `updateValue(_:forKey:)`. It's a little bit more complicated:

```swift
  public mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
    let index = self.index(forKey: key)
    
    // Do we already have this key in the bucket?
    for (i, element) in buckets[index].enumerate() {
      if element.key == key {
        let oldValue = element.value
        buckets[index][i].value = value
        return oldValue
      }
    }
    
    // This key isn't in the bucket yet; add it to the chain.
    buckets[index].append((key: key, value: value))
    count += 1
    return nil
  }
```

Again, the first thing we do is convert the key into an array index to find the bucket. Then we loop through the chain for that bucket. If we find the key in the chain, it means we must update it with the new value. If the key is not in the chain, we insert the new key/value pair to the end of the chain.

As you can see, it's important that chains are kept short (by making the hash table large enough). Otherwise, you spend a lot of time in these `for`...`in` loops and the performance of the hash table will no longer be **O(1)** but more like **O(n)**.

Removing is similar in that again it loops through the chain:

```swift
  public mutating func removeValue(forKey key: Key) -> Value? {
    let index = self.index(forKey: key)

    // Find the element in the bucket's chain and remove it.
    for (i, element) in buckets[index].enumerated() {
      if element.key == key {
        buckets[index].remove(at: i)
        count -= 1
        return element.value
      }
    }
    return nil  // key not in hash table
  }
```

These are the basic functions of the hash table. They all work the same way: convert the key into an array index using its hash value, find the bucket, then loop through that bucket's chain and perform the desired operation.

Try this stuff out in a playground. It should work just like a standard Swift `Dictionary`.

## Resizing the hash table

This version of `HashTable` always uses an array of a fixed size or capacity. That's fine if you've got a good idea of many items you'll be storing in the hash table. For the capacity, choose a prime number that is greater than the maximum number of items you expect to store and you're good to go.

The *load factor* of a hash table is the percentage of the capacity that is currently used. If there are 3 items in a hash table with 5 buckets, then the load factor is `3/5 = 60%`.

If the hash table is too small and the chains are long, the load factor can become greater than 1. That's not a good idea.

If the load factor becomes too high, say > 75%, you can resize the hash table. Adding the code for this is left as an exercise for the reader. Keep in mind that making the buckets array larger will change the array indices that the keys map to! To account for this, you'll have to insert all the elements again after resizing the array.

## Where to go from here?

`HashTable` is quite basic. It might be fun to integrate it better with the Swift standard library by making it a `SequenceType`, for example.

*Written for Swift Algorithm Club by Matthijs Hollemans*
