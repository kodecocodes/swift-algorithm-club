# 二分查找

目标：在数组中快速找到目标

比如，你想知道数组中有没有这个数字，如果存在，它的下标值是多少。
在大多数情况下，我们可以使用 Swift 的 `indexOf()` 函数：

```swift
let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]

numbers.indexOf(43)  // returns 15
```

SWift 自带的 `indexOf()` 函数用的是[线性查找](../Linear%20Search/). 代码如下：

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

调用一下看看:

```swift
linearSearch(numbers, 43)  // returns 15
```
那么问题来了， `linearSearch()` 从数组头开始遍历直到它找到你要的数字。在最坏的情况下，这个值可能不在数组里，以上的工作都没有意义。

平均情况下，线性搜索算法需要遍历一半的数组，当数组非常大时这个算法会变的非常慢。

## 分而治之

一般的方式是通过 *二分查找* 来加快速度。做法是持续不断的把一个数组分成两部分直到这个值被找到。

`n`个元素的数组使用二分查找的时间复杂度是 **O(log n)** 而不是 **O(n)**。 那么差距到底是多少呢？ 二分查找一个 1,000,000 大的数组只需要 20 步，因为 `log_2(1,000,000) = 19.9 `。 查找一个十亿大数组也只需要 30 步。（想一下你最后一次用数组是十亿大的吗？）

嗯听起来不错，但是使用二分查找有一个前提，那就是数组必须排序。实际上这也不是个问题。

二分查找到底是如何工作的呢？

- 把数组分成两半，根据查找对象的 *搜索值* 查看是在左半部分还是右半部分。
- 如何决定搜索值是在那边？ 这就是为什么要先进行数组排序，这样才能做一个简单的比较。
- 如果搜索值是在左半部分，继续重复操作，把左边再分成两小块，在查看搜索值是在哪边。（在右边也是一样的）
- 一直重复直到搜索值找到，如果数组最后无法再继续分割，那么只能遗憾的告诉你没有找到搜索值。

Now you know why it's called a "binary" search: in every step it splits the array into two halves. This process of *divide-and-conquer* is what allows it to quickly narrow down where the search key must be.

现在你知道为什么叫 **二分** 查找了吧。每步需要把数组分成两半。**分而治之** 的过程就是快速缩小搜索值的范围。

## 代码实现

下面是一个递归版的二分查找：

```swift
func binarySearch<T: Comparable>(_ a: [T], key: T, range: Range<Int>) -> Int? {
    if range.lowerBound >= range.upperBound {
        // If we get here, then the search key is not present in the array.
        return nil

    } else {
        // Calculate where to split the array.
        let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2

        // Is the search key in the left half?
        if a[midIndex] > key {
            return binarySearch(a, key: key, range: range.lowerBound ..< midIndex)

        // Is the search key in the right half?
        } else if a[midIndex] < key {
            return binarySearch(a, key: key, range: midIndex + 1 ..< range.upperBound)

        // If we get here, then we've found the search key!
        } else {
            return midIndex
        }
    }
}
```

复制代码到Playground中玩一下看看：

```swift
let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]

binarySearch(numbers, key: 43, range: 0 ..< numbers.count)  // gives 13
```
注意 `数字` 数组是排序过，否则二分查找将无法适用。

本文谈到二分查找需要把数组分成两半，但是我们并不需要创建两个数组，使用 Swift 的 `Range` 对象来实现跟踪分组，最开始 `range` 对象涵盖全部数组，用 `0 ..< numbers.count ` 表示， 随着数组二分查找， `range` 对象变的越来越小。

>  **注意**：`range.upperBound` 总是指向数组最后一位下标+1的值，比如当 range 为 `0..<19` 时，因为共有19位数字在数组中，所以`range.lowerBound = 0`，`range.upperBound = 19`。但是在上面的数组中最后一位的下标是18，并不是19，因为是从0开始的。所以请记住当使用 `range` 的时候， `upperBound` 最是比最后一个元素的下标大1。

## 一步一步的来看看
非常有用对观察一个算法具体如何是工作的。

