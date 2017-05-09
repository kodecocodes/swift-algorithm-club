# 线性搜索

目标：在数组中找到特定的值。

有一个通用对象数组。线性搜索就是遍历整个数组，将要查找的对象与数组中的每个对象进行比较。如果两个对象相等的话，就停止查找然后返回数组的索引。如果不相等则继续对比下一个对象，只要数组中还有对象的话。

## 例子

假如我们有一个数字数组 `[5, 2, 4, 7]`，我们想知道数组中是否包含数字 `2`。

从数组的第一个数字 `5` 与我们要查找的 `2` 开始对比。它们显然是不相等的，所以我们继续对比下一个元素。

下一个要对比的数字是 `2`，正好与我们要找的数字 `2` 相等。现在我们就可以停止迭代并且返回 1，1 是数字 `2` 在数组中的索引。

## 代码

下面是线性搜索在 Swift 中的简单实现：

```swift
func linearSearch<T: Equatable>(_ array: [T], _ object: T) -> Int? {
  for (index, obj) in array.enumerated() where obj == object {
    return index
  }
  return nil
}
```

在 playground 中测试：

```swift
let array = [5, 2, 4, 7]
linearSearch(array, 2) 	// This will return 1
```

## 性能

线性搜索的时间复杂度是 **O(n)**。它将我们要查找的对象与数组总的每个对象做比较，所以时间是跟数组的大小成比例的。在最差的情况下，需要查找数组中所有的元素。

最好情况下的性能是 **O(1)**，但是这个情况是很少见的。因为它要求我们要找的元素正好是数组的第一个元素。你可能会很幸运，但不部分情况下你不会这么幸运。平均来说，线性搜索需要查找数组一半的元素。

## 参考

[线性搜索 维基百科](https://en.wikipedia.org/wiki/Linear_search)

*作者：[Patrick Balestra](http://www.github.com/BalestraPatrick) 翻译：Daisy*


