# 二分搜索

目标：在数组中快速查找一个元素。

假如有一个数字数组，我们想要看看某个特定的数字是否在数组中，如果有的话，在什么位置。

在大多数情况下，Swift 的 `indexOf()` 方法就足够了：

```swift
let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]

numbers.indexOf(43)  // 返回 15
```

内置的 `indexOf()` 采用的是 [线性搜索](../Linear%20Search/README-CN.md)。用代码表示如下：

```swift
func linearSearch<T: Equatable>(_ a: [T], _ key: T) -> Int? {
    for i in 0 ..< a.count {
        if a[i] == key {
            return i
        }
    }
    return nil
}
```

像下面这样来使用它：

```swift
linearSearch(numbers, 43)  // 返回 15
```

那么问题是什么呢？`linearSearch()` 要从头开始循环整个数组，直到找到要查找的元素。最糟糕的情况下，数组总可能根本不存在这个值，所有的工作都白做了。

平均情况下，线性搜索需要查找数组中一半的元素。如果数组很大的话，这就会变得很慢了！

## 分治法

最经典加速方法是使用*二分搜索*。技巧就是每次都将数组分成两半，直到找到想要的值。

对于一个大小为 `n` 的数组来说，时间复杂度不像线性搜索一样是 **O(n)**，而是 **O(log n)**。对比来看的话，对于一个有 1,000,000 个元素的数组来说，二分搜索只需要大概20步就可以找到想要的元素，因为 `log_2(1,000,000) = 19.9`。对于有一亿个元素的数组，值需要30步（你最后一次使用一亿个元素的数组是什么时候呢？）。

看上去很好，但是二分搜索有一个缺点：数组必须是有序的。在实际中，这通常不是一个问题。

下面是二分搜索如何工作的：

- 将数组分成两半，然后看看你要查找的东西也就是*搜索关键词*是在左边还是在右边。
- 怎么知道搜索关键字是在哪一边呢？这就是为什么数组要是有序的原因，这样我们就可以使用 `<` 或 `>` 符号来比较了。
- 如果搜索关键字在左边，重复上面的过程：将数组分成更小的两部分，然后看搜索关键词在哪边（如果在右边的话也是一样的）。
- 一直重复这个过程，直到找到搜索关键词。如果数组不能在继续分了，那我们就必须很遗憾的得出数组中没有要查找的搜索关键词了这个结论了。

现在你直到它为什么叫做 “二分” 搜索了吧：在每一步中都是将数组分成两半。这个*分治*的过程可以让我们缩小要查找的范围。

## 代码

下面是用 Swift 实现的二分搜索的递归版本：

```swift
func binarySearch<T: Comparable>(_ a: [T], key: T, range: Range<Int>) -> Int? {
    if range.startIndex >= range.endIndex {
        // If we get here, then the search key is not present in the array.
        return nil

    } else {
        // Calculate where to split the array.
        let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2

        // Is the search key in the left half?
        if a[midIndex] > key {
            return binarySearch(a, key: key, range: range.startIndex ..< midIndex)

        // Is the search key in the right half?
        } else if a[midIndex] < key {
            return binarySearch(a, key: key, range: midIndex + 1 ..< range.endIndex)

        // If we get here, then we've found the search key!
        } else {
            return midIndex
        }
    }
}
```

将代码拷贝到 playground 来测试：

```swift
let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]

binarySearch(numbers, key: 43, range: 0 ..< numbers.count)  // 结果是 13
```

`数字` 数组是有序的，否则二分搜索算法是没法正常工作的。

我们前面说到二分搜索是通过把数组分成两半来工作的，但是我们并没有创建两个数组。我们用一个 Swift 中的 `Range` 对象来追踪拆分。开始的时候，范围是`0 ..< numbers.count`，随着拆分的进行，范围越来越小。

> **注意：** 需要注意的一点是，`range.upperBound` 的值总是比最后一个元素大1的位置。在上面的例子中，范围是 `0..<19`，因为数组中有 19 个数字，所以 `range.startIndex = 0`, `range.endIndex = 19`。但是在数组中，数组最后一个元素是在索引 18 的位置，而不是 19，因为我们是从 0 开始算起的。在使用范围的时候要把这个记在心里：`endIndex` 总是比最后一个元素的索引大 1.

## 示例解析

看看算法的细节是很有帮助的。

上面的例子中的数组由 19 个数组组成，看起来就像下面这样，是排好序的：

	[ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67 ]

我们要试着找找看数字 `43` 是不是在数组中。

要将数组分成两半的话，我们需要知道中间的对象的索引。这是由下面的代码来实现的：

```swift
let midIndex = range.startIndex + (range.endIndex - range.startIndex) / 2
```

