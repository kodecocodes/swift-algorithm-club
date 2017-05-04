# Rootish 数组栈

*Rootish 数组栈* 是一个基于浪费最少空间（基于 [高斯的求和技术](https://betterexplained.com/articles/techniques-for-adding-the-numbers-1-to-100/) ）的有序数组。*Rootish 数组栈* 由按数组大小升序排序的固定大小的数组组成。

![Rootish Array Stack Intro](images/RootishArrayStackIntro.png)

一个可变大小的数组持有一些块（固定大小的数组）的引用。块的容量跟它在可变数组中的索引是一样的。块不会像普通的 Swift 数组一样变大/收缩。相反地，当达到了它的容量之后，会创建一个比它稍微大一点的块。当块空了之后，最后一个快就会被释放。在是对 Swift 数组在浪费空间方面的一大改进。

![Rootish Array Stack Intro](images/RootishArrayStackExample.png)

下面你会看到插入/删除操作是如何进行的（和 Swift 中这些操作非常像）。

## 高斯求和技巧

关于著名的数学家 [卡尔·弗里德里希·高斯](https://zh.wikipedia.org/wiki/%E5%8D%A1%E7%88%BE%C2%B7%E5%BC%97%E9%87%8C%E5%BE%B7%E9%87%8C%E5%B8%8C%C2%B7%E9%AB%98%E6%96%AF) 的一个众所周知的传说要追溯到当他在小学的时候。一天，高斯的老师让他的学生从 1 加到 100，他希望这个任务可以让他有时间抽根烟。当小高斯举手说出答案 `5050` 的时候，老是震惊了。这么快？老是怀疑他作弊，但是没有，高斯找到了一个公式来回避手动将 1 加到 100 的问题。他的公式是：

```
sum from 1...n = n * (n + 1) / 2
```
为了理解这个想象的 `n` 块，`x` 代表 `1` 个单位。在这个例子中，假设 `n` 是 `5`：
```
blocks:     [x] [x x] [x x x] [x x x x] [x x x x x]
# of x's:    1    2      3        4          5
```
_Block `1` has 1 `x`, block `2` as 2 `x`s, block `3` has 3 `x`s, etc..._

如果想将所有的块从 `1` 加到 `n`，可以 _一个个_ 地将他们加起来。这样也是可以的，但是对于一个大的块系列来说，这就要花费很长的时间！然而，可以重新摆放块，让它看起来是 _半个金字塔_：

```
# |  blocks
--|-------------
1 |  x
2 |  x x
3 |  x x x
4 |  x x x x
5 |  x x x x x

```
然后我们做一个 _半个金字塔_ 的镜像，然后重新排列图像让它和原来的 _半个金字塔_ 在一个矩形里面：

```
x                  o      x o o o o o
x x              o o      x x o o o o
x x x          o o o  =>  x x x o o o
x x x x      o o o o      x x x x o o
x x x x x  o o o o o      x x x x x o
```
现在我们有 `n` 行 和 `n + 1` 列。 _5 行和 6 列_ 。

我们可以像计算面积一样来计算和！我们继续用 `n` 这个属于来表示宽和高：

```
area of a rectangle = height * width = n * (n + 1)
```

我们只想计算 `x` 的总数，而不是 `o` 的。由于在 `x` 和 `o` 之间有一个 1：1 的关系，所以我们只要将它除以 2 就可以了！

```
area of only x = n * (n + 1) / 2
```
<!-- TODO: Define block and innerBlockIndex -->
哇！一个计算和的非常快速的方法！这个方程式对于导出快速 `块` 和 `内部块索引` 等式是非常有用的。
<!-- TODO: 定义块和内部块索引 -->

## 快速读取/设置

接下来，我们要找到一个有效和准确的方法来访问随机索引的元素。例如，`rootishArrayStack[12]` 指向哪一块索引？需要更多的数学知识来回答这个问题！
如果 `索引` 在某个 `块` 里面的话，确定内部块 `索引` 变得容易了：
```
inner block index = index - block * (block + 1) / 2
```
要知道索引指向哪个快更难一些。元素的数量包括被请求的元素最多是：`index + 1` 个元素。块 `0...block` 中的元素个数是 `(block + 1) * (block + 2) / 2` （由上面的公式推导出来的）。`块` 和 `索引` 之间的关系是：
```
(block + 1) * (block + 2) / 2 >= index + 1
```
也可以写做：
```
(block)^2 + (3 * block) - (2 * index) >= 0
```
利用二次方程我们得到：
```
block = (-3 ± √(9 + 8 * index)) / 2
```
负的块是没有意义的，我们我们用正数根来代替。通常来说，这个的答案不是一个整数，然而，回到我们的不等式，我们想要的最小的块是 `block => (-3 + √(9 + 8 * index)) / 2`。协议不，就是取大于结果的整数：
```
block = ⌈(-3 + √(9 + 8 * index)) / 2⌉
```

现在我们可以算出 `rootishArrayStack[12]` 指向哪里了！首先，我们来看看 `12` 指向哪个块：
```
block = ⌈(-3 + √(9 + 8 * (12))) / 2⌉
block = ⌈(-3 + √105) / 2⌉
block = ⌈(-3 + (10.246950766)) / 2⌉
block = ⌈(7.246950766) / 2⌉
block = ⌈3.623475383⌉
block = 4
```
然后再看看 `12` 指向哪个 `innerBlockIndex`：
```
inner block index = (12) - (4) * ((4) + 1) / 2
inner block index = (12) - (4) * (5) / 2
inner block index = (12) - 10
inner block index = 2
```
因此，`rootishArrayStack[12]` 指向的是索引为 `4` 的块以及内部块索引是 `2` 的元素
![Rootish Array Stack Intro](images/RootishArrayStackExample2.png)

### 有序的发现

使用 `块` 等式，`块` 的个数大概是元素总数的平方根：**O(blocks) = O(√n)**。

# 实现细节

让我们从实例变量和结构体定义开始吧：

```swift
import Darwin

public struct RootishArrayStack<T> {

  fileprivate var blocks = [Array<T?>]()
  fileprivate var internalCount = 0

  public init() { }

  var count: Int {
    return internalCount
  }

  ...

}

```

元素是泛型类型 `T`，所以列表里可以存储任何类型的数据。`块` 是一个可以接受类型为 `T` 的持有固定大小数组的可变大小的数组。

> 固定大小数组接受类型 `T?` 的原因是在元素被移除后，对它们的引用不会被保留。例如：如果移除了最后一个元素，最后的所以必须设置为 nil 以防止在一个不可访问的索引里还将元素保留在内存里。

`internalCount` 是一个内部可变计数器，用来保存元素的个数。`count` 是一个只读变量，返回的是 `internalCount` 的值。在这里引入 `Darwin` 的目的是提供如 `ceil()` 和 `sqrt()` 这样的简单数学计算。

结构体的 `capacity` 是简单的高斯求和技巧：

```swift
var capacity: Int {
  return blocks.count * (blocks.count + 1) / 2
}
```

下一步，看看如何 `get` 和 `set` 元素：

```swift
fileprivate func block(fromIndex: Int) -> Int {
  let block = Int(ceil((-3.0 + sqrt(9.0 + 8.0 * Double(index))) / 2))
  return block
}

fileprivate func innerBlockIndex(fromIndex index: Int, fromBlock block: Int) -> Int {
  return index - block * (block + 1) / 2
}

public subscript(index: Int) -> T {
  get {
    let block = self.block(fromIndex: index)
    let innerBlockIndex = self.innerBlockIndex(fromIndex: index, fromBlock: block)
    return blocks[block][innerBlockIndex]!
  }
  set(newValue) {
    let block = self.block(fromIndex: index)
    let innerBlockIndex = self.innerBlockIndex(fromIndex: index, fromBlock: block)
    blocks[block][innerBlockIndex] = newValue
  }
}
```

`block(fromIndex:)` 和 `innerBlockIndex(fromIndex:, fromBlock:)` 封装了我们前面推导出来的 `block` 和 `inner block index` 等式。`subscript` 可以使用熟悉的 `[index:]` 语法来使用 `get` 和 `set` 访问元素。在 `subscript` 中，`get` 和 `set` 使用的是同样的逻辑：

1. 确定索引指向的块
2. 确定内部块索引
3. `get`/`set` 元素值

接下来看看我们怎么 `growIfNeeded()` 和 `shrinkIfNeeded()`。

```swift
fileprivate mutating func growIfNeeded() {
  if capacity - blocks.count < count + 1 {
    let newArray = [T?](repeating: nil, count: blocks.count + 1)
    blocks.append(newArray)
  }
}

fileprivate mutating func shrinkIfNeeded() {
  if capacity + blocks.count >= count {
    while blocks.count > 0 && (blocks.count - 2) * (blocks.count - 1) / 2 >    count {
      blocks.remove(at: blocks.count - 1)
    }
  }
}
```

如果数据集合会随着大小变大或者变小，我们的结构就要能够适应这种变化。
就像 Swift 的数组一样，当达到容量的阈值的时候，我们就 `grow` 或者 `shrink` 结构的大小。对于 Rootish 数组栈来说，我们想要在倒数第二个块在 `insert` 操作之后如果满了，就 `grou` ，如果最后两个块空了就 `shrink`。

现在就是熟悉的 Swift 数组行为了。

```swift
public mutating func insert(element: T, atIndex index: Int) {
	growIfNeeded()
	internalCount += 1
	var i = count - 1
	while i > index {
		self[i] = self[i - 1]
		i -= 1
	}
	self[index] = element
}

public mutating func append(element: T) {
	insert(element: element, atIndex: count)
}

public mutating func remove(atIndex index: Int) -> T {
	let element = self[index]
	for i in index..<count - 1 {
		self[i] = self[i + 1]
	}
	internalCount -= 1
	makeNil(atIndex: count)
	shrinkIfNeeded()
	return element
}

fileprivate mutating func makeNil(atIndex index: Int) {
  let block = self.block(fromIndex: index)
  let innerBlockIndex = self.innerBlockIndex(fromIndex: index, fromBlock: block)
  blocks[block][innerBlockIndex] = nil
}
```

为了 `insert(element:, atIndex:)`，先要将 `index` 之后的元素都往后挪动一个位置。在腾出空间之后，再用 `subscript` 方法把值填入进去。

`append(element:)` 是 `insert` 到最后的便利方法。

为了 `remove(atIndex:)`，将 `index` 之后的所有元素往前挪动一个位置。当要移除的元素被覆盖之后，将结构里最后的值设为 `nil`。

`makeNil(atIndex:)` 使用和 `subscript` 方法相似的逻辑，只不过它是将特定索引的值设为 `nil` （因为将封装的值设为 nil 是数据结构的用户应该做的）。

> 将可选值设为 `nil` 跟将它的封装值设为 `nil` 是不一样。可选封装值是可选引用里的内嵌类型。这就是说，nil 的封装值实际上是 `.some(.none)`，然而将根引用设置为 `nil` 是 `.none`。为了更好的理解 Swift 的可选，我推荐查看 SebastianBoldt 的文章  [Swift! Optionals?](https://medium.com/ios-os-x-development/swift-optionals-78dafaa53f3#.rvjobhuzs)。

# 性能

* 一个内部计数器用来跟踪结构中元素的个数。`count` 的执行是 **O(1)** 时间。 

* `capacity` 可以通过使用高斯求和的方式来计算，时间是 **O(1)**。

* 既然 `subcript[index:]` 使用 `block` 和 `inner block index` 等式，那么它的执行也是 **O(1)** 的时间，所有的 get 和 set 操作都是 **O(1)**。

* 忽略用在 `grow` 和 `shrink` 的时间，`insert(atIndex:)` 和 `remove(atIndex:)` 操作需要将所有指定索引之外的元素改变位置，所以它是 **O(n)** 的时间。

# 增大和变小的分析

性能分析没有计算 `grow` 和 `shrink` 的花费。与普通 Swift 数组不同的是，`grow` 和 `shrink` 操作不会将所有元素拷贝到一个备用数组里。它们只是按 `块` 的个数来分配或者释放数组。`块` 的个数 是与元素的个数的平方根成比例的。变大和缩小只有 **O(√n)** 的时间。

# 浪费的空间

浪费的空间是相对于 `n` 的未使用的内存数量。Rootish 数组栈不会有超过 2 个空块并且不会少于一个空块。最后两个块是与块的数量成比例的，块的数量又和元素个数的平方根成比例。指向每个块的引用的数量和块的数量是一样的。因此，浪费的空间是与元素的个数相关的， 即 **O(√n)**。


_作者：BenEmdon 翻译：Daisy_

_从 [OpenDataStructures.org](http://opendatastructures.org) 获取帮助_


