# 队列

队列是一个只允许在最后插入元素从最开始移除元素的列表。这就保证了第一个进入到队列的元素同样也是第一个移出的。先进先出！

为什么需要队列呢？在学多算法的实现里经常要将一些数据放到一个临时的列表里，之后再从这个列表里取出这些数据。通常添加和移除数据的顺序是很重要的。

队列是一个 FIFO 的操作顺序。第一个插入的元素也是第一个出来的。这非常公平！（类似的数据结构是[栈](../Stack/README-CN.markdown)，是后进先出的）。

例如，将一个数字假如到队列里：

```swift
queue.enqueue(10)
```

现在队列是 `[ 10 ]`。假如下一个数字到队列里：

```swift
queue.enqueue(3)
```

现在队列是 `[ 10, 3 ]`。再加一个数字:

```swift
queue.enqueue(57)
```

队列现在是 `[ 10, 3, 57 ]`。现在我们要从队列的开头让一个元素出列：

```swift
queue.dequeue()
```

返回的是 `10` 。因为这是我们加入的第一个数字。队列现在是 `[ 3, 57 ]`。剩下的元素都往前移动一个位置。

```swift
queue.dequeue()
```

这回返回的是 `3`, 下一个出列返回的是 `57`, 依此类推. 如果队列空了，出列就会返回 `nil` 或者在一些实现中会给出一个错误信息。

> **注意：** 队列不会总是一个最好的选择。如果元素加入或者离开列表的顺序不重要的话，也可以用[栈](../Stack/README-CN.markdown)来代替队列。栈更简单也更快。

## 代码

下面是一个 Swift 中非常简单的队列的实现。仅仅是对一个数组的封装，只允许入列、出列和获取元素三个操作：

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

这个队列只是能工作但不是最理想的。

入列是一个 **O(1)**的操作，因为在数组的最后插入元素花费的时间是一样的。与数组的大小无关。所以这非常棒。

你可能想知道为什么在数组中加入一个元素是 **O(1)** 或者一个固定时间的操作。这是因为在 Swift 中数组的最后总是有一些空闲的空间，如果我们做下面的操作：

```swift
var queue = Queue<String>()
queue.enqueue("Ada")
queue.enqueue("Steve")
queue.enqueue("Tim")
```

数组实际上可能是这样的：

	[ "Ada", "Steve", "Tim", xxx, xxx, xxx ]

`xxx` 是保留的还没有填充数据的内存。往数组中加入一个元素会重写下一个没有使用的位置：

	[ "Ada", "Steve", "Tim", "Grace", xxx, xxx ]

从内存中的一个地方拷贝数据到另一个地方是一件很简单的事情，是一个固定时间的操作。

当然，在数组的最后只有有限的还没有被使用的地址。当最后的 `xxx` 也被利用了之后再要往数组中添加一个元素，数据就需要调整大小来增加更多的空间。

调整大小包括分配一块新的内存和将原来的数据拷贝到新的数组。这是一个 **O( n )** 的过程，所以它相对来说会慢一些。但既然它是每隔一段时间才发生一次的，往数组的最后添加一个元素的时间还是 **O(1)** 的，或者说是 **O(1)** “分摊的”。

出列又有一些不同。出列是从数组的 *头部* 移除一个元素，而不是尾部。由于它需要将数组中所有的元素都往后移动一个位置，所以它是 **O(n)** 的操作。

在我们的例子中，让元素 `"Ada"` 出列，会将 `"Steve"` 拷贝到 `"Ada"` 的位置，`"Tim"` 拷贝到  `"Steve"`的位置，以及 `"Grace"` 拷贝到 `"Tim"` 的位置：

	before   [ "Ada", "Steve", "Tim", "Grace", xxx, xxx ]
	                   /       /      /
	                  /       /      /
	                 /       /      /
	                /       /      /
	 after   [ "Steve", "Tim", "Grace", xxx, xxx, xxx ]
 
