# Hash Set

A set is a collection of elements that is kind of like an array but with two important differences: the order of the elements in the set is unimportant and each element can appear only once.

If the following were arrays, they'd all be different. However, they all represent the same set:

```swift
[1 ,2, 3]
[2, 1, 3]
[3, 2, 1]
[1, 2, 2, 3, 1]
```

Because each element can appear only once, it doesn't matter how often you write the element down -- only one of them counts.

> **Note:** I often prefer to use sets over arrays when I have a collection of objects but don't care what order they are in. Using a set communicates to the programmer that the order of the elements is unimportant. If you're using an array, then you can't assume the same thing.

Typical operations on a set are:

- insert an element
- remove an element
- check whether the set contains an element
- take the union with another set
- take the intersection with another set
- calculate the difference with another set

Union, intersection, and difference are ways to combine two sets into a single one:

![Union, intersection, difference](Images/CombineSets.png)

As of Swift 1.2, the standard library includes a built-in `Set` type but here I'll show how you can make your own. You wouldn't use this in production code, but it's instructive to see how sets are implemented.

It's possible to implement a set using a simple array but that's not the most efficient way. Instead, we'll use a dictionary. Since `Swift`'s dictionary is built using a hash table, our own set will be a hash set.

## The code

Here are the beginnings of `HashSet` in Swift:

```swift
public struct HashSet<T: Hashable> {
    fileprivate var dictionary = Dictionary<T, Bool>()

    public init() {

    }

    public mutating func insert(_ element: T) {
        dictionary[element] = true
    }

    public mutating func remove(_ element: T) {
        dictionary[element] = nil
    }

    public func contains(_ element: T) -> Bool {
        return dictionary[element] != nil
    }

    public func allElements() -> [T] {
        return Array(dictionary.keys)
    }

    public var count: Int {
        return dictionary.count
    }

    public var isEmpty: Bool {
        return dictionary.isEmpty
    }
}
```

The code is really very simple because we rely on Swift's built-in `Dictionary` to do all the hard work. The reason we use a dictionary is that dictionary keys must be unique, just like the elements from a set. In addition, a dictionary has **O(1)** time complexity for most of its operations, making this set implementation very fast.

Because we're using a dictionary, the generic type `T` must conform to `Hashable`. You can put any type of object into our set, as long as it can be hashed. (This is true for Swift's own `Set` too.)

Normally, you use a dictionary to associate keys with values, but for a set we only care about the keys. That's why we use `Bool` as the dictionary's value type, even though we only ever set it to `true`, never to `false`. (We could have picked anything here but booleans take up the least space.)

Copy the code to a playground and add some tests:

```swift
var set = HashSet<String>()

set.insert("one")
set.insert("two")
set.insert("three")
set.allElements()      // ["one, "three", "two"]

set.insert("two")
set.allElements()      // still ["one, "three", "two"]

set.contains("one")    // true
set.remove("one")
set.contains("one")    // false
```

The `allElements()` function converts the contents of the set into an array. Note that the order of the elements in that array can be different than the order in which you added the items. As I said, a set doesn't care about the order of the elements (and neither does a dictionary).


## Combining sets

A lot of the usefulness of sets is in how you can combine them. (If you've ever used a vector drawing program like Sketch or Illustrator, you'll have seen the Union, Subtract, Intersect options to combine shapes. Same thing.)

Here is the code for the union operation:

```swift
extension HashSet {
    public func union(_ otherSet: HashSet<T>) -> HashSet<T> {
        var combined = HashSet<T>()
        for obj in self.dictionary.keys {
            combined.insert(obj)
        }
        for obj in otherSet.dictionary.keys {
            combined.insert(obj)
        }
        return combined
    }
}
```

The *union* of two sets creates a new set that consists of all the elements in set A plus all the elements in set B. Of course, if there are duplicate elements they count only once.

Example:

```swift
var setA = HashSet<Int>()
setA.insert(1)
setA.insert(2)
setA.insert(3)
setA.insert(4)

var setB = HashSet<Int>()
setB.insert(3)
setB.insert(4)
setB.insert(5)
setB.insert(6)

let union = setA.union(setB)
union.allElements()           // [5, 6, 2, 3, 1, 4]
```

As you can see, the union of the two sets contains all of the elements now. The values `3` and `4` still appear only once, even though they were in both sets.

The *intersection* of two sets contains only the elements that they have in common. Here is the code:

```swift
extension HashSet {
    public func intersect(_ otherSet: HashSet<T>) -> HashSet<T> {
        var common = HashSet<T>()
        for obj in dictionary.keys {
            if otherSet.contains(obj) {
                common.insert(obj)
            }
        }
        return common
    }
}
```

To test it:

```swift
let intersection = setA.intersect(setB)
intersection.allElements()
```

This prints `[3, 4]` because those are the only objects from set A that are also in set B.

Finally, the *difference* between two sets removes the elements they have in common. The code is as follows:

```swift
extension HashSet {
    public func difference(_ otherSet: HashSet<T>) -> HashSet<T> {
        var diff = HashSet<T>()
        for obj in dictionary.keys {
            if !otherSet.contains(obj) {
                diff.insert(obj)
            }
        }
        return diff
    }
}
```

It's really the opposite of `intersect()`. Try it out:

```swift
let difference1 = setA.difference(setB)
difference1.allElements()                // [2, 1]

let difference2 = setB.difference(setA)
difference2.allElements()                // [5, 6]
```

## Where to go from here?

If you look at the [documentation](http://swiftdoc.org/v2.1/type/Set/) for Swift's own `Set`, you'll notice it has tons more functionality. An obvious extension would be to make `HashSet` conform to `SequenceType` so that you can iterate it with a `for`...`in` loop.

Another thing you could do is replace the `Dictionary` with an actual [hash table](../Hash%20Table), but one that just stores the keys and doesn't associate them with anything. So you wouldn't need the `Bool` values anymore.

If you often need to look up whether an element belongs to a set and perform unions, then the [union-find](../Union-Find/) data structure may be more suitable. It uses a tree structure instead of a dictionary to make the find and union operations very efficient.

> **Note:** I'd like to make `HashSet` conform to `ArrayLiteralConvertible` so you can write `let setA: HashSet<Int> = [1, 2, 3, 4]` but currently this crashes the compiler.

*Written for Swift Algorithm Club by Matthijs Hollemans*
