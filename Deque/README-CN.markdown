# 双端队列

双端队列。由于一些原因也发音为 “deck”。

普通的[队列](../Queue/README-CN.markdown)是在最后添加元素，从开头移除元素，双端队列可以在开头入列，从结尾入列并且两端都可以查看。

下面是 Swift 中非常基本的双端队列实现：

```swift
public struct Deque<T> {
  private var array = [T]()
  
  public var isEmpty: Bool {
    return array.isEmpty
  }
  
  public var count: Int {
    return array.count
  }
  
  public mutating func enqueue(_ element: T) {
    array.append(element)
  }
  
  public mutating func enqueueFront(_ element: T) {
    array.insert(element, atIndex: 0)
  }
  
  public mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }
  
  public mutating func dequeueBack() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeLast()
    }
  }
  
  public func peekFront() -> T? {
    return array.first
  }
  
  public func peekBack() -> T? {
    return array.last
  }
}
```

内部使用了一个数组。入列和出列就是简单的从数组的开头和结尾添加和移除元素。

在 playground 中如何使用的例子：

```swift
var deque = Deque<Int>()
deque.enqueue(1)
deque.enqueue(2)
deque.enqueue(3)
deque.enqueue(4)

deque.dequeue()       // 1
deque.dequeueBack()   // 4

deque.enqueueFront(5)
deque.dequeue()       // 5
```

这个双端队列的特殊实现很简单但是不高效。一些操作是 **O(n)**，尤其是 `enqueueFront()` 和 `dequeue()`。把它包括进来指示为了展示双端队列的规则。

## 一个更高效的版本
  
`dequeue()` 和 `enqueueFront()` 是 **O(n)** 的原因是他们是在数组的开头进行操作的。如果从数组的开头移除一个元素，那么剩下的所有元素都要移动一个位置。

假设双端数组包含下面的元素：

	[ 1, 2, 3, 4 ]

然后 `dequeue()` 会从数组里移除 `1` ，`2` 、`3` 和 `4` 会往前挪动一个位置：

	[ 2, 3, 4 ]

这是一个 **O(n)** 操作，因为所有的数组元素需要在内存中移动一个位置。

同样的，在数组的开头插入一个元素也是昂贵的，因为它要求所有其他元素要往后挪动一个位置。所以 `enqueueFront(5)` 会将数组变成：

	[ 5, 2, 3, 4 ]

首先，元素 `2` 、`3` 和 `4` 会在内存中往后挪动一个位置，然后新的元素 `5` 会插入到原来 `2` 所在的位置。

为什么在 `enqueue()` 和 `dequeueBack()` 中这就不是问题了呢？这些操作是在数组的尾部进行的操作。Swift 中可变大小数组的实现是通过在后面保留一些空间来实现的。

我们的初始数组是 `[ 1, 2, 3, 4]`，但在内存中实际上是这样的：

	[ 1, 2, 3, 4, x, x, x ]

`x` 表示的是数组中还未被使用的额外空间。调用 `enqueue(6)` 指示简单的将新的元素拷贝到下个未使用的点：

	[ 1, 2, 3, 4, 6, x, x ]

 `dequeueBack()` 函数用 `array.removeLast()` 来删除元素。这不需要收缩数组的内存，而只是将 `array.count` 的值减 1。这里没有涉及到昂贵的内存拷贝。所以在数组的最后进行的操作是很快的，**O(1)**。

数组最后的可用空间是可能被用完的。这样的话，Swift 会重新分配一块内存，比原来的数组大并且将所有的数据拷贝过去。这是一个 **O(n)** 的操作，但是因为它是一段时间才发生一次的，所以在数组的最后添加元素平均下来依然是 **O(1)**。

当然，我们可以在数组的 `开始` 用一些小技巧。这会使得我们的双端队列在队列的开头做操作也更高效。我们的数组是这样的：

	[ x, x, x, 1, 2, 3, 4, x, x, x ]

在数组的开头也有一块未使用的空间，这就是在队列的开头添加和移除元素也变成 **O(1)** 的了。

下面是新版本的 `Deque`：

```swift
public struct Deque<T> {
  private var array: [T?]
  private var head: Int
  private var capacity: Int
  private let originalCapacity:Int
  
  public init(_ capacity: Int = 10) {
    self.capacity = max(capacity, 1)
    originalCapacity = self.capacity
    array = [T?](repeating: nil, count: capacity)
    head = capacity
  }
  
  public var isEmpty: Bool {
    return count == 0
  }
  
  public var count: Int {
    return array.count - head
  }
  
  public mutating func enqueue(_ element: T) {
    array.append(element)
  }
  
  public mutating func enqueueFront(_ element: T) {
    // this is explained below
  }

  public mutating func dequeue() -> T? {
    // this is explained below
  }

  public mutating func dequeueBack() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeLast()
    }
  }
  
  public func peekFront() -> T? {
    if isEmpty {
      return nil
    } else {
      return array[head]
    }
  }
  
  public func peekBack() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.last!
    }
  }  
}
```

看起来大部分还是一样的 —— `enqueue()` 和 `dequeueBack()` 没有改变 —— 但是还是有一些重要的不同。现在数组存储的元素是 `T?` 而不是 `T` 了，因为我们需要有方法能让数组元素变成空。

