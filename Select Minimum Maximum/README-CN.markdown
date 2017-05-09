# 查找最小值 / 最大值

目标：找到未排序数组中的最大值和最小值。

## 最大值或者最小值

有一个对象数组，通过遍历所有的对象并且一直记录最小/最大值。

### 一个例子

加入我们要找到未排序列表 `[ 8, 3, 9, 4, 6 ]` 的最大值。

取第一个数字，`8`，然后把它当成目前为止的最大元素。

从列表中取下一个数字，`3`，然后将它和现在的最大值做比较，`3` 比 `8` 小，所以最大值 `8` 没有变。

从列表中取下一个数字，`9`，然后将它与现在的最大值做比较，`9` 比 `8` 要大，所以现在 `9` 是最大值。

重复上面的过程直到所有元素都处理完了。

### 代码

下面是 Swift 中的一个简单实现：

```swift
func minimum<T: Comparable>(_ array: [T]) -> T? {
  var array = array
  guard !array.isEmpty else {
    return nil
  }

  var minimum = array.removeFirst()
  for element in array {
    minimum = element < minimum ? element : minimum
  }
  return minimum
}

func maximum<T: Comparable>(_ array: [T]) -> T? {
  var array = array
  guard !array.isEmpty else {
    return nil
  }

  var maximum = array.removeFirst()
  for element in array {
    maximum = element > maximum ? element : maximum
  }
  return maximum
}
```

在 playground 里试试吧：

```swift
let array = [ 8, 3, 9, 4, 6 ]
minimum(array)   // This will return 3
maximum(array)   // This will return 9
```

### Swift 标准库

Swift 库中已经包含了一个 `SequenceType` 的扩展，可以返回系列里的最小/最大元素。

```swift
let array = [ 8, 3, 9, 4, 6 ]
array.minElement()   // This will return 3
array.maxElement()   // This will return 9
```

## 最大值和最小值

为了找到数组中的最大和最小值，同时也要尽量减少对比的次数，我们可以成对的对元素进行对比。

### 例子

加入我们要找出为排序列表 `[ 8, 3, 9, 6, 4 ]` 的最小和最大值。

取第一个数字，`8`，将它同时当做目前为止最小值和最大值。

因为数组里元素的个数是奇数，我们将 `8` 从列表中移除之后就剩下了 `[ 3, 9 ]` 和 `[ 6, 4 ]`。

取列表中的下一对数字，`[ 3, 9 ]`。在这两个数字中，`3` 是更小的一个，所以我们将 `3` 和当前的最小值 `8` 进行比较，然后将 `9` 与当前的最大值 `8` 进行比较。`3` 比 `8` 小，所以现在最小值是 `3`。`9` 比 `8` 大，所以最大值是 `9`。

从列表中选下一对数字，`[ 6, 4 ]`。这里面 `4` 是小的元素，所以将 `4` 和现在最小值 `3` 进行对比，然后将 `6` 和最大值 `9` 进行对比。`4` 比 `3` 大，所以最小值不变. `6` 比 `9` 小，所以最大值不变。

结果就是，最小值是 `3`，最大值是 `9`。

### 代码

下面是 Swift 中的简单实现：

```swift
func minimumMaximum<T: Comparable>(_ array: [T]) -> (minimum: T, maximum: T)? {
  var array = array
  guard !array.isEmpty else {
    return nil
  }

  var minimum = array.first!
  var maximum = array.first!

  let hasOddNumberOfItems = array.count % 2 != 0
  if hasOddNumberOfItems {
    array.removeFirst()
  }

  while !array.isEmpty {
    let pair = (array.removeFirst(), array.removeFirst())
    if pair.0 > pair.1 {
      if pair.0 > maximum {
        maximum = pair.0
      }
      if pair.1 < minimum {
        minimum = pair.1
      }
    } else {
      if pair.1 > maximum {
        maximum = pair.1
      }
      if pair.0 < minimum {
        minimum = pair.0
      }
    }
  }

  return (minimum, maximum)
}
```

在 playground 里试试吧：

```swift
let result = minimumMaximum(array)!
result.minimum   // This will return 3
result.maximum   // This will return 9
```

通过获取成对的元素然后将它们分别于最大值最小值做比较，我们将每两个元素的比较数量降到了3。

## 性能

这个算法的时间复杂度是 **O(n)**。每个数组中的对象都与当前的最小/最大值进行了比较，所以时间是与数组的大小有关的。

*作者 [Chris Pilcher](https://github.com/chris-pilcher) 翻译：Daisy*


