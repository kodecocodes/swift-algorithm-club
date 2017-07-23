# LRU Cache

Caches are used to hold objects in memory. A caches size is finite; If the system doesn't have enough memory, the cache must be purged or the program will crash. [Least Recently Used][1] (LRU) is a popular algorithm in cache design. The idea is simple: In low memory situations, the oldest used member of the cache will be purged. A *priority queue* is used to enforce this behavior.

## The priority queue

The key to the LRU cache is the priority queue. For simplicity, you'll model the queue using a linked list. All interactions with the LRU cache should respect this queue; Calling `get` and `set` should update the priority queue to reflect the most recently accessed element.


### Operations

Each time we access an element, either `set` or `get` we need to insert the element in the head of priority list. The `insert` operation will be look like this.

```swift
private func insert(_ key: KeyType, val: Any) {
	cache[key] = val
	priority.insert(key, atIndex: 0)
	guard let first = priority.first else {
		return
	}
	key2node[key] = first
}
```

Each time, when we `set`, the cache size maybe already full. In this case, we need to `remove` the lowest priority node. The operation is like this.

```swift
private func remove(_ key: KeyType) {
	cache.removeValue(key)
	guard let node = key2node[key] else {
		return
	}
	priority.remove(node)
	key2node.removeValue(key)
}
```

### Optimizing Performance

Removing elements from the priority queue is a frequent operation for the LRU cache. Since priority queue is modelled using a linked list, this is an expensive operation that costs `O(n)` time. This is the bottleneck for both the `set` and `get` methods.

To help alleviate this problem, a hash table is used to store the references of each node:

```
private var key2node: [KeyType: LinkedList<KeyType>.LinkedListNode<KeyType>] = [:]
```

*Written for the Swift Algorithm Club by Kai Chen, with additions by Kelvin Lau*


[1]:	https://en.wikipedia.org/wiki/Cache_replacement_policies#LRU
