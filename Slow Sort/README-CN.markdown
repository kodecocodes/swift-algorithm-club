# 慢排序

目标：从低到高（从高到低）对数字数组进行排序。

给定一个数字数组，将他们按正确的顺序进行排序。慢排序的算法是这样工作的：

我们可以将要对 n 个数字进行升序排序的问题分成下面的几个问题：

1. 找到数字中最大的数
 1. 找到第一个 n/2 个元素里最大的数
 2. 找到剩下的 n/2 个元素里最大的数
 3. 找到这两个最大数中的最大数
2. 对剩下的进行排序

## 代码

下面是 Swift 中慢排序的实现：

```swift
public func slowsort(_ i: Int, _ j: Int) {
    if i>=j {
        return
    }
    let m = (i+j)/2
    slowsort(i,m)
    slowsort(m+1,j)
    if numberList[j] < numberList[m] {
        let temp = numberList[j]
        numberList[j] = numberList[m]
        numberList[m] = temp
    }
    slowsort(i,j-1)
}
```

## 性能

| 情况  | 性能 |
|:-------------: |:---------------:|
| 最糟       |  slow |
| 最好      | 	O(n^(log(n)/(2+e))))        |
|  平均 | 	O(n^(log(n)/2))       | 

## 参考

[网上的慢排序解释](http://c2.com/cgi/wiki?SlowSort)

*作者：Lukas Schramm 翻译：*