在内存中移动这些元素总是 **O(n)** 操作。在我们简单的队列实现中，入列是高效的，但是出列却有值得想象的地方...

## 一个更高效的队列

为了让出列也更高效，我们可以使用保留一些额外空闲空间的小把戏，但是这次是在数组的前面。我们要自己写这部分代码，因为内置的 Swift 数组没有提供这个的支持。

想法大概是下面这样的：无论什么时候当我们要让一个元素出列时，我们不会移动数组中的元素，而是将这个元素的位置标记为空。让 `"Ada"` 出列之后，数组是这样的：

	[ xxx, "Steve", "Tim", "Grace", xxx, xxx ]

`"Steve"` 出列后, 数组是这样的:

	[ xxx, xxx, "Tim", "Grace", xxx, xxx ]

前面的空的位置不会被重复利用，因为他们是被浪费的。每隔一段时间，我们可以将数组中的元素挪到最开始：

	[ "Tim", "Grace", xxx, xxx, xxx, xxx ]

这个整理过程是与内存切换相关的，它是一个 **O(n)** 的操作。但是因为它是一段时间才发生一次的，出列现在平均是 **O(1)**。

下面是如何实现这个版本的 `Queue`：

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

现在数组存储的元素是 `T?` 而不是 `T`，因为我们需要方法来将数组的元素标记为空。 `head` 变量是数组第一个元素的索引。

大部分的功能都在 `dequeue()`。当出列一个元素时，我们先将 `array[head]` 设为 `nil`来将对象从数组移除。然后我们使 `head`加一，因为现在下一个元素才是数组的第一个元素。

从这里开始

	[ "Ada", "Steve", "Tim", "Grace", xxx, xxx ]
	  head

到这里:

	[ xxx, "Steve", "Tim", "Grace", xxx, xxx ]
	        head

这看起来有点像怪异的超级市场里，在等着结账的人们不往前挪动到收银台，而是收银台往队列的前面走。

当然，我们还没有移除空的位置，这会导致数组随着我们的出列和入列操作会一直增大。为了定时的整理数组，我们要做下面的操作：

```swift
    let percentage = Double(head)/Double(array.count)
    if array.count > 50 && percentage > 0.25 {
      array.removeFirst(head)
      head = 0
    }
```

先计算一下空位置占整个数组大小的一个比例。如果有超过 25% 的空间没有被利用的话，我们就砍掉那些浪费的空间。然而，当数组比较小的时候，我们又不想一直调整数组的大小。因为，只有当数组中的元素超过50的时候我们才会整理它。

> **注意：** 我只是提取了一部分数据——你可能需要根据你的应用的生产环境来做出调整。

在 playground 中测试一下:

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

为了测试调整大小的行为，替换下面的代码：

```swift
    if array.count > 50 && percentage > 0.25 {
```

用：

```swift
    if head > 2 {
```

现在如果你出列另一个对象，数组看起来就会是下面这样：

```swift
q.dequeue()         // "Tim"
q.array             // [{Some "Grace"}]
q.count             // 1
```

数组前面的 `nil` 对象已经被移除了，并且没有了被浪费的空间。新版本的 `Queue` 并不比之前的版本复杂多少，但现在出列是一个 **O(1)** 的操作，仅仅是因为我们更聪明地使用了数组。

## 扩展阅读

还有很多其他的方法可以实现一个队列。代替实现有：[链表](../Linked%20List/README-CN.markdown)， [环形缓冲区](../Ring%20Buffer/README-CN.markdown), 或者 [堆](../Heap/README-CN.markdown)。

队列有很多变种。[双端队列](../Deque/README-CN.markdown)，一个两端都可以进行入队和出队的队列，以及[优先队列](../Priority%20Queue/README-CN.markdown)，“最重要”的元素总是在最开始的有序队列。

*作者：Matthijs Hollemans 译者：Daisy*


