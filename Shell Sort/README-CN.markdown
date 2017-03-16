# 希尔排序

希尔排序是在[插入排序](../Insertion20%Sort/README-CN.markdown)的基础上，通过将原来的列表分成小的子列表然后分别进行插入排序来提高它的性能。

[Sapientia 大学的一个视频](https://www.youtube.com/watch?v=CmPA7zE8mx0) 展示了匈牙利乡村舞蹈的过程。

## 如何工作

与插入排序通过比较并排的元素，在位置不对时交换他们的位置不同的是，希尔排序比较的是更远的元素。

元素之间的距离叫做 *步长*。如果比较的元素顺序不对，就跨过步长交换他们。这消除了插入排序的许多中间副本。

思想是通过跨过一个大的步长来移动元素，数组可以非常快的变成部分有序。这就使得下一步更快了，因为不用交换那么多的元素了。

一旦一个过程结束以后，就要减小步长然后开始一个新的过程。直到步长变成 1，这个时候算法就跟插入排序一样了。但是因为数据已经相当有序了，最后一步会非常快。

## 例子

假如我们想要堆数组 `[64, 20, 50, 33, 72, 10, 23, -1, 4]` 使用希尔排序。

先将数组分成长度为 2 的大小：

    n = floor(9/2) = 4

这就是步长的大小。

创建 `n` 个子列表。在每个子列表中，元素是由步长带大小 `n` 来分开的。在我们的例子中，我们需要四个这样的子列表。子列表是通过 `insertionSort()` 函数来排序的。

这样可能还没有一个整体的感觉，所以我们再深入地仔细看看到底发生了什么。

第一步就是下面这样的，我们有 `n = 4` ， 所以是四个子列表：

	sublist 0:  [ 64, xx, xx, xx, 72, xx, xx, xx, 4  ]
	sublist 1:  [ xx, 20, xx, xx, xx, 10, xx, xx, xx ]
	sublist 2:  [ xx, xx, 50, xx, xx, xx, 23, xx, xx ]
	sublist 3:  [ xx, xx, xx, 33, xx, xx, xx, -1, xx ]

就像你看到的，每个子列表中只包含每隔四个的元素。不在子列表中的元素被标记为 `xx`。所以第一个子列表就是 `[ 64, 72, 4 ]`， 第二个是 `[ 20, 10 ]` 等等。我们用 “步长” 的原因是我们不需要再额外创作一个新的数组了。相反的，我们在原始数组中交错地使用他们。

现在对每个子列表调用一次 `insertionSort()`。

这个特殊版本的[插入排序](../Insertion20%Sort/README-CN.markdown)是从后往前进行排序的。每个子列表中的元素与列表中的其他元素进行比较。如果它们的顺序不对，交换他们，一直这样进行下去直到到达子列表的开始。

所以对于子列表 0 来说，将 `4` 和 `72` 进行交换，然后交换 `4` 和 `64` 。排序结束之后，子列表就是这样的了：

    sublist 0:  [ 4, xx, xx, xx, 64, xx, xx, xx, 72 ]

其他三个子列表排序之后是这样的：

	sublist 1:  [ xx, 10, xx, xx, xx, 20, xx, xx, xx ]
	sublist 2:  [ xx, xx, 23, xx, xx, xx, 50, xx, xx ]
	sublist 3:  [ xx, xx, xx, -1, xx, xx, xx, 33, xx ]
    
现在整个数组就是这样的了：

	[ 4, 10, 23, -1, 64, 20, 50, 33, 72 ]

现在它还不是完全有序的但是已经比之前更有序了。这完成了第一步。

在第二步里，将步长大小除以 2 ：

	n = floor(4/2) = 2

这就意味着我们现在需要创建两个子列表：

	sublist 0:  [  4, xx, 23, xx, 64, xx, 50, xx, 72 ]
	sublist 1:  [ xx, 10, xx, -1, xx, 20, xx, 33, xx ]

每个子列表包含每第二个元素。对这些子列表调用 `insertionSort()` 方法。结果是：

	sublist 0:  [  4, xx, 23, xx, 50, xx, 64, xx, 72 ]
	sublist 1:  [ xx, -1, xx, 10, xx, 20, xx, 33, xx ]

注意到了吗，现在每个列表中只有两个元素不在正确的位置。所以插入排序就会真的很快了，因为在第一步中我们已经将数组的一部分排好序了。

整个数组现在是这样的：

	[ 4, -1, 23, 10, 50, 20, 64, 33, 72 ]

这就完成了第二步了。最后一步的步长大小是：

	n = floor(2/2) = 1

步长大小为 1 表示我们只有一个子列表了，这就是数组本身，我们再调用 `insertionSort()` 来对它进行排序。最后的数组是这样的：

	[ -1, 4, 10, 20, 23, 33, 50, 64, 72 ]

希尔排序的时间复杂度在大部分时候是 **O(n^2)**，如果幸运的话就是 **O(n log n)**。这个算法是一个不稳定的排序；它可能会改变相同元素的位置。
  
## 步长系列

“步长系列” 决定了步长的初始大小以及它是如何在每一个迭代中变小的。一个好的步长系列对于希尔排序的表现说是非常重要的。

这个实现里的步长系列是从希尔的原始版本来的：初始值是数组大小的一般，然后每次都除以 2 。还有其他的计算步长的方法。

## 只是为了好玩...

这是一个古老的Commodore 64 BASIC版本的shell排序，Matthijs很久以前使用，并移植到几乎他用过的所有的编程语言：

	61200 REM S is the array to be sorted
	61205 REM AS is the number of elements in S
	61210 W1=AS
	61220 IF W1<=0 THEN 61310
	61230 W1=INT(W1/2): W2=AS-W1
	61240 V=0
	61250 FOR N1=0 TO W2-1
	61260 W3=N1+W1
	61270 IF S(N1)>S(W3) THEN SH=S(N1): S(N1)=S(W3): S(W3)=SH: V=1
	61280 NEXT N1
	61290 IF V>0 THEN 61240
	61300 GOTO 61220
	61310 RETURN

## 代码

下面是 Swift 中希尔排序的实现：

``` Swift
var arr = [64, 20, 50, 33, 72, 10, 23, -1, 4, 5]

public func shellSort(_ list: inout [Int]) {
    
    var sublistCount = list.count / 2
   
    while sublistCount > 0 {
        
        for index in 0..<list.count {
           
            guard index + sublistCount < list.count else { break }
            
            if list[index] > list[index + sublistCount] {
                swap(&list[index], &list[index + sublistCount])
            }
            
            guard sublistCount == 1 && index > 0 else { continue }
            
            if list[index - 1] > list[index] {
                swap(&list[index - 1], &list[index])
            }
        }
        sublistCount = sublistCount / 2
    }
}

shellSort(&arr)
```


## 参考

[希尔排序 维基百科](https://en.wikipedia.org/wiki/Shellsort)

[Rosetta code 希尔排序](http://rosettacode.org/wiki/Sorting_algorithms/Shell_sort)

*作者： [Mike Taghavi](https://github.com/mitghi) and Matthijs Hollemans 翻译：Daisy*


