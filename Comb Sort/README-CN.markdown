# 梳排序

冒泡排序的常见问题是小的值在靠近数组末尾的位置。这个问题严重地降低了冒泡排序的速度，因为它必须将小的值 -- 或 _乌龟_ -- 几乎穿过整个数组。冒泡排序是通过检查当前所以和下一个索引饿值来实现的，当这两个值无序时，他们就会交换位置。结果就是值像泡泡一样冒到了数组的正确位置。

梳排序是通过处理靠近数组结尾的乌龟而在冒泡排序的基础上做的改进。当前索引的值与数组远一些的位置的值进行比较。这就避免了冒泡排序的最差情况，并且极大的提高了冒泡排序的时间复杂度。

## 例子 

不同于冒泡排序的梳排序如何工作的分步示例，可以看 [这里](http://www.exforsys.com/tutorials/c-algorithms/comb-sort.html). 

下面是一个梳排序的动态效果：

![](https://upload.wikimedia.org/wikipedia/commons/4/46/Comb_sort_demo.gif)

## 算法 

和冒泡排序相似的是，都需要比较数组中的两个值。当索引小的值比索引大的值大时，因此就在数组中不合适的位置了，他们就要进行交换。与冒泡排序不同的是，对比的值是有一些距离的。这个值 -- _间隔_ -- 是随着迭代的进行慢慢变小的。

## 代码 

下面是一个梳排序的 Swift 的实现：

```swift
func combSort (input: [Int]) -> [Int] {
    var copy: [Int] = input
    var gap = copy.count
    let shrink = 1.3

    while gap > 1 {
        gap = (Int)(Double(gap) / shrink)
        if gap < 1 {
            gap = 1
        }
    
        var index = 0
        while !(index + gap >= copy.count) {
            if copy[index] > copy[index + gap] {
                swap(&copy[index], &copy[index + gap])
            }
            index += 1
        }
    }
    return copy
}
```
 
可以通过传入一个数组参数的方式来调用这个方法在 playground 里进行测试：

```swift
combSort(example_array_of_values)
```
  
这是以升序的方式对数组的值进行的排序。

## 性能
 
梳排序是为了改进冒泡排序的最差情况的时间而创造的。在梳排序里，最差情况下的时间复杂度是指数的 -- O(n^2)，但是在最好的时候，梳排序只要 O(n logn) 的时间复杂度。这对于冒泡排序来说是一个极大的性能提升。

与冒泡排序相同的是，梳排序的空间复杂度是不变的 -- O(1)。这在数组原地排序中是非常高的空间效率。


## 阅读资源

[梳排序 维基百科](https://en.wikipedia.org/wiki/Comb_sort)


*作者： [Stephen Rutstein](https://github.com/srutstein21) 翻译：Daisy*


