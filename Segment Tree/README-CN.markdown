# 线段树

非常高兴能向你展示线段树。实际上它是我最喜欢的数据结构之一，因为在实现上它非常灵活和简单。

假设有一个某种类型和某个方法 **f** 的数组 **a** 。例如，函数可以是求和、乘法、最小值、最大值，[gcd](../GCD/README-CN.markdown) 等等。

你得任务是：

- 回答给定间隔 **1** 和 **r** 的查询，例如。执行 `f(a[l], a[l+1], ..., a[r-1], a[r])`
- 支持替换某个索引的元素 `a[index] = newItem`

例如，假设有一个数字数组：

```swift
var a = [ 20, 3, -1, 101, 14, 29, 5, 61, 99 ]
```

想要查询从 3 到 7 的函数 “sum” 的结果。也就是说要做下面这样做：

	101 + 14 + 29 + 5 + 61 = 210
	
因为 `101` 是数组中索引 3 的元素， `61` 是索引 7 的元素。所以将 `101` 和 `61` 之间的所有元素都传到求和函数将他们加起来。如果我们用 “min” 函数的话，结果就是 `5`，因为这是 3 到 7 之间的最小数。

下面是假设数组是 `Int` 类型并且 **f** 是两个整数的求和的简单方法：

```swift
func query(array: [Int], l: Int, r: Int) -> Int {
  var sum = 0
  for i in l...r {
    sum += array[i]
  }
  return sum
}
```

这个算法的时间在最差的情况下是 **O(n)**，也就是当 **l = 0, r = n-1**（**n** 是数组中的元素个数）。假如有 **m** 个查询的话，就是 **O(m*n)** 的复杂度了。

假如数组有 100,000 的个元素（**n = 10^5**），我们要做 100 次查询 （**m = 100**），那么我们的算法就要做 **10^7** 单位的工作。哎哟，这听起来非常不妙。让我们来看看怎么可以改进它。

线段树让我们可以以 **O(log n)** 的时间来响应查询和替代元素。是不是非常神奇？:sparkles:

线段树的思想是非常简单的：我们预先计算一些数组中的线段，然后就可以在不重复计算的情况下使用这些结果。

## 线段树结构

线段树只是节点是 `SegmentTree` 类的实例的[二叉树](../Binary%20Tree/README-CN.markdown)：

```swift
public class SegmentTree<T> {
  private var value: T
  private var function: (T, T) -> T
  private var leftBound: Int
  private var rightBound: Int
  private var leftChild: SegmentTree<T>?
  private var rightChild: SegmentTree<T>?
}
```

每个节点有下面这些数据：

- `leftBound` 和 `rightBound` 描述的是一个间隔
- `leftChild` 和 `rightChild` 是子节点的指针
- `value` 是执行函数 `f(a[leftBound], a[leftBound+1], ..., a[rightBound-1], a[rightBound])` 的结果

如果数组是 `[1, 2, 3, 4]`，函数是 `f = a + b`，那么线段树就是这样的：

![structure](Images/Structure.png)

每个节点的 `leftBound` 和 `rightBound` 用红色标记出来了。

## 构建一颗线段树

下面是我们如何创建线段树的节点：

```swift
public init(array: [T], leftBound: Int, rightBound: Int, function: @escaping (T, T) -> T) {
    self.leftBound = leftBound
    self.rightBound = rightBound
    self.function = function

    if leftBound == rightBound {                    // 1
      value = array[leftBound]
    } else {
      let middle = (leftBound + rightBound) / 2     // 2

      // 3
      leftChild = SegmentTree<T>(array: array, leftBound: leftBound, rightBound: middle, function: function)
      rightChild = SegmentTree<T>(array: array, leftBound: middle+1, rightBound: rightBound, function: function)

      value = function(leftChild!.value, rightChild!.value)  // 4
    }
  }
```

注意到这是一个递归方法。给定一个像 `[1, 2, 3, 4]` 的数组，然后它就会从根节点到所有的子节点来构建整棵树，

1. 在 `leftBound` 和 `rightBound` 相等的时候，递归就结束了。这样的一个 `SegmentTree` 实例表示的是一个叶子节点。对于输入数组 `[1, 2, 3, 4]` 来说，这个过程会创建四个这样的叶子节点：`1`, `2`, `3`, 和 `4`。只要从数组中把值填入进去即可。

