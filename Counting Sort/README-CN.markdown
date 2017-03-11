# 计数排序

计数排序是根据用小整数作为关键词的对象集合进行排序的算法。它是通过计算每个具有不同的关键词的对象的个数来操作的，然后利用数学方法来算出每个关键词所在的位置。


## 例子

为了理解这个算法，我们举一个小的例子。

数组是： `[ 10, 9, 8, 7, 1, 2, 7, 3 ]`

### 第一步:

第一步是计算每个元素在数组冲出现的次数。第一步的输出是一个新的数组，看起来是这样的：

```
Index 0 1 2 3 4 5 6 7 8 9 10
Count 0 1 1 1 0 0 0 2 1 1 1
```

下面是完成这一步的代码：

```swift
  let maxElement = array.max() ?? 0

  var countArray = [Int](repeating: 0, count: Int(maxElement + 1))
  for element in array {
    countArray[element] += 1
  }
```

### 第二步

在第二步里，算法要尝试着找出在每个元素之前有多少个元素。因为我们已经知道了每个元素出现的次数，我们可以利用这一点。方法就是计算前面计数的总和然后存储到每个索引里。

计数数组是这样的：

```
Index 0 1 2 3 4 5 6 7 8 9 10
Count 0 1 2 3 3 3 3 5 6 7 8
```

第二步的代码：

```swift
  for index in 1 ..< countArray.count {
    let sum = countArray[index] + countArray[index - 1]
    countArray[index] = sum
  }
```

### 第三步：

这是算法的最后一步。原始数组中的每个元素都放在第二步输出的结果的位置上。例如，数字 10 会在索引 7 的位置。同样的，当你要放置计数要减 1 的元素时，其他的许多元素也都要相应的减少。

最后的输出结果是：

```
Index  0 1 2 3 4 5 6 7
Output 1 2 3 7 7 8 9 10
```

下面是最后一步的代码：

```swift
  var sortedArray = [Int](repeating: 0, count: array.count)
  for element in array {
    countArray[element] -= 1
    sortedArray[countArray[element]] = element
  }
  return sortedArray
```

## 性能

这个算法用简单的循环来堆集合进行排序。因此，执行整个算法的时间就是 **O(n+k)**，其中 **O(n)** 代表的是要初始化输出数组所要花费的时间，**O(k)** 是创建计数数组要花费的时间。

算法使用数组的长度 **n + 1** 和 **n**，所以要用到的空间总共是 **O(2n)**。所以对于关键词散布在数字线密集的集合来说，它是比较节省空间的。

*作者：Ali Hafizji 翻译：Daisy*


