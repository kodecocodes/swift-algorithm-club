# Haversine 距离


用 haversine 公式计算球面上给定经纬度的两点之间的距离

haversine 公式可以在 [维基百科](https://en.wikipedia.org/wiki/Haversine_formula) 上找到。

Haversine 距离是用一个函数实现的，因为用一个类的话有点过了。

`haversineDinstance(la1: Double, lo1: Double, la2: Double, lo2: Double, radius: Double = 6367444.7) -> Double`

- `la1` 是用度为单位的点 1 的纬度
- `lo1` 是用度为单位的点 1 的经度
- `la2` 是用度为单位的点 2 的经度
- `lo2` 是用度为单位的点 2 的经度
- `radius` 是以米为单位的球面的半径，默认就是地球的半径 (来自 [WolframAlpha](http://www.wolframalpha.com/input/?i=earth+radius)).

这个函数包含 3 个闭包以便使代码更可读，并且与上面提到的维基百科上 Haversine 公式更好地作比较。

1. `haversine` 实现了 haversine, 一个三教学的方法
2. `ahaversine` haversine 的逆方法
3. `dToR` 将度转为弧度的闭包

`haversineDistance` 的结果是以米返回的。

*作者：Jaap Wijnen 翻译：Daisy*


