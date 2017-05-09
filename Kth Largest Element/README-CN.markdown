# 第 k 大的元素问题

给顶一个整数数组 `a`。写一个算法用来找到数组中第 `k` 大的元素。

例如，第 1 大的元素就是数组中出现的最大值。如果数组有 *n* 个元素，那么第 *n* 大的元素就是最小值。中间值就是 *n/2* 大的元素。

## 天真的解决方法

下面的解决方案是半天真的。由于要先对数据进行排序，所以时间复杂度是 **O(n log n)**，并且还需要二外的 **O(n)** 的空间。

```swift
func kthLargest(a: [Int], k: Int) -> Int? {
  let len = a.count
  if k > 0 && k <= len {
    let sorted = a.sort()
    return sorted[len - k]
  } else {
    return nil
  }
}
```

kthLargest() 方法需要两个参数：一个是由整数组成的数组 `a`，和 `k`。然后返回第 *k* 大的元素。

现在让我们看看这个例子，看看算法是如何工作的。给定 `k = 4` 和数组：

```swift
[ 7, 92, 23, 9, -1, 0, 11, 6 ]
```

刚开始的时候，没有直接的方法可以找出第 k 大的元素，但是在对数组进行排序之后，就非常直观了。下面是排序好的数组：

```swift
[ -1, 0, 6, 7, 9, 11, 23, 92 ]
```

现在，我们要做的就剩找到在索引 `a.count - k` 的值了：

```swift
a[a.count - k] = a[8 - 4] = a[4] = 9
```

当然，如果是要找第 k *小*的元素的话，用 `a[k]` 就可以了。

## 更快的解决方案

这是一个将 [二分搜索](../Binary%20Search/README-CN.markdown) 和 [快速排序](../Quicksort/README-CN.markdown) 思想结合起来的达到 **O(n)** 的聪明算法。

回忆一下二分查找将数组一直分一直分来缩小要查找的值的范围。在这里我们也要这样做。

快速排序也要将数组分开。它用划分的方法来讲所有小的值放到轴的左边，大的值放到右边。在沿着某一个轴划分之后，轴的值就会在它相应的位置了，我们可以把这个当成这里的优势。

下面是它如何工作的：选择一个随机的轴，沿着轴对数组进行划分。然后像二分搜索一样要么沿着左边要么沿着右边继续。重复这个过程直到找到了一个轴正好在第 `k` 大的位置上。

先来看看最开始的例子把。我们要找第 4 大的元素：

	[ 7, 92, 23, 9, -1, 0, 11, 6 ]

如果我们改为找第 k *小*的元素可能会更容易理解一些，所以我们就先改成查找第 4 小的元素。

我们不用先将数组进行排序。我们随机选择一个轴，假如就是 `11`，然后沿着它对数组进行划分。我们看到的结果可能是这样的：

	[ 7, 9, -1, 0, 6, 11, 92, 23 ]
	 <------ smaller    larger -->

正如你所看到的，所有比 `11` 小的值都在左边；所有比它大的值都在右边。轴 11 现在就在它的最终位置上。轴的索引是 `5`， 所以，第 `4` 小的元素一定在锁边。现在我们可以忽略剩下的元素了。

	[ 7, 9, -1, 0, 6, x, x, x ]

我们再选一个随机的轴，假如就是 `6`，然后将数组沿着它进行拆分。拆分后的结果是这样的：

	[ -1, 0, 6, 9, 7, x, x, x ]

轴 `6` 最后在索引 2 的位置，显然 第 4 小的元素一定在右边的位置，现在我们可以忽略左边的部分了：

	[ x, x, x, 9, 7, x, x, x ]

再选一个随机的轴，`9`，拆分之后是这样的：

	[ x, x, x, 7, 9, x, x, x ]

轴 `9` 的索引是 4，这就是我们要找的 *k* 了。这只花了几步就完成了，而且我们也没有先对数组进行排序。

下面的方法实现了这些想法：

```swift
public func randomizedSelect<T: Comparable>(array: [T], order k: Int) -> T {
  var a = array
  
  func randomPivot<T: Comparable>(inout a: [T], _ low: Int, _ high: Int) -> T {
    let pivotIndex = random(min: low, max: high)
    swap(&a, pivotIndex, high)
    return a[high]
  }

  func randomizedPartition<T: Comparable>(inout a: [T], _ low: Int, _ high: Int) -> Int {
    let pivot = randomPivot(&a, low, high)
    var i = low
    for j in low..<high {
      if a[j] <= pivot {
        swap(&a, i, j)
        i += 1
      }
    }
    swap(&a, i, high)
    return i
  }

  func randomizedSelect<T: Comparable>(inout a: [T], _ low: Int, _ high: Int, _ k: Int) -> T {
    if low < high {
      let p = randomizedPartition(&a, low, high)
      if k == p {
        return a[p]
      } else if k < p {
        return randomizedSelect(&a, low, p - 1, k)
      } else {
        return randomizedSelect(&a, p + 1, high, k)
      }
    } else {
      return a[low]
    }
  }
  
  precondition(a.count > 0)
  return randomizedSelect(&a, 0, a.count - 1, k)
}
```

为了更可读，函数里分成了三个内部函数：

- `randomPivot()` 选一个随机数然后将它放到部分的最后（这是 Lomuto 划分模型里的一个要求，参考 [快速排序](../Quicksort/README-CN.markdown) 获取更多细节）。

- `randomizedPartition()` 是快速排序里的 lomuto 的划分模型。当这个过程结束的时候，随机选择的轴就在它排序好是所在的位置了。函数返回轴所在的索引。

- `randomizedSelect()` 做了所有艰难的工作。它先调用划分方法，然后决定接下来要怎么做。如果轴的索引和我们要找的第 *k* 位的数字相等的话，这个过程就结束了。如果 `k` 小于轴的索引，那么它一定在左边的部分然后我们要递归地再进行尝试。相反的，第 k 大的数一定就在右边了。

非常酷，是不是？通常快速排序是 **O(n log n)** 的算法，但是因为我们不断地将数组划分成更小的部分，`randomizedSelect()` 的时间最红就是 **O(n)** 了。

> **注意：** 这个函数计算的是第 *k* 小的元素，*k* 是从 0 开始的，如果要找第 *k* 大的元素，就要用 `a.count - k`。

*作者： Daniel Speiser 修改： Matthijs Hollemans 翻译：Daisy*


