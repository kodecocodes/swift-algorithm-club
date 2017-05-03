# Fizz Buzz

Fizz buzz 是用来教小孩除法的文字游戏。玩家轮流往上增加计数，将能被 3 整除的数字用 “fizz” 代替，能被 5 整除的数字用 “buzz” 代替。

Fizz buzz 现在已经用作对计算机程序员的面试筛选。

## 例子

一局典型的 fizz buzz 游戏：

`1`, `2`, `Fizz`, `4`, `Buzz`, `Fizz`, `7`, `8`, `Fizz`, `Buzz`, `11`, `Fizz`, `13`, `14`, `Fizz Buzz`, `16`, `17`, `Fizz`, `19`, `Buzz`, `Fizz`, `22`, `23`, `Fizz`, `Buzz`, `26`, `Fizz`, `28`, `29`, `Fizz Buzz`, `31`, `32`, `Fizz`, `34`, `Buzz`, `Fizz`, ...

## 求余运算符

求余运算符 `%` 是解决 fizz buzz 问题的关键。

求余运算符会返回整数除法之后的余数。下面是一个求余运算符的例子：

| 除法      | 除法结果            | 求余         | 求余结果  |
| ------------- | -------------------------- | --------------- | ---------------:|
| 1 / 3       | 0 with a remainder of 3  | 1 % 3         | 1             |
| 5 / 3       | 1 with a remainder of 2  | 5 % 3         | 2             |
| 16 / 3      | 5 with a remainder of 1  | 16 % 3        | 1             |

判断一个数字是偶数还是奇数的通常做法就是用求余运算符：

| 求余       | 结果          | Swift 代码                      | Swift 代码结果 | 注释                                       |
| ------------- | ---------------:| ------------------------------- | -----------------:| --------------------------------------------- |
| 6 % 2       | 0               | `let isEven = (number % 2 == 0)`  | `true`            | If a number is divisible by 2 it is *even*    |
| 5 % 2       | 1               | `let isOdd = (number % 2 != 0)`   | `true`            | If a number is not divisible by 2 it is *odd* |

## 解决 fizz buzz

现在我们可以用求余运算符 `%` 来解决 fizz buzz 问题。

找到可以被 3 整除的数字：

| 求余 | 求余结果 | Swift 代码    | Swift 代码结果 |
| ------- | --------------:| ------------- |------------------:|
| 1 % 3 | 1            | `1 % 3 == 0`  | `false`           |
| 2 % 3 | 2            | `2 % 3 == 0`  | `false`           |
| 3 % 3 | 0            | `3 % 3 == 0`  | `true`            |
| 4 % 3 | 1            | `4 % 3 == 0`  | `false`           |

找到可以被 5 整除的数字：

| 求余 | 求余结果 | Swift 代码    | Swift 代码结果 |
| ------- | --------------:| ------------- |------------------:|
| 1 % 5 | 1            | `1 % 5 == 0`  | `false`           |
| 2 % 5 | 2            | `2 % 5 == 0`  | `false`           |
| 3 % 5 | 3            | `3 % 5 == 0`  | `false`           |
| 4 % 5 | 4            | `4 % 5 == 0`  | `false`           |
| 5 % 5 | 0            | `5 % 5 == 0`  | `true`            |
| 6 % 5 | 1            | `6 % 5 == 0`  | `false`           |

## 代码

下面是用 Swift 的一个简单实现：

```swift
func fizzBuzz(_ numberOfTurns: Int) {
  for i in 1...numberOfTurns {
    var result = ""

    if i % 3 == 0 {
      result += "Fizz"
    }

    if i % 5 == 0 {
      result += (result.isEmpty ? "" : " ") + "Buzz"
    }

    if result.isEmpty {
      result += "\(i)"
    }

    print(result)
  }
}
```

将代码放到 playground 并且像这样测试：

```swift
fizzBuzz(15)
```

会输出：

	1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz, 11, Fizz, 13, 14, Fizz Buzz

## 参考

[Fizz buzz 维基百科](https://en.wikipedia.org/wiki/Fizz_buzz)

*作者： [Chris Pilcher](https://github.com/chris-pilcher) 翻译：Daisy*


