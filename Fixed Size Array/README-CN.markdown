# 固定大小的数组

早期的编程语言没有非常花哨的数组。必须指定一个大小来创建数组，从创建的那时起，数组不会变大也不会变小。即使是 C 和 Objective-C 里的标准数组也是这种类型的。

当这样定一个一个数组的时候，

	int myArray[10];

编译器分配一块连续的能存饭 40 个字节的内存（假设 `int` 是 4 个字节）：

![An array with room for 10 elements](Images/array.png)

这就是你得数组。它会一直是这个大小。如果想要再多增加 10 个元素的话，你就没那么幸运了...没有空间给它了。

当数组慢了之后想要让数组变大就要用 [动态数组](https://en.wikipedia.org/wiki/Dynamic_array) 对象，例如 Objectvie-C 里的 `NSMutableArray` 或者 C++ 里的 `std:vector`，或者其他类似 Swift 的数组可以在需要的时候变大的语言。

古老风格的数组的一个主要缺点就是要足够大，否则就会没有空间。但是如果太大的话又会浪费空间。并且你要小心由于缓冲区溢出造成的安全漏洞和崩溃。总的来说，固定大小的数组不够灵活，它没有为错误留出空间。

那些说 **我喜欢固定大小的数组** 是因为他们简单，速度快并且可预测。

下面是一些数组的典型操作：

- 添加一个元素
- 在开始或者中间的某个地方插入一个元素
- 删除一个元素
- 通过索引查找元素
- 计算数组的大小

对于一个固定大小的数组来说，只要数组还没有满，添加一个元素是很容易的：

![Appending a new element](Images/append.png)

通过索引查找元素也非常快和方便：

![Indexing the array](Images/indexing.png)

这两个操作的复杂度都是 **O(1)**，意味着执行这个操作的时间跟数组的大小无关。

对于一个可以变大的数组来说，添加一个元素更复杂：如果数组满了，必须要分配一块新的内存，老的内容要拷贝到新内存上。平均来说，添加元素还是 **O(1)**，但是底下会发生什么是不可预测的。

费时的操作是插入和删除。当不是在结尾处插入元素的时候，需要将后面的元素往后挪动一个位置。这就设计到了一个相对耗时的内存拷贝操作。例如，在数组的中间插入 `7`：

![Insert requires a memory copy](Images/insert.png)

如果代码正在使用插入点之外的索引来访问数组的话，这些索引现在指向了错误的对象。

删除需要相反的拷贝操作：

![Delete also requires a memory copy](Images/delete.png)

顺便说一下，这个也适用于 `NSMutableArray` 或者 Swift 数组。插入和删除是 **O(n)** 的操作 —— 数组越大花费的时间也越多。

固定大小的数组对于下面这些情况来说是一个好的选择：

1. 提前知道了最大的元素数量。在游戏中这就是同时可以激活的精灵的数量。没有理由不限制这个（对于游戏来说，提前分配所有对象的内存是一个好主意）。
2. 不需要有序数组的时候，例如，元素的顺序不重要。

如果数组不需要有序，那么`insertAt(index)` 操作是不必要的。可以简单的将元素放到最后即可，直到数组满了。

添加元素的代码就变成了：

```swift
func append(_ newElement: T) {
  if count < maxSize {
    array[count] = newElement
    count += 1
  }
}
```

`count` 变量用来跟踪数组的大小，它就是最后一个元素的后一个索引。这就是要插入的元素的索引。

要知道数组中元素的多少只要读取 `count` 变量的值即可，它是 **O(1)** 的操作。

删除元素的代码也同样的变简单了：

```swift
func removeAt(index: Int) {
  count -= 1
  array[index] = array[count]
}
```

将最后一个元素拷贝到要移除的元素的位置，然后减少数组的大小。

![Deleting just means copying one element](Images/delete-no-copy.png)

这就是为什么数组不能有序的原因。为了避免拷贝大部分数组内容，我们只拷贝一个元素，但是这就改变了元素的顺序。

现在数组中有两个元素 `6` 的拷贝了，但很明显的是最后一个元素已经不是数组的一部分了。它只是垃圾数据 —— 下一次添加新元素的时候，这个 `6` 就会被覆盖。

在这两个限制之下 —— 限制元素的个数和数组无序 —— 固定大小的数组在现代软件中依然是非常适用的。

下面是 Swift 中的实现：

```swift
struct FixedSizeArray<T> {
  private var maxSize: Int
  private var defaultValue: T
  private var array: [T]
  private (set) var count = 0
  
  init(maxSize: Int, defaultValue: T) {
    self.maxSize = maxSize
    self.defaultValue = defaultValue
    self.array = [T](repeating: defaultValue, count: maxSize)
  }
  
  subscript(index: Int) -> T {
    assert(index >= 0)
    assert(index < count)
    return array[index]
  }
  
  mutating func append(_ newElement: T) {
    assert(count < maxSize)
    array[count] = newElement
    count += 1
  }
  
  mutating func removeAt(index: Int) -> T {
    assert(index >= 0)
    assert(index < count)
    count -= 1
    let result = array[index]
    array[index] = array[count]
    array[count] = defaultValue
    return result
  }
  
  mutating func removeAll() {
    for i in 0..<count {
      array[i] = defaultValue
    }
    count = 0
  }
}
```

当创建数组的时候，指定一个最大大小和默认值：

```swift
var a = FixedSizeArray(maxSize: 10, defaultValue: 0)
```

`removeAt(index: Int)` 用默认值覆盖最后元素的办法来清除留下的“垃圾”对象。通常来说，在数组中留下重复的对象并没有什么关系，但如果它是一个类或者结构体的时候，它可能有其他对象的强引用，将它们设置为 0 是一个好的童子军行为。

*作者：Matthijs Hollemans 翻译：Daisy*


