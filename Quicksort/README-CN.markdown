# 快速排序

目标：对数组进行从低到高（从高到低）进行排序。

快速排序是历史上最著名的排序算法之一。它是在 1959 年由 Tony Hoare 发明的，在那个时候，递归还是一个非常模糊的概念。

下面是一个 Swift 中的非常容易理解的实现：

```swift
func quicksort<T: Comparable>(_ a: [T]) -> [T] {
  guard a.count > 1 else { return a }

  let pivot = a[a.count/2]
  let less = a.filter { $0 < pivot }
  let equal = a.filter { $0 == pivot }
  let greater = a.filter { $0 > pivot }
  
  return quicksort(less) + equal + quicksort(greater)
}
```

将代码放到 playground 里然后进行测试：

```swift
let list = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
quicksort(list)
```

下面讲讲它是如何工作的。给定了一个数组之后， `quicksort()` 根据一个 “基准” 变量来将数组分成三部分。这里是将数组的中间的元素作为基准（后面会看到选择基准的其他方法）。

所有小于基准的元素都放到一个叫做 `less` 的数组中。所有等于基准的元素就进入到 `equal` 的数组。你猜到了，所有大于基准的元素就放到第三个数组 `greater` 中。这就是为什么泛型类型 T 必须是 Comparable 的原因，这样我们就可以用 `<`、`==` 和 `>` 来比较元素了。

一旦我们有了三个数组，`quicksort()` 递归地对 `less` 和 `greater` 数组进行排序，然后将这些已经排好序的数组和 equal 数组合并到一起组成最后的结果。

## 例子

让我们来看看这个例子吧。数组开始是这样的：

	[ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]

首选，我们选择一个基准元素，`8`，因为它在数组的中间。现在我们将数组分成 less、equal 和 greater 部分：

	less:    [ 0, 3, 2, 1, 5, -1 ]
	equal:   [ 8, 8 ]
	greater: [ 10, 9, 14, 27, 26 ]

这是一个很好的划分，因为 `less` 和 `greater` 大概包含了同样数量的元素。所以选了一个好的基准正好将数组从中间分开了。

注意到现在 `less` 和 `greater` 数组还没有排好序，所以我们对这两部分子数组继续调用 `quicksort()` 。做的事情是一样的：选一个基准然后将子数组分成三部分。

现在我们来看看 `less` 数组：

	[ 0, 3, 2, 1, 5, -1 ]

基准元素是中间的 `1`（你也可以选 `2`， 这并没有什么关系）。再一次，我们围绕着基准将数组分成三个子数组：

	less:    [ 0, -1 ]
	equal:   [ 1 ]
	greater: [ 3, 2, 5 ]

到这里还没有结束，继续对 `less` 和 `greater` 数组递归地调用 `quicksort()`。再看看 `less` 部分吧：

	[ 0, -1 ]

选择 `-1` 作为基准。现在子数组是这样的：

	less:    [ ]
	equal:   [ -1 ]
	greater: [ 0 ]

`less` 数组已经空了，因为没有比 `-1` 小的元素；另外连个数组都分别只有一个元素了。这就意味着完成了这个级别的递归，然后回去对 `greater` 数组继续递归操作。

`greater` 数组是：

	[ 3, 2, 5 ]
	
跟之前的工作方式是一样的：选中间元素 `2` 作为基准然后填充数组：

	less:    [ ]
	equal:   [ 2 ]
	greater: [ 3, 5 ]

注意到了吗，这里 `3` 是一个更好的基准选择 —— 我们会很快结束。但是现在我们不得不对 `greater` 数组继续递归来确保它是有序的。这就是为什么选择一个好的基准是很重要的。当选了多个“不好”的基准的时候， 快速排序实际上变的非常慢。下面会讲更多。

对 `greater` 数组继续拆分，结果是：

	less:    [ 3 ]
	equal:   [ 5 ]
	greater: [ ]

现在我们也结束这个级别的递归，因为不能再对数组继续拆分了。

一直重复这个过程直到所有的子数组都排好序。如下图所示：

![Example](Images/Example.png)

