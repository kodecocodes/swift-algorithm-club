# 归并排序

目标：将数组从低到高（从高到低）进行排序

由 John von Neumann 在 1945 发明，归并排序在最好、最糟和平均情况下的时间效率是 **O(n log n)** 的高效排序算法。

归并排序算法使用 **分治法** 来将一个大问题分解成小问题，然后通过解决小问题来解决大问题。我认为归并排序算法是 **先分** 和 **后合并**。

假如要对一个具有 *n* 个数字的数组进行正确地排序。归并算法是这样做的：

- 将数字放到一个未排序的堆里
- 将堆分成两部分，现在有 **两个未排序的堆**。
- 继续将堆进行分解，直到不能再继续往下分。最后，我们就会有 *n* 个堆，每个堆有一个数字
- 然后将堆进行两两配对来 **合并** 堆。每一次合并的时候，数据都是按序存放的。由于每个堆都是有序的，所以这操作起来就简单多了。

## 一个例子

### 分

假如有一个具有 *n* 个数字的数组是 `[2, 1, 5, 4, 9]`。这是一个未排序的堆。目标就是一直将堆进行拆分，直到不能再拆分。

首先，将堆分成两部分：`[2, 1]` 和 `[5, 4, 9]`。还能再继续分吗？当然可以！

从左边的堆开始，将 `[2, 1]` 分成 `[2]` 和 `[1]`。还能再继续分吗？不能，现在开始检查右边的堆了。

将 `[5, 4, 9]` 分成 `[5]` 金额 `[4, 9]`。很自然地， `[5]` 不能再继续分了，但是 `[4, 9]` 还可以继续分成 `[4]` and `[9]`。

当分成 `[2]` `[1]` `[5]` `[4]` `[9]` 这些堆之后，拆分的过程就结束了。现在每个堆里只有一个元素。

### 合并

已经拆分了数组，现在要在 **排序过程中** 将堆进行合并。记住，思想是解决一堆小问题而不是一个大问题。对于每一次合并迭代，对堆进行合并的时候要非常上心。

现在有 `[2]` `[1]` `[5]` `[4]` `[9]`，第一步的结果是：`[1, 2]` 、 `[4, 5]` 和 `[9]`。因为 `[9]` 之后没有可以合并的了，在一步中，不能将它和别人进行合并。

下一步会将 `[1, 2]` 和 `[4, 5]` 进行合并。这一步的结果是：`[1, 2, 4, 5]` ，还是会留下 `[9]`，因为这又是一个奇数个数。

现在只有两个堆了，最后将他们俩进行合并得到一个有序的数组：`[1, 2, 4, 5, 9]`。

## 自上而下的实现

Swift 中归并排序的实现：

```swift
func mergeSort(_ array: [Int]) -> [Int] {
  guard array.count > 1 else { return array }    // 1

  let middleIndex = array.count / 2              // 2

  let leftArray = mergeSort(Array(array[0..<middleIndex]))             // 3

  let rightArray = mergeSort(Array(array[middleIndex..<array.count]))  // 4

  return merge(leftPile: leftArray, rightPile: rightArray)             // 5
}
```

步骤解析：

1. 如果数组为空或者只有一个元素，没有必要再继续拆分成更小的，只要直接返回数据即可。

2. 找到中间的索引。

3. 用上一步中的中间索引，递归地将左边的数组进行拆分。

4. 同样地，递归地将右边的数据进行拆分

5. 最后，将所有的数据合并，要确保时钟是有序的。

下面是合并算法：

```swift
func merge(leftPile: [Int], rightPile: [Int]) -> [Int] {
  // 1
  var leftIndex = 0
  var rightIndex = 0

  // 2 
  var orderedPile = [Int]()

  // 3
  while leftIndex < leftPile.count && rightIndex < rightPile.count {
    if leftPile[leftIndex] < rightPile[rightIndex] {
      orderedPile.append(leftPile[leftIndex])
      leftIndex += 1
    } else if leftPile[leftIndex] > rightPile[rightIndex] {
      orderedPile.append(rightPile[rightIndex])
      rightIndex += 1
    } else {
      orderedPile.append(leftPile[leftIndex])
      leftIndex += 1
      orderedPile.append(rightPile[rightIndex])
      rightIndex += 1
    }
  }

  // 4
  while leftIndex < leftPile.count {
    orderedPile.append(leftPile[leftIndex])
    leftIndex += 1
  }

  while rightIndex < rightPile.count {
    orderedPile.append(rightPile[rightIndex])
    rightIndex += 1
  }

  return orderedPile
}
```

这个看起来有点吓人，但是其实非常直接：

1. 需要两个索引来跟踪需要合并的两个数组。

2. 这是合并后的数组。现在它是孔的，但是在后面的步骤中会往这个数组里添加袁旭。

3. while 循环会比较左边和右边的元素，然后将他们添加到 `orderedPile` ，并确保这是有序的数。

4. If 控制从前面的 while 循环中退出之后的逻辑，它的意思是要么 `leftPile` 或者 `rightPile` 里的元素都已经完全添加到了 `orderedPile`。这个时候就没必要再进行比较了。只要将剩下的元素添加到 `orderedPile` 即可。

下面举一个 `merge()` 方法如何工作的例子，假如我们有下面的堆：`leftPile = [1, 7, 8]` 和 `rightPile = [3, 6, 9]`。每个堆各自都是有序的——这也是归并排序的前提。通过下面的步骤将他么合并到一个大的有序数组中：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ ]
      l              r

