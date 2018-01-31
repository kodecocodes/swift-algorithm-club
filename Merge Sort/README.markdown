# 归并排序

> 举个[例子](https://www.raywenderlich.com/154256/swift-algorithm-club-swift-merge-sort)

目标：从小大排列数组（或者反过来）

该算法是 John von Neumann 在1945年提出的，归并排序是一个高效的算法，最好，最坏，期望时间复杂度均为 **O(n log n)** 。

归并排序使用 **分治** 的思想把一个大问题分成一个一个小问题，然后在分别解决。归并算法的就是 **先分解** 后 **合并** 处理。

排列 *n* 个数的数字使用归并排序步骤如下：

- 把数字存入未排序的序列
- 把序列一分为二，得到两个未排序的序列
- 一直分割下去，直到无法再分割。最后得到一个 *n* 个序列，每个序列只有一个数字
- 按顺序比较合并，每次合并后时进行排序。这时候操作非常简单因为每一个序列已经排序过了。

## 例子

### 分割

假设数组为 `[2, 1, 5, 4, 9]`，显然是乱序的，目标是一直分割下去直到无法分割。

首先，把数组分割成两半：`[2, 1]` 和 `[5, 4, 9]`。现在还能分割吗？当然可以啦！

焦点放在左半部分上，将 `[2, 1]` 分割为 `2` 和 `[1]` 。能继续再分割吗？不能，少年你该去查看其它序列了。

把 ` [5, 4, 9]` 分割成 `[5]` 和 `[4, 9]` 。`[5]` 不能再分割了， 但是 `[4, 9]` 可以继续分割为 `[4]` 和 `[9]` 。

分割结束后为 `[2]` `[1]` `[5]` `[4]` `[9]` 。注意每一个序列只包含一个元素。

### 合并

现在数组已经分割完了，下一步开始边 **排序** 边 **合并**。记住这种思想只能解决很多小问题，但是无法解决大问题。每次合并迭代时，需要考虑两个序列的合并。

数组为 `[2]` `[1]` `[5]` `[4]` `[9]`，第一合并后的结果返回 `[1, 2]` 和 `[4, 5]` 以及 `[9]`。因为 `[9]` 没有配对的，所以什么都不做。

下一次将把 `[1, 2]` 和 `[4, 5]` 合并在一起，结果为 `[1, 2, 4, 5]`， `[9]` 因为没有配对的又被落下了。

现在只剩下 `[1, 2, 4, 5]` 和 `[9]`，最后合并的数组为 [1, 2, 4, 5, 9]`。

## 自上而下的实现

Swift 实现如下：

```swift
func mergeSort(_ array: [Int]) -> [Int] {
  guard array.count > 1 else { return array }    // 1

  let middleIndex = array.count / 2              // 2

  let leftArray = mergeSort(Array(array[0..<middleIndex]))             // 3

  let rightArray = mergeSort(Array(array[middleIndex..<array.count]))  // 4

  return merge(leftPile: leftArray, rightPile: rightArray)             // 5
}
```

每一步的解释如下:

1. 如果只有一个元素的数组不需要分割，直接返回即可

2. 找到数组中间位置

3. 使用中间位置递归分割左边部分

4. 同样的分割右边部分

5. 最后把所有的值合并起来，确保都是一直排序的

   > 原文介绍的过程并不具体，计算的时序和栈图应该如下图所示（译者注）
   >
   > ```swift
   > [2, 1, 5, 4, 9]
   >
   > ---> [2, 1] //递归分割
   >  --->[2] , [1] //递归分割结束
   > --->[1, 2]   //对当前进行合并
   >
   > --->[5, 4, 9] //递归分割
   >  --->[5 ,4], [9]//递归入栈右边第一次分割
   >   --->[5], [4], [9] //递归入栈右边第二次分割,分割完后开始进行合并
   >  --->[4，5]，[9] //递归函数出栈右边第一次合并
   > ---> [4，5，9] //递归函数出栈右边第二次合并
   >
   > ---> [1，2] [4，5，9] //开始合并
   > ---> [1, 2, 4, 5, 9] //合并结束
   >          
   >          
   >
   > ```
   >
   > ​
   >
   > ​
   >
   > ​              

下面是合并算法:

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

看起来可能比较抓狂，其实很简单：

1. 合并时候你需要用两个位置数跟踪两个数组
2. 目前合并用的新数组是空的，以后会慢慢把其他数组中元素添加进来。
3. 这个 while 循环通过取左右数组更小的值，把它放入 `orderedPile` 中。（从那边取值后，那边的位置数就+1，译者补充）
4. 经过第一个循环后， `leftPile` 或者 `rightPile` 肯定有一个会完全合并入 `orderedPile` 中。 所以就不用在进行比较了，直接把剩余的数组放入 `orderedPile` 中即可。

举个例子介绍解释  `merge()`， 假如排列 `leftPile = [1, 7, 8]` 和 `rightPile = [3, 6, 9]`。 注意这两个序列已经排列过了， 这是归并排序合并的前提。 合并成一个更大而且排序好的序列如下：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ ]
	  l              r

左位置数用 `l` 指向左序列的第一个元素 `1` 。右位置数用 `r` 指向第一个元素 `3`。因此第一个值是 `1` 放入 `orderedPile` 中。移动 `l` 到下一个位置。

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1 ]
	  -->l           r

现在 `1` 指向 `7` ，但是 `r` 仍然在 `3` 的位置，现在把最小的值 `3` 放入 `orderedPile` 中。如下：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3 ]
	     l           -->r

重复过程如下，每步都取 `leftPile` 或者 `rightPile` 最小的值，并放入 `orderedPile` 中：

	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6 ]
	     l              -->r
	
	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6, 7 ]
	     -->l              r
	
	leftPile       rightPile       orderedPile
	[ 1, 7, 8 ]    [ 3, 6, 9 ]     [ 1, 3, 6, 7, 8 ]
	        -->l           r



现在左边序列中已经没有值要添加了，现在可以把右边剩余的值放入排序序列中了。结果为 `1, 3, 6, 7, 8, 9` 。

算法的思想非常简单：从左到右依次遍历两个序列，每次取最小的。这种做法的前提就是需要保证每个序列都是已经排序的。

## 自下而上

之前看到的算法方式称为 ”自上而下“ ，因为我们先分割数组然后再合并他们。在排序一个数组（链表也可以）的时候你可以不用分割这步直接开始合并单独的数组元素，称为 `自下而上` 的方法。

是时候更上一层楼了. :-) 

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

看起来比 `自上而下` 的复杂多了，但是注意代码主体也包含三个和 `merge()` 相同的 `while` 循环。

重点如下:

1. 因为不能一边合并左右序列，一边重写序列的内容，归并算法需要一个临时数组。因为每次合并重新初始化一个新数组是很浪费的，用两个数组即可。 `d` 值为 0 或 1，用 `d` 来切换使用这两个数组, `z[d]` 用来读取， `z[1-d]` 用来写，这种方式称为 `双缓冲`。
2. 原理上 *自下而上* 的版本和 *自下而上* 的版本是一样的。首先，先合并一个元素的序列，然后合并两个元素的序列，再合并四个元素的序列。序列的大小由 `width` 决定。`width` 初始值为 `1` ，但是在每次循环后都乘以2，所以外层循环决定每次合并的序列大小，排序的数组之增加。
3. 里面的循环遍历所有的序列并合并每一对序列，结果通过存入 `z[1 - d]` 。
4. 和 *自上而下* 的算法是一样的逻辑。主要不同在于这里使用了双重循环，从 `z[d]` 中读出，然后存入 `z[1 - d]` 中。不是用 `<` 而是用 `isOrderedBefore` 函数来进行比较。归并算法使用了泛型，你可以用它排列任意类型的对象。 
5. 此时，`z[d]`  中的`width` 的序列合并为 `width * 2`的序列存入 `z[1 - d]` 中。这里交换一下当前数组，这样下一步就能从新的创建的序列里读取数据。

> 译者注
>
> 可以看做数组本来就是一个一个数字组成， `width` 初始为 `1` ， 就是先两两比较成一组，然后写入一个新数组中，两两比较后，就是按组比较，每组两个，所以 `width * 2` 即两组比较，以此类推下去，当 `width < n`， `2 * width > n`时结束排列。 这里用 `z` 做双缓冲的意思也很简单，每次读上次 `排序` 的数组，然后将比较结果写入下一个结果中。所以这里 `var z = [a,a]` 等价于 `var c = [](); var z = [a,c]`， 只有第一个数组会被用来遍历，第二个只是大小和 `a` 一样的空数组。

这个函数支持泛型，所以可以支持任何类型的数据，只要你提供一个 `isOrderedBefore` 的函数用来作比较顺序。

例如：

```swift
let array = [2, 1, 5, 4, 9]
mergeSortBottomUp(array, <)   // [1, 2, 4, 5, 9]
```

## 性能

归并排序算法的速度依赖数组大小，数组越大，消耗越大。

数组是否已经排序不会影响归并排序，无论原来元素是否排序过，都需要做同样量的分割和比较。

因此，最好，最坏情况和期望时间复杂度均为 **O(n log n)** 。

归并排序不方便之处在于需要一个和待排序数组一样的临时的数组，无法就地排序，不如[快排](../Quicksort/)方便。

大多数的归并排序都是 **稳定** 排序。意味着有相同关键值的元素保存相对位置不变。稳定排序对于数字和字符串来说没什么意义，但是在排序复杂对象数据结构时候会很重要。



## 更多

[归并排序 Wikipedia](https://en.wikipedia.org/wiki/Merge_sort)

*作者 Kelvin Lau.  批注 Matthijs Hollemans. 译者 KeithMorning*
