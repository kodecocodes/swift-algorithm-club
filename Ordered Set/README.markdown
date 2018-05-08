# Ordered Set

Let's look into how to implement [Ordered Set](https://developer.apple.com/documentation/foundation/nsorderedset).

Here is the example about how it works

```swift
let s = AppleOrderedSet<Int>()

s.add(1)
s.add(2)
s.add(-1)
s.add(0)
s.insert(4, at: 3)

print(s.all()) // [1, 2, -1, 4, 0]

s.set(-1, at: 0) // We already have -1 in index: 2, so we will do nothing here

print(s.all()) // [1, 2, -1, 4, 0]

s.remove(-1)

print(s.all()) // [1, 2, 4, 0]

print(s.object(at: 1)) // 2

print(s.object(at: 2)) // 4
```

The significant difference is the the array is not sorted. The elements in the array are the same when insert them. Image the array without duplicates and with `O(logn)` or `O(1)` search time.

The idea here is using a data structure to provide `O(1)` or `O(logn)` time complexity, so it's easy to think about hash table.

```swift
var indexOfKey: [T: Int]
var objects: [T]
```

`indexOfKey` is used to track the index of the element. `objects` is array holding elements.

We will go through some key functions details here.

### Add

Update `indexOfKey` and insert element in the end of `objects`

```swift
// O(1)
public func add(_ object: T) {
	guard indexOfKey[object] == nil else {
		return
	}

	objects.append(object)
	indexOfKey[object] = objects.count - 1
}
```

### Insert

Insert in a random place of the array will cost `O(n)` time.

```swift
// O(n)
public func insert(_ object: T, at index: Int) {
	assert(index < objects.count, "Index should be smaller than object count")
	assert(index >= 0, "Index should be bigger than 0")

	guard indexOfKey[object] == nil else {
		return
	}

	objects.insert(object, at: index)
	indexOfKey[object] = index
	for i in index+1..<objects.count {
		indexOfKey[objects[i]] = i
	}
}
```

###  Set

If the `object` already existed in the `OrderedSet`, do nothing. Otherwise, we need to update the `indexOfkey` and `objects`.

```swift
// O(1)
public func set(_ object: T, at index: Int) {
	assert(index < objects.count, "Index should be smaller than object count")
	assert(index >= 0, "Index should be bigger than 0")

	guard indexOfKey[object] == nil else {
		return
	}

	indexOfKey.removeValue(forKey: objects[index])
	indexOfKey[object] = index
	objects[index] = object
}
```

### Remove

Remove element in the array will cost `O(n)`. At the same time, we need to update all elements's index after the removed element.

```swift
// O(n)
public func remove(_ object: T) {
	guard let index = indexOfKey[object] else {
		return 
	}

	indexOfKey.removeValue(forKey: object)
	objects.remove(at: index)
	for i in index..<objects.count {
		indexOfKey[objects[i]] = i
	}
}
```

*Written By Kai Chen*
