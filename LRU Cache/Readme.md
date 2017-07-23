# LRU Cache

Caches are used to hold objects in memory. A caches size is finite; If the system doesn't have enough memory, the cache must be purged or the program will crash. [Least Recently Used][1] (LRU) is a popular algorithm in cache design.

In this implementation of the LRU Cache, a size is declared during instantiation, and any insertions that go beyond the size will purge the least recently used element of the cache. A *priority queue* is used to enforce this behavior.

## The priority queue

The key to the LRU cache is the priority queue. For simplicity, you'll model the queue using a linked list. All interactions with the LRU cache should respect this queue; Calling `get` and `set` should update the priority queue to reflect the most recently accessed element.

### Interesting tidbits


#### Adding values

Each time we access an element, either `set` or `get` we need to insert the element in the head of priority list. We use a helper method to handle this procedure:

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

#### Purging the cache

When the cache is full, a purge must take place starting with the least recently used element. In this case, we need to `remove` the lowest priority node. The operation is like this:

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