左边的索引是 `l`，指向左边的堆里的第一个元素 `1`，右边的索引 `r` 指向 `3`。因此，我们要加到 `orderedPile` 里的就是 `1`。同时将左边的索引 `l` 挪动到下一个位置。

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1 ]
      -->l           r

现在 `l` 指向 `7`，但是 `r` 还是指向 `3`。我们将小的元素添加到已排序的堆里，它就是 `3`。仙子啊情况变成了这样：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3 ]
         l           -->r

重复上面的步骤。在每一步中，我们都从 `leftPile` 或者 `rightPile` 中选一个更小的元素放到 `orderedPile`。

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6 ]
         l              -->r
	
	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6, 7 ]
         -->l              r
	
	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6, 7, 8 ]
            -->l           r

现在，左边的堆中没有元素了。现在只要简单地将右边的堆中的剩下元素添加进去就行，然后我们就结束了。排序好的堆是这样的：`[ 1, 3, 6, 7, 8, 9 ]`。

这个算法非常简单：在两个堆中从左到右进行移动，然后选一个小的元素。这个算法的前提就是我们要确保每个堆中的元素都是有序的。

## 自下而上的实现

到现在位置我们看到的归并排序算法叫做 “自上而下” 的方法，因为它是先将数组分成更小的堆，然后将他们合并。在对数组进行排序的时候（与之相对的是：链表），可以直接跳过拆分的步骤直接对数组中的每个元素进行合并。这叫做 “自下而上” 的方法。

现在进入游戏时间。:-) 下面是 Swift 中的自下而上的完整实现。

```swift
func mergeSortBottomUp<T>(_ a: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
  let n = a.count

  var z = [a, a]      // 1
  var d = 0
    
  var width = 1
  while width < n {   // 2
  
    var i = 0
    while i < n {     // 3

      var j = i
      var l = i
      var r = i + width
      
      let lmax = min(l + width, n)
      let rmax = min(r + width, n)
      
      while l < lmax && r < rmax {                // 4
        if isOrderedBefore(z[d][l], z[d][r]) {
          z[1 - d][j] = z[d][l]
          l += 1
        } else {
          z[1 - d][j] = z[d][r]
          r += 1
        }
        j += 1
      }
      while l < lmax {
        z[1 - d][j] = z[d][l]
        j += 1
        l += 1
      }
      while r < rmax {
        z[1 - d][j] = z[d][r]
        j += 1
        r += 1
      }

      i += width*2
    }
    
    width *= 2
    d = 1 - d      // 5
  }
  return z[d]
}
```

这个比自上而下的版本看起来要难懂的多，但是，主要部分是包含三个与 `merge()` 相同的 `while` 循环。

重点解析:

1. 归并算法需要一个临时的数组，因为我们不能在合并时候覆盖掉之前的内容。为每一次合并重新分配一个数组是比较浪费的，我们使用两个数组，我们用 `d` 的值来在这两个数组之间进行切换，`d` 的值要么是 0，要么是 1。数组 `z[d]` 是用来读，`z[1 - d]` 用来写。这就叫做 *双缓冲*。

2. 概念上来说，自下而上的版本与自上而下的版本是一样的。首先，将每个单元的堆进行合并，然后合并有两个元素的堆，然后是四个元素的堆，等等等等。堆的大小是由 `width` 来表示的。开始的时候 `width` 是 1，但是在每个循环结束的时候，我们将它乘以 2，所以外层的循环决定了需要合并的堆的大小，需要合并的数据在每次循环之后都会变大。

3. 内层的循环将每一对堆合并成一个。结果就放在 `z[1 - d]` 的数组里。

4. 这和自上而下的版本是一样的逻辑。主要区别是在这里我们使用了双缓冲，所以值是从 `z[d]` 读出，写入到 `z[1 - d]`。同时还用到了 `isOrderedBefore` 方法来比较元素，而不是用 `<`，所以这个归并算法是泛型的，所以可以用来堆任何类型的堆像进行排序。

5. 到这里的时候，`z[d]` 数组中的大小 `width` 已经合并到了一个大小为 `width * 2` 的数组 `z[1 - d]`。这里，我们交换两个数组，这样在下一步中我们就可以从新的堆中读取数据了。

这个方法是泛型的，所以可以堆任何想要的数据进行排序，只要提供一个 `isOrderedBefore` 闭包来对比两个元素就行。

下面是如何使用这个方法：

```swift
let array = [2, 1, 5, 4, 9]
mergeSortBottomUp(array, <)   // [1, 2, 4, 5, 9]
```

## 性能

归并排序方法的时间是由数组的大小决定。数组越大，要做的工作就越多。

初始数组是否是有序的与归并拍苏算法所需要的时间没有影响。因为我们不管元素的初始顺序是什么，都要做一样多的拆分和对比。

因此，对于最好、最遭和平均来说，时间复杂度总是 **O(n log n)**。

归并排序的一个缺点是需要一个临时的与要排序的数组一样大小的 “工作” 数组。不像 [快速排序](../Quicksort/README-CN.markdown)，它不是 **原地** 排序，

大部分归并排序的实现是 **稳定** 排序。意思就是相同值的元素在排序后依然保持这排序之前的相对顺序。对于像数字和字符串这样的简单值来说并不是很重要，但是对于复杂的对象来说可能就是一个问题。

## 参考

[归并排序 Wikipedia](https://en.wikipedia.org/wiki/Merge_sort)

*作者：Matthijs Hollemans 翻译： Daisy*