2. 然而，如果 `rightBound` 还是比 `leftBound` 大的话，我们就创建两个子节点，将现在的线段分成两个相等的线段（最后，如果长度是偶数的话，如果是奇数的话，一个线段会大一些）。

3. 对这两个线段递归地构建子节点。左边的子节点包含的是间隔 **[leftBound, middle]**，右边的子节点包含的是间隔 **[middle+1, rightBound]**。 

4. 在构建完子节点之后，就可以计算我们自己的值了，因为  **f(leftBound, rightBound) = f(f(leftBound, middle), f(middle+1, rightBound))**。这是数学！

构建树是 **O(n)** 的操作。

## 得到查询的结果

我们经理这些困难是为了能够有效地查询树。

下面是代码：

```swift
  public func query(withLeftBound: leftBound: Int, rightBound: Int) -> T {
    // 1
    if self.leftBound == leftBound && self.rightBound == rightBound {
      return self.value
    }
    
    guard let leftChild = leftChild else { fatalError("leftChild should not be nil") }
    guard let rightChild = rightChild else { fatalError("rightChild should not be nil") }
    
    // 2
    if leftChild.rightBound < leftBound {
      return rightChild.query(withLeftBound: leftBound, rightBound: rightBound)
      
    // 3
    } else if rightChild.leftBound > rightBound {
      return leftChild.query(withLeftBound: leftBound, rightBound: rightBound)
      
    // 4
    } else {
      let leftResult = leftChild.query(withLeftBound: leftBound, rightBound: leftChild.rightBound)
      let rightResult = rightChild.query(withLeftBound: rightChild.leftBound, rightBound: rightBound)
      return function(leftResult, rightResult)
    }
  }
```

这也是一个递归方法。它会检查四中不同的可能。

1) 首先，检查要查询的间隔是否和当前节点负责的间隔相同。如果相同，那么就返回节点的值。

![equalSegments](Images/EqualSegments.png)

2) 要查询的线段是否在右节点范围内？如果是，对右节点递归地执行查询。

![rightSegment](Images/RightSegment.png)

3)  要查询的线段是否在左节点范围内？如果是，对左节点递归地执行查询。

![leftSegment](Images/LeftSegment.png)

4) 如果上面的都是，这就意味着我们的查询部分在左边，部分在右边，所以我们将两边的查询结合起来。

![mixedSegment](Images/MixedSegment.png)

下面是在 playground 中的测试代码：

```swift
let array = [1, 2, 3, 4]

let sumSegmentTree = SegmentTree(array: array, function: +)

sumSegmentTree.query(withLeftBound: 0, rightBound: 3)  // 1 + 2 + 3 + 4 = 10
sumSegmentTree.query(withLeftBound: 1, rightBound: 2)  // 2 + 3 = 5
sumSegmentTree.query(withLeftBound: 0, rightBound: 0)  // just 1
sumSegmentTree.query(withLeftBound: 3, rightBound: 3)  // just 4
```

查询树的时间是 **O(log n)**。

## 替换元素

线段树中节点的值取决于它下面的节点。所以假如我们想替换一个叶子节点的值，我们也需要更新所有的父节点。

下面是代码：

```swift
  public func replaceItem(at index: Int, withItem item: T) {
    if leftBound == rightBound {
      value = item
    } else if let leftChild = leftChild, rightChild = rightChild {
      if leftChild.rightBound >= index {
        leftChild.replaceItem(at: index, withItem: item)
      } else {
        rightChild.replaceItem(at: index, withItem: item)
      }
      value = function(leftChild.value, rightChild.value)
    }
  }
```

像往常一样，这也是递归的操作。如果节点是叶子，我们只要改变它的值。如果节点不是叶子，那么我们就递归地调用 `replaceItem(at: )` 来更新它的子节点。在这之后，我们重新计算节点的值，这样它就又是最新的了。

替换元素需要 **O(log n)** 的时间。

查看 playground 来看看更多如何使用线段树的例子。

## See also

[线段树 PEGWiki](http://wcipeg.com/wiki/Segment_tree)

*作者：[Artur Antonov](https://github.com/goingreen) 翻译：Daisy*


