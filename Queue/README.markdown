# 队列
> 举个应用的[栗子](https://www.raywenderlich.com/148141/swift-algorithm-club-swift-queue-data-structure)

队列的本质是一个数组，但只能从队尾添加元素，从队首移除元素。这保证了第一个入队的元素总是第一个出队。先到先得！

为什么要这样做呢？在很多算法的实现中，你可能需要将某些对象放到一个临时的列表中，之后再将其取出。通常加入和取出元素的顺序非常重要。

队列可以保证元素存入和取出的顺序是先进先出(first-in first-out, FIFO)的，第一个入队的元素总是第一个出队，公平合理！另外一个非常类似的数据结构是[栈](../Stack/)，它是一个后进先出(last-in, first-out, LIFO)的结构。

举例来说，我们将一个数字入队：

```swift
queue.enqueue(10)
```

队列现在为 `[ 10 ]`。再将下一个数字入队：

```swift
queue.enqueue(3)
```

队列现在为 `[ 10, 3 ]`。再加入一个数字：

```swift
queue.enqueue(57)
```

队列现在为 `[ 10, 3, 57 ]`。现在我们将第一个元素出队：

```swift
queue.dequeue()
```

这条语句返回数字 `10`，因为这是我们入队的第一个元素。队列现在是 `[ 3, 57 ]`。剩下的元素都往前移动一位。

```swift
queue.dequeue()
```

这条语句返回 `3`，下次调用 `dequeue` 将返回 `57`，以此类推。如果队列为空，出队操作将返回 `nil`，在有些实现中，会触发一个错误信息。

> **注意：**队列并不总是最好的选择，如果加入和删除元素的顺序无所谓的话，你可以选择使用[栈](../Stack/)来达到目的。栈更加简单快速。

## 实现代码

下面给出了一个简单粗暴的队列实现。它只是简单地包装了一下自带的数组，并提供了入队(enqueue)、出队(dequeue)和取得队首元素(peek)三个操作：

```swift
public struct Queue<T> {
  fileprivate var array = [T]()

  public var isEmpty: Bool {
    return array.isEmpty
  }
  
  public var count: Int {
    return array.count
  }

  public mutating func enqueue(_ element: T) {
    array.append(element)
  }
  
  public mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }
  
  public var front: T? {
    return array.first
  }
}
```

上面实现的队列只是可以正常工作，但并没有任何的优化。

入队操作的时间复杂度为 **O(1)**，因为在数组的尾部添加元素只需要固定的时间，跟数组的大小无关。很好。

你可能会好奇为什么在数组尾部添加元素的时间复杂度为 **O(1)**，或者说只需要固定的时间。这是因为在 Swift 的内部实现中，数组的尾部总是有一些预设的空间可供使用。如果我们进行如下操作：

```swift
var queue = Queue<String>()
queue.enqueue("Ada")
queue.enqueue("Steve")
queue.enqueue("Tim")
```

则数组可能看起来想下面这样

	[ "Ada", "Steve", "Tim", xxx, xxx, xxx ]

`xxx` 代表已经申请，但还没有使用的内存。在尾部添加一个新的元素就会用到下一块未被使用的内存：

	[ "Ada", "Steve", "Tim", "Grace", xxx, xxx ]

这只是简单的拷贝内存的工作，只需要固定的常量时间。

当然，数组尾部的未使用内存的大小是有限的，如果最后一块未使用内存也被占用的时候，再添加元素会使得数组重新调整大小来获取更多的空间。

重新调整的过程包括申请新的内存，将已有数据迁移到新内存中。这个操作的时间复杂度是 **O(n)**，所以是一个较慢的操作。但考虑到这种情况并不常见，所以，这个操作的时间复杂度依然是 **O(1)** 的，或者说是近似 **O(1)** 的。

但出队操作就有点不一样了。出队操作是将数组头部的元素移除，而不是尾部。这个操作的时间复杂度永远都是 **O(n)**，因为这会导致内存的移位操作。

在我们的例子中，将 `"Ada"` 出队会使得 `"Steve"` 接替 `"Ada"` 的位置；`"Tim"` 接替 `"Steve"` 的位置；`"Grace"` 接替 `"Tim"` 的位置：

	出队前   [ "Ada", "Steve", "Tim", "Grace", xxx, xxx ]
	                   /       /      /
	                  /       /      /
	                 /       /      /
	                /       /      /
	出队后   [ "Steve", "Tim", "Grace", xxx, xxx, xxx ]
 
在内存中移动这些元素的时间复杂度永远都是 **O(n)**，所以我们实现的简单队列对于入队操作的效率是很高的，但对于出队操作的效率却较为低下。

## 更加高效的队列

为了让队列的出队操作更加高效，我们可以使用和入队所用的相同小技巧，保留一些额外的空间，只不过这次是在队首而不是队尾。这次我们需要手动编码实现这个想法，因为 Swift 内建数组并没有提供这种机制。

我们的想法如下：每当我们将一个元素出队，我们不再将剩下的元素向前移位（慢），而是将其标记为空（快）。在将 `"Ada"` 出队后，数组如下：

	[ xxx, "Steve", "Tim", "Grace", xxx, xxx ]

`"Steve"` 出队后，数组如下：

	[ xxx, xxx, "Tim", "Grace", xxx, xxx ]

这些在前端空出来的位子永远都不会再次使用，所以这是些被浪费的空间。解决方法是将剩下的元素往前移动来填补这些空位：

	[ "Tim", "Grace", xxx, xxx, xxx, xxx ]

这就需要移动内存，所以这是一个 **O(n)** 操作，但因为这个操作只是偶尔发生，所以出队操作平均时间复杂度为 **O(1)**

下面给出了改进版的队列的时间方式：

```swift
public struct Queue<T> {
  fileprivate var array = [T?]()
  fileprivate var head = 0
  
  public var isEmpty: Bool {
    return count == 0
  }

  public var count: Int {
    return array.count - head
  }
  
  public mutating func enqueue(_ element: T) {
    array.append(element)
  }
  
  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    let percentage = Double(head)/Double(array.count)
    if array.count > 50 && percentage > 0.25 {
      array.removeFirst(head)
      head = 0
    }
    
    return element
  }
  
  public var front: T? {
    if isEmpty {
      return nil
    } else {
      return array[head]
    }
  }
}
```

现在数组存储的元素类型是 `T?`，而不是先前的 `T`，因为我们需要某种方式来将数组的元素标记为空。`head` 变量用于存储队首元素的下标值。

绝大多数的改进都是针对 `dequeue()` 函数，在将队首元素出队时，我们首先将 `array[head]` 设置为 `nil` 来将这个元素从数组中移除。然后将 `head` 的值加一，使得下一个元素变成新的队首。

数组从这样：

	[ "Ada", "Steve", "Tim", "Grace", xxx, xxx ]
	  head

变成这样：

	[ xxx, "Steve", "Tim", "Grace", xxx, xxx ]
	        head

这就像在某个外星球的奇怪超市，在那里排队结账的人保持不动，而收银员往队尾移动来挨个结账。

当然，如果我们从不移除队首的空位，随着不断地入队和出队，队列所占空间将不断增长。为了周期性地清理无用空间，我们编写了如下代码：

```swift
    let percentage = Double(head)/Double(array.count)
    if array.count > 50 && percentage > 0.25 {
      array.removeFirst(head)
      head = 0
    }
```

这段代码计算了队首空余的元素占数组总元素的百分比，如果空余元素超过 25%，我们就进行一波清理。但是，如果队列的长度过小，我们也不想频繁地清理空间，所以在清理空间之前，队列中至少要有 50 个元素。

> **注意：**这个 50 只是我凭空捏造的一个数字，在实际的项目中，你应该根据项目本身来选定一个合情合理的值。

如果想在 Playground 中测试，可以参考下面的代码：

```swift
var q = Queue<String>()
q.array                   // [] empty array

q.enqueue("Ada")
q.enqueue("Steve")
q.enqueue("Tim")
q.array             // [{Some "Ada"}, {Some "Steve"}, {Some "Tim"}]
q.count             // 3

q.dequeue()         // "Ada"
q.array             // [nil, {Some "Steve"}, {Some "Tim"}]
q.count             // 2

q.dequeue()         // "Steve"
q.array             // [nil, nil, {Some "Tim"}]
q.count             // 1

q.enqueue("Grace")
q.array             // [nil, nil, {Some "Tim"}, {Some "Grace"}]
q.count             // 2
```

为了测试队列的自动调整特性，将下面这段代码：

```swift
    if array.count > 50 && percentage > 0.25 {
```

替换为：

```swift
    if head > 2 {
```

现在，如果你再次执行出队操作，数组将看起来像下面这样：

```swift
q.dequeue()         // "Tim"
q.array             // [{Some "Grace"}]
q.count             // 1
```

在数组前面的 `nil` 已经被移除了，数组本身也没有空间浪费了。新版本的队列实现并没有比初版复杂很多，但现在出队操作的复杂度已经从当初的 **O(n)** 变为了现在的 **O(1)**，只是因为我们在数组的使用策略上耍了一点小心机。

## 扩展阅读

事实上，队列还有很多种其他的实现方式，例如可以使用[链表](../Linked List/)、[环形缓冲区](../Ring Buffer/)或是[堆](../Heap/)来实现。

队列有很多变体，包括[双端队列](../Deque/)，一个两端都可以出队和入队的队列；[优先队列](../Priority Queue/)，一个有序的队列，最重要的元素排在队首。

*作者：Matthijs Hollemans；译者：KSCO*