如果你从左往右读有颜色的箱子，会得到一个有序的数组：

	[ -1, 0, 1, 2, 3, 5, 8, 8, 9, 10, 14, 26, 27 ]

`8` 是一个好的初始基准，因为它正好也在有序数组的中间。

我希望这清楚地说明了快速排序的工作原理。不幸的是，这个版本的快速排序并不是很快，因为我们要对统一数组做三次 `filter()`。还有更聪明的拆分数组的方法。

## 拆分

将数组围绕基准进行划分叫做 *分块* ，有一些不同的分块模型。

如果数组是，

	[ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]

并且我们选择中间元素 `8` 作为基准，在拆分数组之后就会是这样的：

	[ 0, 3, 2, 1, 5, -1, 8, 8, 10, 9, 14, 27, 26 ]
	  -----------------        -----------------
	  all elements < 8         all elements > 8

要注意的关键事情就是分块后基准元素就会在它最终排好序的位置上。剩下的数字都是未排序的，围绕着基准进行划分是很简单的。快速排序会将数组不断得进行划分，直到所有的值都是它们最后的位置上。

划分不会保证相同的元素还保持着它们原来的相对位置，所以围绕着基准 `8` 进行划分的时候，也有可能是下面这样的结果：

	[ 3, 0, 5, 2, -1, 1, 8, 8, 14, 26, 10, 27, 9 ]

唯一能够保证的是基准左边的元素都比基准小，右边的都比基准大。由于划分会改变相同元素的原始顺序，所以快速排序不是一个“稳定”的排序（例如：[归并排序](../Merge%20Sort/README-CN.markdown)）。大部分时候这都不是一个大问题。

## Lomuto 的分块模型

在我展示给你的第一个快速排序的例子中，划分是通过调用 Swift 的 `filter()` 函数三次来实现的。这不是很高效。所以让我们来看看一个更聪明的分块算法，它是 *原地* 算法，例如，通过修改原始数组。

下面是用 Swift 实现的一个 Lomuto 的分块模型的实现：

```swift
func partitionLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
  let pivot = a[high]
  
  var i = low
  for j in low..<high {
    if a[j] <= pivot {
      (a[i], a[j]) = (a[j], a[i])
      i += 1
    }
  }
  
  (a[i], a[high]) = (a[high], a[i])
  return i
}
```

在 playground 中测试：

```swift
var list = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
let p = partitionLomuto(&list, low: 0, high: list.count - 1)
list  // 显示结果
```

`list` 需要是 `var`，因为 `partitionLomuto()` 会直接改变数组的内容（它是以 `inout` 参数穿进去的）。这就比重新分配一个新的数组对象要有效多了。

`low` 和 `high` 参数是必要的，因为在快速排序里，我们不希望总是将整个数组进行重新划分，只划分有限的部分，然后变得原来越小。

前面我们用的是数组的中间元素来作为基准的，但是 Lomuto 算法却总是使用*最后*一个元素，`a[hight]`，作为基准。因为我们一直围绕着 `8` 在进行操作，所以我在示例中将 `8` 和 `26` 的位置变换了饿一下，这样 `8` 就在数组的最后，然后也会在这里作为基准。

划分之后，数组是这样的：

	[ 0, 3, 2, 1, 5, 8, -1, 8, 9, 10, 14, 26, 27 ]
	                        *

变量 p 是 `partitionLomuto()` 的返回值，它的值是 7。这是新数组（用 * 号表示）中基准元素所在的索引。

左边的分块是从 0 到 `p-1`，`[ 0, 3, 2, 1, 5, 8, -1 ]`。右边的分块是从 `p+1` 到结尾，`[ 9, 10, 14, 26, 27 ]`（实际上右边的分块已经是有序的了，这是一个巧合）。

你可能注意到一件有趣的事情... `8` 在数组中不止出现了一次。其中一个 8 没有整齐的在中间，而是在左边的某个地方。如果有很多相同的元素的时候，这也是 Lomuto 算法的一个缺点。

Lomuto 算法究竟是怎么工作的呢？魔法就发生在 `for` 循环中。这个循环将数组分成四部分：