`init` 方法分配了一个新的数组包含的都是 `nil` 的值。这就是在数组开头我们有的能用的空间，默认创建了 10 个空的点。

`head` 变量是数组的第一个元素开始的索引。因为现在数组是空的，`head` 指向的是超出数组之外的索引。

	[ x, x, x, x, x, x, x, x, x, x ]
	                                 |
	                                 head

为了在对头入列，将 `head` 移到左边的位置，然后将新的对象拷贝到索引 `head` 。例如，`enqueueFront(5)` 的结果是：

	[ x, x, x, x, x, x, x, x, x, 5 ]
	                             |
	                             head

接下来是 `enqueueFront(7)`:

	[ x, x, x, x, x, x, x, x, 7, 5 ]
	                          |
	                          head

等等...head 一直往左边挪动并且始终指向队列的第一个元素。`enqueueFront()` 现在是 **O(1)**，因为它只涉及到拷贝一个值到数组里，一个固定时间的操作。

下面是代码：

```swift
  public mutating func enqueueFront(element: T) {
    head -= 1
    array[head] = element
  }
```

在队列的尾部添加元素还是没有变化（跟之前是一样的代码）。例如，`enqueue(1)` 的结果是：

	[ x, x, x, x, x, x, x, x, 7, 5, 1, x, x, x, x, x, x, x, x, x ]
	                          |
	                          head

注意数组是如何改变自己的大小的。没有空间来添加 `1` 了，所以 Swift 决定让数组变大一点，然后在后面增加一些空的位置。如果在入列另一个元素，它会添加到下一个空的点上。例如，`enqueue(2)`：

	[ x, x, x, x, x, x, x, x, 7, 5, 1, 2, x, x, x, x, x, x, x, x ]
	                          |
	                          head

> **注意：** 当你 `print(deque.array)` 的时候，在数组的最后是不看不到这些空的点位的。这是因为 Swift 对你隐藏了这些。只有数组的前面部分会被显示。

`dequeue()` 方法正好与 `enqueueFront()` 相反，它从 `head` 读取值，将数组的元素设置回 `nil`，然后将 `head` 往右边挪动一位：

```swift
  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    return element
  }
```

还有一个小小的问题...如果在前面入列了好多西乡，就会将前面空余的点位都用惯。如果这个是发生在数组的最后的话，Swift 会自动调整数组的大小。但是在数组的前面的，就需要自己手动处理这种情况，在 `enqueueFront()` 中还有一些额外的逻辑：

```swift
  public mutating func enqueueFront(element: T) {
    if head == 0 {
      capacity *= 2
      let emptySpace = [T?](repeating: nil, count: capacity)
      array.insert(contentsOf: emptySpace, at: 0)
      head = capacity
    }

    head -= 1
    array[head] = element
  }
```
 
如果 `head` 为 0，前面就没有剩余空间了。发生这个的时候，我们就在数组的前面添加一堆 nil 的新元素。这是一个 **O(n)** 的操作，但是因为这个被分散到了所有的 `enqueueFront()` 里面，每个单独的 `enqueueFront()` 平均还是 **O(1)** 的。

> **注意：** 每次发生这个的时候我们都是讲容量乘以 2，所以如果队列变得越来越大的时候，调整大小会变得越来越不频繁。这也是 Swift 数组在最后自动做的。

我们还要做一些类似 `dequeue()` 的事情。如果大部分时候都是在最后入列，从开头出列，那么有可能使数组变成下面这样：

	[ x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, 1, 2, 3 ]
	                                                              |
	                                                              head

这些开头的空余点只有在调用 `enqueueFront()` 的时候才会被使用。但是如果在开头入列发生的很少的时候，会留一下一堆浪费的空间。所以我们添加一些代码到 `dequeue()` 来清理这个：

```swift
  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    if capacity >= originalCapacity && head >= capacity*2 {
      let amountToRemove = capacity + capacity/2
      array.removeFirst(amountToRemove)
      head -= amountToRemove
      capacity /= 2
    }
    return element
  }
```

回忆一下 `capacity` 是一开始的时候队列中的空闲空间的数量。如果 `head` 已经到了比两倍空间还要往右的地方，那么就是清理剩余空位的时候了。我们将它大概减少到 25%。

> **注意：** 双端队列会至少保留原始的容量来对比 `capacity` 和 `originalCapacity`。

例如：

	[ x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, 1, 2, 3 ]
	                                |                             |
	                                capacity                      head

在清理之后：

	[ x, x, x, x, x, 1, 2, 3 ]
	                 |
	                 head
	                 capacity

这样的方式可以让我们保持在开头快速入列和出列以及合理的内存要求的平衡。

> **注意：** 不会再非常小的数组里做清理。指示为了省几个字节做这个的话不值得。

## 参考

其实实现双端队列的方式是使用 [双向链表](../Linked%20List/README-CN.markdown)、[循环缓冲区](../Ring%20Buffer/README-CN.markdown) 或者 指向两个方向的 [栈](../Stack/README-CN.markdown)。

[Swift 中完成功能实现的双端列表](https://github.com/lorentey/Deque)

*作者：Matthijs Hollemans 翻译：Daisy*