开始的时候，范围的值是 `startIndex = 0` 和 `endIndex = 19`。填入这些值，我们可以得到 `midIndex` 是 `0 + (19 - 0)/2 = 19/2 = 9`。实际上值是 `9.5`，但是我们只取整数。

在下面的图中，`*` 代表的是中间的元素。就像我们看到的，两边的元素个数是一样的，所以我们就将数组从中间分开了。

	[ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
                                      *

现在二分搜索就要看看要使用哪一半来继续了。相关代码如下所示：

```swift
if a[midIndex] > key {
    // use left half
} else if a[midIndex] < key {
    // use right half
} else {
    return midIndex
}
```

在这总情况下，`a[midIndex] = 29`。这个值比搜索关键词要小，所以我们知道搜索关键词永远不会在左边，毕竟，左边的数组只包含比 `29` 要小的数字。因此，搜索关键词就在右边了（或者根本不在数组里）。

Now we can simply repeat the binary search, but on the array interval from `midIndex + 1` to `range.upperBound`:
现在我们可以重复二分搜索，但是现在数组的搜索范围就变成了从 `midIndex + 1` 到 `range.endIndex`

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43, 47, 53, 59, 61, 67 ]

既然我们不再需要关系左边的元素，我就先将他们标记为 `x` 来。从现在开始我们只要找右边的就可以了，右边的数组是从索引 10 开始的。

我们计算新的中间元素的索引值：`midIndex = 10 + (19 - 10)/2 = 14`，然后再次将数组从中间分开。

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
	                                                 *

从上面可以看到，`a[14]` 现在是右半边的中间元素。

现在搜索关键词是比 `a[14]` 大还是小呢？当然是大了，因为 `43 < 47`。这次我们就要用左边的来继续二分搜索，忽略掉右半边的大数字了：

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43 | x, x, x, x, x ]

新的 `midIndex` 在这：

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43 | x, x, x, x, x ]
	                                     *

搜索关键词比 `37` 要大，所以选择右半边的：

	[ x, x, x, x, x, x, x, x, x, x | x, x | 41, 43 | x, x, x, x, x ]
	                                        *

搜索关键词又一次比中间元素大，再讲数组进行拆分，然后选择右边：

	[ x, x, x, x, x, x, x, x, x, x | x, x | x | 43 | x, x, x, x, x ]
	                                            *

到这里就结束了，搜索关键词与数组元素相等了。我们终于在数组 `13` 的索引位置找到我们要找的数字 `43`。w00t!

看起来做了好多事情，但是实际上它只用了四步就在数组中找到了想要的元素，看起来是对的，因为 `log_2(19) = 4.23`。如果用线性搜索的话，就要 14 步了。

如果我们要找的是 `42` 而不是 `43` 又会发生什么呢？如果是这样的话，我们最后不能将数组再继续进行拆分了，因为 `range.endIndex` 比 `range.startIndex` 要小了。这就告诉我们要找的数字不再数组中，所以它返回 `nil`。

> **注意：** 许多二分搜索的算法实现是用 `midIndex = (startIndex + endIndex) / 2` 来计算中间索引的。这里面有一个非常微小的错误，只会在数组非常大的时候出现，因为 `startIndex + endIndex` 可能会超过最大能表示的整数。这种情况在 64-bit CPU 上绝对不会出现，但是在 32-bit 极其上就会出现了。

## 迭代 vs 递归

二分搜搜天生就是递归的，因为我们将同样的逻辑不停地应用于更小的数组。然而，这就意味我们要将 `binarySearch()` 实现成一个递归函数。用一个简单的循环而不是函数的递归调用将算法转成迭代版本通常来说更高效，

下面是用 Swift 实现的二分搜索的迭代版本：

```swift
func binarySearch<T: Comparable>(_ a: [T], key: T) -> Int? {
    var lowerBound = 0
    var upperBound = a.count
    while lowerBound < upperBound {
        let midIndex = lowerBound + (upperBound - lowerBound) / 2
        if a[midIndex] == key {
            return midIndex
        } else if a[midIndex] < key {
            lowerBound = midIndex + 1
        } else {
            upperBound = midIndex
        }
    }
    return nil
}
```

代码跟递归版本非常像，最主要的区别是使用了 `while` 循环。

在 playground 里试试：

```swift
let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]

binarySearch(numbers, key: 43)  // gives 13
```

## 结束语

数组首先要进行排序会不会是一个问题呢？这就要视情况而定了。要记住的是排序需要花费时间——二分查找加上排序的时间可能比一个线性搜索更慢。二分查找适合的地方只用排序一次而需要进行多次查找的情况。

参考 [Wikipedia](https://en.wikipedia.org/wiki/Binary_search_algorithm).

*作者：Matthijs Hollemans 翻译：Daisy*


