# 环形缓冲区

也叫做圆形缓冲区。

[基于数组的队列](../Queue/README-CN.markdown) 的问题是在队尾添加元素是快的，**O(1)**，但是从队头出列是慢的，**O(n)**。移除之所以慢是因为它要求剩下的元素在内存中要移动位置。

实现队列的一个更高效的方法是用环形缓冲区或者圆形缓冲区。从概念上来说这是一个绕回到开始的数组，所以根本不需要移除元素，所欲的操作都是 **O(1)**。

下面是它如何工作的规则。有一个固定大小的数组，假如是 5 个元素：

	[    ,    ,    ,    ,     ]
	 r
	 w

开始的时候，数组是空的，读 (`r`) 和写 (`w`) 指针都指向开始。

让我们来添加一些数据到这个数组中吧。我们会写，或者 “入列” 数字 `123`：
	[ 123,    ,    ,    ,     ]
	  r
	  ---> w

每次我们添加数据，写指针就向前挪动一步。再添加一些元素：

	[ 123, 456, 789, 666,     ]
	  r    
	       -------------> w

现在数组中还剩一个空位，但是在入列之前我们决定读取一些数据出来。因为写指针在读指针的前面，所以这是可能的，也就是说数据是可以读的。当我们读取可用数据的时候，写指针会提前：

	[ 123, 456, 789, 666,     ]
	  ---> r              w

再读两个数据：

	[ 123, 456, 789, 666,     ]
	       --------> r    w

现在应用决定再写入两个数据，`333` 和 `555`：

	[ 123, 456, 789, 666, 333 ]
	                 r    ---> w

哎哟，写指针已经到了数组的结尾了，所以没有空间写入 `555` 了。现在该怎么办呢？好吧，这就是为什么它是环形缓冲区：我们将写指针绕回到开始然后写入剩下的数据：

	[ 555, 456, 789, 666, 333 ]
	  ---> w         r        

现在我们可以读剩下的三个数据：`666`, `333`, 和 `555`。

	[ 555, 456, 789, 666, 333 ]
	       w         --------> r        

当然，当读指针到达缓冲区结尾的时候，它也会绕回去：

	[ 555, 456, 789, 666, 333 ]
	       w            
	  ---> r

现在缓冲区已经空了，因为读指针和写指针重合到一起了。

下面是 Swift 中一个基本实现：

```swift
public struct RingBuffer<T> {
  fileprivate var array: [T?]
  fileprivate var readIndex = 0
  fileprivate var writeIndex = 0

  public init(count: Int) {
    array = [T?](repeating: nil, count: count)
  }

  public mutating func write(_ element: T) -> Bool {
    if !isFull {
      array[writeIndex % array.count] = element
      writeIndex += 1
      return true
    } else {
      return false
    }
  }

  public mutating func read() -> T? {
    if !isEmpty {
      let element = array[readIndex % array.count]
      readIndex += 1
      return element
    } else {
      return nil
    }
  }

  fileprivate var availableSpaceForReading: Int {
    return writeIndex - readIndex
  }

  public var isEmpty: Bool {
    return availableSpaceForReading == 0
  }

  fileprivate var availableSpaceForWriting: Int {
    return array.count - availableSpaceForReading
  }

  public var isFull: Bool {
    return availableSpaceForWriting == 0
  }
}
```

`RingBuffer` 对象有一个数组用来实际存储数据，以及 `readIndex` 和 `writeIndex` 变量作为指向数组的 “指针”。`write()` 函数将元素放到 `writeIndex` 所在的位置，`read()` 函数返回 `readIndex` 位置的元素。

但是等等，绕回是怎么工作的呢？有许多方法可以达到这个目的，我选择了一个稍微有争议的。在这个实现中，`writeIndex` 和 `readIndex` 始终是增加的，实际上不会绕回来。相反的，我们用下面的方法来找到数据中的实际索引：

```swift
array[writeIndex % array.count]
```

和

```swift
array[readIndex % array.count]
```

换句话说，就是取读索引和写索引和数组大小的余数。

有争议的原因是 `writeIndex` 和 `readIndex` 总是增肌的，所以理论上来说它们会变得越来越大超出了整数的范围，然后应用就会崩溃。然而，一个快速简单的计算就可以带走这些恐惧。

`writeIndex` 和 `readIndex` 都是 64 位整数。假设它一秒钟增加 1000 此，这已经很多了，然后一直这样做一年的时间，需要 `ceil(log_2(365 * 24 * 60 * 60 * 1000)) = 35` 位。还有 28 位剩余，所以还有 2^28 年来遇到这个问题。这是一个很长的时间。:-)

为了使用环形缓冲区，将代码拷贝到 playground 然后模仿上面的例子：

```swift
var buffer = RingBuffer<Int>(count: 5)

buffer.write(123)
buffer.write(456)
buffer.write(789)
buffer.write(666)

buffer.read()   // 123
buffer.read()   // 456
buffer.read()   // 789

buffer.write(333)
buffer.write(555)

buffer.read()   // 666
buffer.read()   // 333
buffer.read()   // 555
buffer.read()   // nil
```

你已经看到了一个环形缓冲区是一个最优的队列，但是它也有缺点：这个实现使得调整队列的大小变得艰难。但是如果一个固定大小的队列能满足你的目的，那就是美好的。

环形缓冲区对于数据生产者以和数据消费者读取不一样的频率往里写入数据也是非常有用的。这经常发生在文件或者网络 I/O里。环形缓冲区也是一个高优先级线程（例如音频处理回调）和系统其他比较慢的部分之间通信的首选方法。

这里的实现不是线程安全的。它只是展示了环形缓冲区是如何工作的。也就是说，通过使用 `OSAtomicIncrement64()` 这种非常简单直接的方式来让单个读者和写手在改变读和写的指针时是线程安全的。

弄一个非常快的环形缓冲区的一个诀窍就是使用操作系统的虚拟内存系统来对应到不同的内存页中。很疯狂但是如果想要在高性能环境中使用环形缓冲区的话值得试试。

*作者：Matthijs Hollemans 翻译：Daisy*


