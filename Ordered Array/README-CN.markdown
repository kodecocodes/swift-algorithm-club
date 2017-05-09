# 有序数组

这是一个始终由小到大有序的数组。无论什么时候添加元素到数组时候，都将它插入到有序的位置。

有序数组对于想要数据有序时是有用的，相对来说，插入新元素的行为比较少。这样话，这比对整个数组进行排序快多了。然而，如果要经常改变数组的话，用一个普通数组然后手动对它进行排序可能更快。

实现是相当基本的。它只是堆 Swift 内置数组的一个简单封装：

```swift
public struct OrderedArray<T: Comparable> {
  fileprivate var array = [T]()

  public init(array: [T]) {
    self.array = array.sorted()
  }

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var count: Int {
    return array.count
  }

  public subscript(index: Int) -> T {
    return array[index]
  }

  public mutating func removeAtIndex(index: Int) -> T {
    return array.remove(at: index)
  }

  public mutating func removeAll() {
    array.removeAll()
  }
}

extension OrderedArray: CustomStringConvertible {
  public var description: String {
    return array.description
  }
}
```

就像你看到的，所有这些方法都是简单地调用了 `array` 变量的对应方法。

剩下的就是 `insert()` 方法了。下面是一个初始尝试：

```swift
  public mutating func insert(_ newElement: T) -> Int {
    let i = findInsertionPoint(newElement)
    array.insert(newElement, at: i)
    return i
  }

  private func findInsertionPoint(_ newElement: T) -> Int {
    for i in 0..<array.count {
      if newElement <= array[i] {
        return i
      }
    }
    return array.count  // insert at the end
  }
```

辅助方法 `findInsertionPoint()` 简单的遍历整个数组，查找要插入新元素的正确地方。

> **注意：** 非常方便地，`array.insert(... atIndex: array.count)` 将新对象放到数组的最后，所以如果没有找到合适的插入位置的话，只要简单的返回 `array.count` 作为索引就可以了。

下面是如何在 playground 中测试它：

```swift
var a = OrderedArray<Int>(array: [5, 1, 3, 9, 7, -1])
a              // [-1, 1, 3, 5, 7, 9]

a.insert(4)    // inserted at index 3
a              // [-1, 1, 3, 4, 5, 7, 9]

a.insert(-2)   // inserted at index 0
a.insert(10)   // inserted at index 8
a              // [-2, -1, 1, 3, 4, 5, 7, 9, 10]
```

不管什么时候，数组的内容时钟都是从低到高排好序的。

不幸的是，现在的 `findInsertionPoint()` 方法有点慢。在最坏的情况下，它需要扫描整个数组。我们可以通过 [二分搜索](../Binary%20Search/README-CN.markdown) 来让找到插入点变得更快。

下面是新的版本：

```swift
  private func findInsertionPoint(_ newElement: T) -> Int {
    var startIndex = 0
    var endIndex = array.count

    while startIndex < endIndex {
        let midIndex = startIndex + (endIndex - startIndex) / 2
        if array[midIndex] == newElement {
            return midIndex
        } else if array[midIndex] < newElement {
            startIndex = midIndex + 1
        } else {
            endIndex = midIndex
        }
    }
    return startIndex
  }
```

与普通的二分搜索最大的不同的是，当没有找到的时候，这里不会返回 `nil`，而是元素所在的索引。这就是我们要插入新对象的地方。

使用二分搜索并不会改变最差时的 `insert()` 的时间复杂度。二分搜索本身只要 **O(log n)** 的时间，但是在数组中间插入新对象依然需要内存中剩下的元素改变位置。所以，总体来说，时间复杂度还是 **O(n)**。但是，在实际中，新版本的绝对要更快，尤其是大数组的时候。

*作者：Matthijs Hollemans 翻译：Daisy*


