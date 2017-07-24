# Cache Replacement Algorithm
Caches are used to hold objects in memory. A caches size is finite; If the system doesn't have enough memory, the cache must be purged or the program will crash. There is a bunch of [cache replacement algorithm](https://en.wikipedia.org/wiki/Cache_replacement_policies). We will implement 2 most popluar: LRU and LFU.

## LRU Cache

[Least Recently Used][1] (LRU) is a popular algorithm in cache design.

In this implementation of the LRU Cache, a size is declared during instantiation, and any insertions that go beyond the size will purge the least recently used element of the cache. A *priority queue* is used to enforce this behavior.

### The priority queue

The key to the LRU cache is the priority queue. For simplicity, you'll model the queue using a linked list. All interactions with the LRU cache should respect this queue; Calling `get` and `set` should update the priority queue to reflect the most recently accessed element.

#### Interesting tidbits


##### Adding values

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

##### Purging the cache

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

#### Optimizing Performance

Removing elements from the priority queue is a frequent operation for the LRU cache. Since priority queue is modelled using a linked list, this is an expensive operation that costs `O(n)` time. This is the bottleneck for both the `set` and `get` methods.

To help alleviate this problem, a hash table is used to store the references of each node:

```
private var key2node: [KeyType: LinkedList<KeyType>.LinkedListNode<KeyType>] = [:]
```

---

## LFU Cache

(Least Frequently Used)[https://en.wikipedia.org/wiki/Least_frequently_used] (LFU) cache is another popluar cache alogrithm. It's kind of an enhancement on LRU. The key difference between them is LFU considers key's frequency.

It supports operations: `get` and `set` like LRU.

### Solution

The basic idea is the same as LRU. The challenge here is how to add add frequency information for key when `get` and `set`, and evict the key based on it. 

Here is the data structure look like:

```swift
cache: [KeyType: Any] = [:]
priority: [Int: LinkedList<KeyType>] = [:] // Key: Frequency, Val: All Items at this frequency
frequency: [KeyType: Int] = [:] // Key: Item, Val: Frequency
key2node: [KeyType: LinkedList<KeyType>.LinkedListNode<KeyType>] = [:]
```

See an example like this.

```
let cache = LFUCache<Int>(2)
cache.set(1, val: 1)  // 1
cache.set(2, val: 2)  // 2
cache.get(1) // 3
cache.set(3, val: 3) // 4
cache.get(2) // 5
cache.get(3) // 6
cache.set(4, val: 4) // 7
cache.get(1) // 8
cache.get(3) // 9
cache.get(4) // 10
```

Here is step by step to explain how it works.

1) Add `1` into `priority` table

| Frequency | 0    | 1    |
| --------- | ---- | ---- |
| Key 1     | 1    |      |
| Key 2     |      |      |

2) Add `2` into `priority` table

| Frequency | 0    | 1    |
| --------- | ---- | ---- |
| Key 1     | 2    |      |
| Key 2     | 1    |      |

3) Get `1` will increase its priority, so move it to next priority and insert into the head of list. Then return `1`.

| Frequency | 0    | 1    |
| --------- | ---- | ---- |
| Key 1     | 2    | 1    |
| Key 2     |      |      |

4) Since the cache already holds 2 keys, we need to evict the lowest priority key. Will remove the tail of the the lowest prioirty list. Remove `2` and add `3` to the head of priority list `0`

| Frequency | 0              | 1    |
| --------- | -------------- | ---- |
| Key 1     | Evict 2, Add 3 | 1    |
| Key 2     |                |      |

5) `2` has been removed. We miss the cache.

6) Need to increase `3` priority, move it to next priority list and insert it to the head.

| Frequency | 0    | 1    |
| --------- | ---- | ---- |
| Key 1     |      | 3    |
| Key 2     |      | 1    |

7) Cache is full, remove `1`. Insert `4`. 

| Frequency | 0    | 1    |
| --------- | ---- | ---- |
| Key 1     | 4    | 3    |
| Key 2     |      |      |

8) Miss `1`.

9) Move `3` to next priority. And return `3`.

| Frequency | 0    | 1    | 2    |
| --------- | ---- | ---- | ---- |
| Key 1     | 4    |      | 3    |
| Key 2     |      |      |      |

10) Move `4` to next priority. And return `4`.

| Frequency | 0    | 1    | 2    |
| --------- | ---- | ---- | ---- |
| Key 1     |      | 4    | 3    |
| Key 2     |      |      |      |

### Time Complexity

We will focus on the `priority` which is the bottleneck of the algorithm. 
One key action is finding the lowest priority list. If the `priority` is implemented by red-black tree, the key is sorted, it will cost `O(1)`. 
For example, `map` in C++. But in Swift, dictionary is implemented by hash table, so the key is not sorted. We need to get all keys and sort it. 
It will cost `O(nlogn)`. There are 2 ways to improve this.

1) Maintain a min heap at the same time for exist `priority` keys. We can decrease the search time to `O(logn)`. But this increses code complexity.
2) Use `List` structure to replace `Hash Table` here for `priority`. Since when update a key, we either remove it or move it to next priority. 
`List` should be enough.


*Written for the Swift Algorithm Club by Kai Chen, with additions by Kelvin Lau*


[1]:	https://en.wikipedia.org/wiki/Cache_replacement_policies#LRU