1. `a[low...i]` 包含所有 <= 基准的元素
2. `a[i+1...j-1]` 包含所有 > 基准的元素
3. `a[j...high-1]` 还没有查看的元素
4. `a[high]` 基准值

在 ASCII 艺术中，数组被分成这样：

	[ values <= pivot | values > pivot | not looked at yet | pivot ]
	  low           i   i+1        j-1   j          high-1   high

循环从 low 到 high -1 轮流查看每个元素。如果当前值比基准小或者等于基准，用交换的方法将它换到第一部分。

> **注意：** 在 Swift 中，语句 `(x, y) = (y, x)` 是一个交换 `x` 和 `y` 的很方便的方法。也可以用 `swap(&x, &y)`。

循环结束后，基准还是在数组的最后一个元素。所以要将它换到第一个比基准大的位置。现在基准就在 <= 和 > 区域的中间了，数组就正确的被分块了。

让我们一步步看看这个例子吧。数组开始是这样的：

	[| 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	   low                                       high
	   i
	   j

开始的时候，“未查看” 区域是从 索引 0 到 11。基准在索引 12 的位置。 “小于等于基准的值” 和 “大于基准” 的区域是空的，因为我们还没有开始查看任何值呢。
  
查看第一个值， `10`。它是不是比基准小？没有，跳过这个元素。

	[| 10 | 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	   low                                        high
	   i
	       j

“未查看” 区域从 1 到 11 了，“大于基准” 区域包含了一个数字 `10`，“小于等于基准” 还是空的。

查看第二个值，0。它比基准小吗？是的，所以将 `10` 和 `0` 进行交换，然后将 `i` 向前移动一位。

	[ 0 | 10 | 3, 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	  low                                         high
	      i
	           j

“未查看” 变成从 2 到 11 了， “大于基准” 还是包含 `10`，“小于等于基准” 包含数字 `0`。

查看第三个值，`3`。它比基准小，所以将它和 `10` 进行交换得到：

	[ 0, 3 | 10 | 9, 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	  low                                         high
	         i
	             j

“小于等于基准”区域现在是 `[ 0, 3 ]`。再查看那一个... `9` 比基准大，所以直接跳过：

	[ 0, 3 | 10, 9 | 2, 14, 26, 27, 1, 5, 8, -1 | 8 ]
	  low                                         high
	         i
	                 j

现在 “大于基准” 区域包含了 `[ 10, 9 ]`。如果我们继续这样下去的，最后就会是这样的：

	[ 0, 3, 2, 1, 5, 8, -1 | 27, 9, 10, 14, 26 | 8 ]
	  low                                        high
	                         i                   j

最后要做的事情就是通过交换 `a[i]` 和 `a[high]` 将基准放到正确的地方：

	[ 0, 3, 2, 1, 5, 8, -1 | 8 | 9, 10, 14, 26, 27 ]
	  low                                       high
	                         i                  j

然后返回 i，基准元素的索引。

> **注意：** 如果你还没有完全搞清楚这个算法是如何工作的，建议你在 playground 里看一下循环是如何创建这四个区域的。

下面我们就用这个分块模型来构建一个快速排序，下面是代码：

```swift
func quicksortLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
  if low < high {
    let p = partitionLomuto(&a, low: low, high: high)
    quicksortLomuto(&a, low: low, high: p - 1)
    quicksortLomuto(&a, low: p + 1, high: high)
  }
}
```

这非常简单。先调用 `partitionLomuto()` 来将数组围绕着基准（总是数组的最后一个元素）来重新排序。然后递归地对左边和右边的块调用  `partitionLomuto()` 。

试试吧：

```swift
var list = [ 10, 0, 3, 9, 2, 14, 26, 27, 1, 5, 8, -1, 8 ]
quicksortLomuto(&list, low: 0, high: list.count - 1)
```

Lomuto 不是位移的分块模型，但是是最容易理解的一个。它不如 Hoare 的模型高效，Hore 需要更少的交换就可以了。

## Hoare 的分块模型

这个分块模型是由 Hoare 发型的，快速排序的发明者。

下面是代码：

```Swift
func partitionHoare<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
  let pivot = a[low]
  var i = low - 1
  var j = high + 1
  
  while true {
    repeat { j -= 1 } while a[j] > pivot
    repeat { i += 1 } while a[i] < pivot
    
    if i < j {
      swap(&a[i], &a[j])
    } else {
      return j
    }
  }
}
```

在 playground 中进行测试：

```swift
var list = [ 8, 0, 3, 9, 2, 14, 10, 27, 1, 5, 8, -1, 26 ]
let p = partitionHoare(&list, low: 0, high: list.count - 1)
list  // 显示结果
```

在 Hoare 的模型中，基准总是数组的*第一个*元素，`a[low]`。我们还是用 `8` 来作为基准。

结果是：

	[ -1, 0, 3, 8, 2, 5, 1, 27, 10, 14, 9, 8, 26 ]
 
这次基准根本就没有在中间。与 Lomuto 的模型不同的是，返回的值不一定是基准元素在新数组中的索引。

相反的是，数组被分成 `[low...p]` 和 `[p+1...high]`。这里的返回结果 `p` 是 6，所以这两部分是 `[ -1, 0, 3, 8, 2, 5, 1 ]` 和 `[ 27, 10, 14, 9, 8, 26 ]`。

基准在其中一部分的某个地方，但是这个算法不会告诉你它在哪里。如果基准元素出现不止一次，那么一些可能出现在左边，另一些可能就出现在右边。

由于这个不同，Hoare 的快速排序的实现也非常不同：

```swift
func quicksortHoare<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
  if low < high {
    let p = partitionHoare(&a, low: low, high: high)
    quicksortHoare(&a, low: low, high: p)
    quicksortHoare(&a, low: p + 1, high: high)
  }
}
```

我把这个作为一个作业留给读者自己来发现 Hore 的分块模型是如何工作的。;-)

## 选一个好的基准

Lomuto 的分块模型总是选择数组的最后一个元素作为基准，Hoare 的模型则使用第一个元素。但是并不保证这些基准是好的。

下面是当如果你选了一个不好的值作为基准会发生的情况。假设数组是这样的：

	[ 7, 6, 5, 4, 3, 2, 1 ]

我们使用 Lomuto 的模型。基准是最后一个元素，`1`。操作之后，我们得到了下面数组：

	   less than pivot: [ ]
	    equal to pivot: [ 1 ]
	greater than pivot: [ 7, 6, 5, 4, 3, 2 ]

然后递归地对 “大于” 部分继续进行拆分然后得到：

	   less than pivot: [ ]
	    equal to pivot: [ 2 ]
	greater than pivot: [ 7, 6, 5, 4, 3 ]

再一次:

	   less than pivot: [ ]
	    equal to pivot: [ 3 ]
	greater than pivot: [ 7, 6, 5, 4 ]

等等等等...

这很不好，因为这将快速排序降到了更慢的插入排序。为了让快速排序更高效，要将数组粉肠差不多的两半。

对于这个例子来说，最理想的基准是 `4`，我们得到的是：

	   less than pivot: [ 3, 2, 1 ]
	    equal to pivot: [ 4 ]
	greater than pivot: [ 7, 6, 5 ]

你可能会想这就意味着我们总是要选择中间的元素而不是第一个或者最后一个，但是看看下面的情况会发生什么：

	[ 7, 6, 5, 1, 4, 3, 2 ]

中间的元素是 `1`，这会跟前面的例子一样给出一个松散的结果。

理想情况下，基准是需要划分的数组的 *中间* 元素，例如，有序数组的中间的元素。当然，在排好序之后我们都不知道中间元素是什么，所以这就有点像是鸡和蛋的问题，但是有一些技巧可以用来选择好的，虽然不是最理想的基准。

我们的技巧是 “三个的中间”，找到第一个、中间和最后一个元素的中间值。理论上来说这能给出一个真正中间值的接近值。

另外一个解决办法就是随机地选择基准。有时候它会选择一个不理想的基准，但是平均来说，它的结果还是好的。

下面是如何用随机选择基准来做快速排序：

```swift
func quicksortRandom<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
  if low < high {
    let pivotIndex = random(min: low, max: high)         // 1

    (a[pivotIndex], a[high]) = (a[high], a[pivotIndex])  // 2

    let p = partitionLomuto(&a, low: low, high: high)
    quicksortRandom(&a, low: low, high: p - 1)
    quicksortRandom(&a, low: p + 1, high: high)
  }
}
```

与前面的有两个重要不同：

1. `random(min:max:)` 函数返回一个 `min...max` 之间的随机整数，这就是我们的基准索引。
2. 因为 Lomuto 模型希望的是 `a[high]` 作为基准，所以我们在调用 `partitionLomuto()` 之前将 `a[pivotIndex]` 和 `a[high]` 进行交换来将基准元素放到最后。

在排序方法里用到随机数看起来有点奇怪，但是它是让快速排序在所有情况下都高效所必要的。选择了不好的基准，快速排序的性能就会非常糟糕，**O(n^2)**。但是平均下来能选择一个好的基准，例如，通过使用一个随机数生成器，希望的时间就是 **O(n log n)**，就和排序算法得到的一样好了。

## 荷兰国旗划分

但是还有很多可以提高的地方！在第一个快速排序中，结果是将数组分成下面这样：

	[ values < pivot | values equal to pivot | values > pivot ]

但是正如你在 Lomuto 分块模型中看到的，如果基准出现了不止一次，重复的是在左边的。在 Hoare 模型中，基准可以在任何地方。这个问题的解决办法是 “荷兰国旗” 分块，是以[荷兰国旗](https://en.wikipedia.org/wiki/Flag_of_the_Netherlands) 命名的，因为它正好有三个部分。

这个模型的代码是：

```swift
func partitionDutchFlag<T: Comparable>(_ a: inout [T], low: Int, high: Int, pivotIndex: Int) -> (Int, Int) {
  let pivot = a[pivotIndex]

  var smaller = low
  var equal = low
  var larger = high

  while equal <= larger {
    if a[equal] < pivot {
      swap(&a, smaller, equal)
      smaller += 1
      equal += 1
    } else if a[equal] == pivot {
      equal += 1
    } else {
      swap(&a, equal, larger)
      larger -= 1
    }
  }
  return (smaller, larger)
}
```

这和 Lomuto 模型非常相似，不同的是循环将数组分成四个部分（可能是空的）：

- `[low ... smaller-1]` 包含所有小于基准的值
- `[smaller ... equal-1]` 包含所有等于基准的值
- `[equal ... larger]` 包含所有大于基准的值
- `[larger ... high]` 还没有查看的值

注意到了吗，它不会假定基准就是 `a[high]`。相反的，你必须传入你想要作为基准的元素的索引。

例子：

```swift
var list = [ 10, 0, 3, 9, 2, 14, 8, 27, 1, 5, 8, -1, 26 ]
partitionDutchFlag(&list, low: 0, high: list.count - 1, pivotIndex: 10)
list  // 显示结果
```

为了好玩，这回我们就给另外一个 `8` 的索引。结果是：

	[ -1, 0, 3, 2, 5, 1, 8, 8, 27, 14, 9, 26, 10 ]

注意两个 `8` 是如何在中间的。从 `partitionDutchFlag()` 返回的值是一个元祖，`(6, 7)`。这是包含基准值的范围。

在快速排序中如何使用：

```swift
func quicksortDutchFlag<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
  if low < high {
    let pivotIndex = random(min: low, max: high)
    let (p, q) = partitionDutchFlag(&a, low: low, high: high, pivotIndex: pivotIndex)
    quicksortDutchFlag(&a, low: low, high: p - 1)
    quicksortDutchFlag(&a, low: q + 1, high: high)
  }
}
```

如果数组中包含很多的重复元素的话，用荷兰国旗分块可以让快速排序更高效（这不是因为我是荷兰人才这样说）。

> **注意：** 上面的 ` partitionDutchFlag()` 的实现用了一个自定义的 `swap()` 程序来交换两个数组元素。与 Swift 的 `swap()` 不同的是，如果两个索引指向同一个地方它不会报错。查看[快速排序](Quicksort.Swift)的代码。

## 参考

[快速排序 维基百科](https://en.wikipedia.org/wiki/Quicksort)

*作者：Matthijs Hollemans 翻译：Daisy*


