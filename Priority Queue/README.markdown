# Priority Queue

A priority queue is a [queue](../Queue/) where the most important element is always at the front.

The queue can be a *max-priority* queue (largest element first) or a *min-priority* queue (smallest element first).

## Why use a priority queue?

Priority queues are useful for algorithms that need to process a (large) number of items and where you repeatedly need to identify which one is now the biggest or smallest -- or however you define "most important".

Examples of algorithms that can benefit from a priority queue:

- Event-driven simulations. Each event is given a timestamp and you want events to be performed in order of their timestamps. The priority queue makes it easy to find the next event that needs to be simulated.
- Dijkstra's algorithm for graph searching uses a priority queue to calculate the minimum cost.
- [Huffman coding](../Huffman Coding/) for data compression. This algorithm builds up a compression tree. It repeatedly needs to find the two nodes with the smallest frequencies that do not have a parent node yet.
- A* pathfinding for artificial intelligence.
- Lots of other places!

With a regular queue or plain old array you'd need to scan the entire sequence over and over to find the next largest item. A priority queue is optimized for this sort of thing.

## What can you do with a priority queue?

Common operations on a priority queue:

- **Enqueue**: inserts a new element into the queue.
- **Dequeue**: removes and returns the queue's most important element.
- **Find Minimum** or **Find Maximum**: returns the most important element but does not remove it.
- **Change Priority**: for when your algorithm decides that an element has become more important while it's already in the queue.

## How to implement a priority queue

There are different ways to implement priority queues:

- As a [sorted array](../Ordered Array/). The most important item is at the end of the array. Downside: inserting new items is slow because they must be inserted in sorted order.
- As a balanced [binary search tree](../Binary Search Tree/). This is great for making a double-ended priority queue because it implements both "find minimum" and "find maximum" efficiently.
- As a [heap](../Heap/). The heap is a natural data structure for a priority queue. In fact, the two terms are often used as synonyms. A heap is more efficient than a sorted array because a heap only has to be partially sorted. All heap operations are **O(log n)**.

Here's a Swift priority queue based on a heap:

```swift
public struct PriorityQueue<T> {
  fileprivate var heap: Heap<T>

  public init(sort: (T, T) -> Bool) {
    heap = Heap(sort: sort)
  }

  public var isEmpty: Bool {
    return heap.isEmpty
  }

  public var count: Int {
    return heap.count
  }

  public func peek() -> T? {
    return heap.peek()
  }

  public mutating func enqueue(element: T) {
    heap.insert(element)
  }

  public mutating func dequeue() -> T? {
    return heap.remove()
  }

  public mutating func changePriority(index i: Int, value: T) {
    return heap.replace(index: i, value: value)
  }
}
```

As you can see, there's nothing much to it. Making a priority queue is easy if you have a [heap](../Heap/) because a heap *is* pretty much a priority queue.

## See also

[Priority Queue on Wikipedia](https://en.wikipedia.org/wiki/Priority_queue)

*Written for Swift Algorithm Club by Matthijs Hollemans*
