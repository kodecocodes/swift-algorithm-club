# 二维数组

在 C 和 Objective-C 里可以写下面的代码，

	int cookies[9][7];
	
来造一个 9x7 的曲奇格子。这会创建一个有 63 个元素的二维数组。为了找到在列 3 行 6 的曲奇，可以这样写：

	myCookie = cookies[3][6];
	
不幸的是，在 Swift 中不能这样写。在 Swift 中要创建一个多维数组，要这样做：

```swift
var cookies = [[Int]]()
for _ in 1...9 {
  var row = [Int]()
  for _ in 1...7 {
    row.append(0)
  }
  cookies.append(row)
}
```

查找一个曲奇：

```swift
let myCookie = cookies[3][6]
```

实际上，也有用一行代码来创建数组，像这样：

```swift
var cookies = [[Int]](repeating: [Int](repeating: 0, count: 7), count: 9)
```

但是好丑啊。为了公平，可以将丑代码放到辅助方法里：

```swift
func dim<T>(count: Int, _ value: T) -> [T] {
  return [T](repeating: value, count: count)
}
```

然后这样创建数组：

```swift
var cookies = dim(9, dim(7, 0))
```

Swift 推断数组的数据类型应该是 `Int`，因为你用了 `0` 作为数组元素的默认值。要使用字符串的话，可以这样：

```swift
var cookies = dim(9, dim(7, "yum"))
```

`dim()` 函数使得创造更多维的数组简单多了：

```swift
var threeDimensions = dim(2, dim(3, dim(4, 0)))
```

照这样使用多维数组的缺点 —— 实际上是多个嵌套数组 —— 很容易就不知道哪一维代表的是什么。

所以我们来创建一个像二维数组的自定义类型，它用起来更方便。下面就是，短而且美味：

```swift
public struct Array2D<T> {
  public let columns: Int
  public let rows: Int
  private var array: [T]

  public init(columns: Int, rows: Int, initialValue: T) {
    self.columns = columns
    self.rows = rows
    array = .init(repeating: initialValue, count: rows*columns)
  }

  public subscript(column: Int, row: Int) -> T {
    get {
      return array[row*columns + column]
    }
    set {
      array[row*columns + column] = newValue
    }
  }
}
```

`Array2D` 是一个泛型类型，所以它可以存储任何类型的对象，而不仅仅是数字。

可以这样创建一个 `Array2D` 的实例：

```swift
var cookies = Array2D(columns: 9, rows: 7, initialValue: 0)
```

多谢 `subscript` 方法，可以像下面这样从数组中获取一个对象：

```swift
let myCookie = cookies[column, row]
```

或者改变对象：

```swift
cookies[column, row] = newCookie
```

`Array2D` 在内部使用了一个一维数组来存储数据。数组中对象的索引是通过这样来计算的：`(row x numberOfColumns) + column`。但是作为 `Array2D` 的使用者，我们不用关心这个；我们只要有 “column” 和 “row” 的概念就可以了，让 `Array2D` 去计算细节。这就是将原始类型封装成类或者结构体的好处。

这就是全部了。

*作者：Matthijs Hollemans 翻译：Daisy*


