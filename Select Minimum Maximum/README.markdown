# 查找最小值 / 最大值

目标：在非排序数组中查找最小值 / 最大值。 

## 最大值 or 最小值

可以通过遍历数组的方式来查找最小/最大的值。

### 举例

比如需要从非排序数组  `[ 8, 3, 9, 4, 6 ]` 中查找最大值。

选第一个值 `8` 作为当前最大值。

然后取数组之后的值 `3` 并与当前的值做对比。 `3` 比 `8` 小，因此最大值保持不变。

继续选后面的值，`9` 比当前值大，因此当前最大值为 `9`。 

重复该过程直到遍历结束。

### 代码

Swift 的简单实现：

```swift
func minimum<T: Comparable>(_ array: [T]) -> T? {
  guard var minimum = array.first else {
    return nil
  }

  for element in array.dropFirst() {
    minimum = element < minimum ? element : minimum
  }
  return minimum
}

func maximum<T: Comparable>(_ array: [T]) -> T? {
  guard var maximum = array.first else {
    return nil
  }

  for element in array.dropFirst() {
    maximum = element > maximum ? element : maximum
  }
  return maximum
}
```

放 Playground中试一下:

```swift
let array = [ 8, 3, 9, 4, 6 ]
minimum(array)   // This will return 3
maximum(array)   // This will return 9
```

### Swift 标准库

Swift 标准库中包含一个 `SequenceType` 的扩展，返回序列中最小值/最大值。

```swift
let array = [ 8, 3, 9, 4, 6 ]
array.minElement()   // This will return 3
array.maxElement()   // This will return 9
```

```swift
let array = [ 8, 3, 9, 4, 6 ]
//swift3
array.min()   // This will return 3
array.max()   // This will return 9
```

## 最大值/最小值

为了同时找到最大值和最小值，可以通过两两比较缩小比较次数。

### 举例

比如需要从非排序数组 `[8, 3, 9, 6, 4]` 中查找最大值和最小值。

取第一个值 `8` 最为当前最大值和当前最小值。

因为数组中有奇数个元素，从数组中移除 `8` 后剩下 `[3, 9]` 和 `[6, 4]`。

取下一组数组`[3, 9]` ， `3` 是最小的与当前最小值 `8` 比较，`9` 与当前最大值 `8` 比。`3` 比 `8` 小，因此当前最小值为 `3` ，`9` 比当前值大因此最大值变成 `9`。

取下一组数字 `[6, 4]`，`4` 更小些， `4` 与当前最小值 `3` 比， `6` 与当前最大值 `9` 比。 因为 `4 > 3` ，因此最小值不变，`6` 比 `9` 小，因此最大值不变。

结果最小值为 `3` 最大值为 `9`。

### 代码

Swift实现:

```swift
func minimumMaximum<T: Comparable>(_ array: [T]) -> (minimum: T, maximum: T)? {
  guard var minimum = array.first else {
    return nil
  }
  var maximum = minimum

  // if 'array' has an odd number of items, let 'minimum' or 'maximum' deal with the leftover
  let start = array.count % 2 // 1 if odd, skipping the first element
  for i in stride(from: start, to: array.count, by: 2) {
    let pair = (array[i], array[i+1])

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

运行如下:

```swift
let result = minimumMaximum(array)!
result.minimum   // This will return 3
result.maximum   // This will return 9
```

通过每一组中比较大小后在运行 `minimum` 和 `maximum`，每两个元素可以少比较 3 次。

## 性能

这些算法的时间复杂度为 **O(n)**. 每个元素都需要运行minimum或者maximum，因此时间与数组的长度成正比。

*作者： [Chris Pilcher](https://github.com/chris-pilcher)，译者：KeithMorning*