上面例子是中包含 19 个数字，当拍完序后如下：

	[ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67 ]

我们需要在本数组中查找 `43`。

为了拆分数组，我们需要知道中间值的下标，由下面的代码实现：

```swift
let midIndex = range.lowerBound + (range.upperBound - range.lowerBound) / 2
```
最开始，`range` 的 `lowerBound = 0` , `upperBound = 19`。 `midIndex` 为 ``0 + (19 - 0)/2 = 19/2 = 9 `，实际结果是 `9.5`, 但是因为用的整数型，所以结果需要向下舍入。

在下图中 `*` 代表中间值，如图所示，这个值到两边是相同的个数，因此从这里分成两个值。

	[ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
                                      *
现在二分查找需要决定使用那一半数组，相关代码如下：

```swift
if a[midIndex] > key {
    // use left half
} else if a[midIndex] < key {
    // use right half
} else {
    return midIndex
}
```

本例中， ``a[midIndex] = 29 `, 比搜索值小，因此我们可以得出结论，搜索值永远不会再左半部分出现。因为左边所有的值都比 `29` 小。因此搜索值肯定是在右边部分(也可能不在数组中)。

现在我们可以简单的重复二分查找，从 `midIndex + 1` 到 `range.upperBound `:

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43, 47, 53, 59, 61, 67 ]


由于不用担心数组的左半部分，我把他们全部标记为 `x`, 现在我们只需要查看右边部分，从下标 10 开始。

We calculate the index of the new middle element: `midIndex = 10 + (19 - 10)/2 = 14`, and split the array down the middle again.

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43, 47, 53, 59, 61, 67 ]
	                                                 *

显而易见， `a[14]` 是右边数组的中间值。

搜索值是比 `a[14]` 大还是小呢？ 因为 `43 < 47`, 这次我们需要查看左半部分并忽略右边部分的大的值:

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43 | x, x, x, x, x ]

新的 `midIndex`在这里:

	[ x, x, x, x, x, x, x, x, x, x | 31, 37, 41, 43 | x, x, x, x, x ]
	                                     *

搜索值比 `37` 大，继续从右边查找：

	[ x, x, x, x, x, x, x, x, x, x | x, x | 41, 43 | x, x, x, x, x ]
	                                        *

搜索值比较大，再拆分一次并使用右边的部分：

	[ x, x, x, x, x, x, x, x, x, x | x, x | x | 43 | x, x, x, x, x ]
	                                            *

现在结束。搜索值正是我们正在寻找的，因此我们最后找到了 `43` 值，在 `13` 的位置。w00t! 耶！

看起来需要很多步，但是实际找到目标值只需要 4 步，因为 `log_2(19) = 4.23` 。如果用线性搜索需要 14 步。

如果我们搜索 `42` 会怎样呢？ 当搜索进行到无法分割数组时，`range.upperBound ` 变的比 `range.lowerBound` 小，这也反映出目标值不在数组中。

> **注意** 在许多二分查找的实现需要计算 `midIndex = (lowerBound + upperBound) / 2 `。 在处理超大数据的时候这里可能会有个小问题， 因为 `lowerBound + upperBound ` 可能会超出整数范围导致溢出。在 64 位机器上可能不会有问题，但是在 32 位机器上需要注意。

## 循环 vs 递归

二分查找使用递归很容易理解，因为是按照人的逻辑一步一步的分成更小的子数组。但是这并不是只有递归才能实现 `binarySearch() `, 使用循环实现速度会更好。

下面是用Swift循环实现的二分查找：

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

你可以看到代码与递归的写法非常相似，最大的不同是使用的 `while` 循环。

测试一下:

```swift
let numbers = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67]

binarySearch(numbers, key: 43)  // gives 13
```

## 最后

数组必须排序后才能查找是不是个问题呢？视情况而定，需要注意的是排序也是需要时间的，加上二分查找的时间可能比线性搜索还要慢。二分查找的优点是只需要一次排序就可以做很多次查找。


更多信息查看 [Wikipedia](https://en.wikipedia.org/wiki/Binary_search_algorithm).

*作者 Matthijs Hollemans；译者：KeithMorning*
