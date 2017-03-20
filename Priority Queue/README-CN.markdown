# 优先队列

优先队列是最重要的元素始终在最开始的[队列](../Queue/README-CN.markdown)。

队列可以是 “最大优先级”队列（最大的元素在第一个）或者“最小优先级”队列（最小的元素在第一个）。

## 为什么使用优先队列？

优先队列对于需要经常标识哪个是最大或者最小元素的需要处理大数据量的算法来说是有用的 —— 或者不管你怎么定义“最重要的”。

算法可以从优先队列中获得的好处包括：

- 事件驱动仿真。每个事件都有一个时间戳，你希望事件按照他们的时间戳来执行。优先队列使得找到下一个仿真的事件变得容易。
- 用于图搜索的 Dijkstra 算法使用优先队列来计算最短路径。
- 用于数据压缩的[哈夫曼编码](../Huffman%20Coding/README-CN.markdown)。这个算法是建立一个压缩树。它需要不断地找到两个还没有父节点的两个最不频繁出现的节点。
- 许多其他地方！

对于普通队列或者扁平的老式数组来说，需要扫描整个系列才可以找到最大的元素。优先队列就是用来做这些事情的。

## 可以用优先队列来做什么？

优先队列的常用操作：

- **入列**: 插入一个新的元素到队列中。
- **出列**: 移除并且返回队列中最重要的元素。
- **找到最小值** 或 **找到最大值**: 返回最重要的元素但是不移除它。
- **改变优先级**: 当算法觉得一个已经在队列中的元素变成的更重要的时候。

## 如何实现一个优先队列

有不同的方法可以实现优先队列：

- [有序数组](../Ordered%20Array/README-CN.markdown)。最重要的元素在数组的最后。缺点：插入新元素比较慢，因为它必须以有序的方式插入。
- [二叉搜索树](../Binary%20Search%20Tree/README-CN.markdown)。对于双端优先列表来说是非常好的，因为它对于“找到最小”和“找到最大”同样高效。
- [堆](../Heap/README-CN.markdown)。堆是优先列表最常用的数据结构。事实上，这两个术语通常用作同义词。堆比有序数组更高效的原因是堆是部分有序的。所有的堆操作都是 **O(log n)**。

下面是基于堆的 Swift 中的优先队列的实现：

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

就像你看到，没有什么要做的。如果有一个[堆](../Heap/README-CN.markdown)的话，优先列表是非常简单的，因为堆本身就很像一个优先列表。

## 参考

[优先队列 维基百科](https://en.wikipedia.org/wiki/Priority_queue)

*作者：Matthijs Hollemans 翻译：Daisy*


