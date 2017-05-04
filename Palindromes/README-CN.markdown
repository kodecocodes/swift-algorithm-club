# 回文

回文就是不管从前面还是后面开始读一个单词或短语，它都是一样的。回文可以是小写或大小、可以包含空格，标点符号以及单词分隔符。

检查是否有回文的算法已经是一个程序员面试的经典问题了。

## 示例 

单词 racecar 是一个有效的回文，因为它不管是从前面还是从后面开始拼起来都是一样的。下面的示例展示了回文 `racecar` 的其他形式。

```
raceCar
r a c e c a r
r?a?c?e?c?a?r?
RACEcar
```

## 算法 

要检查回文，分别从字符串的前面和后面开始往中间一个个对比字符。在回文算法的实现中，用递归来检查左边和右边的的字符。

## 代码 

下面是用 Swift 实现的递归实现：

```swift
func isPalindrome(_ str: String) -> Bool {
  let strippedString = str.replacingOccurrences(of: "\\W", with: "", options: .regularExpression, range: nil)
  let length = strippedString.characters.count

  if length > 1 {
    return palindrome(strippedString.lowercased(), left: 0, right: length - 1)
  }

  return false
}

private func palindrome(_ str: String, left: Int, right: Int) -> Bool {
  if left >= right {
    return true
  }

  let lhs = str[str.index(str.startIndex, offsetBy: left)]
  let rhs = str[str.index(str.startIndex, offsetBy: right)]

  if lhs != rhs {
    return false
  }

  return palindrome(str, left: left + 1, right: right - 1)
}
```

这个算法分为两步。

1. 第一步是将需要检查是否有回文的字符串传入到 `isPalindrome` 方法。该方法首先是喊出非单词模式 `\W`  [Regex reference](http://regexr.com)的出现。用两个 \\ 来避免字符串里面的 \。

```swift
let strippedString = str.replacingOccurrences(of: "\\W", with: "", options: .regularExpression, range: nil)
```

接下来就是检查字符串的长度，需要确保在移除非单词字符之后字符串的长度依然有效。然后就是在变成小写之后传到下一步。

2. 第二步是将字符串传到一个递归方法里。这个方法接收一个字符串，一个左索引，一个右索引。方法会检查两个索引的字符是否相等。先检查左边的索引是否大于或者等于右边的索引，如果是这样的话，那么整个过程就在没有返回假的情况下结束了，所以两边的字符串就是相等的，因此返回真。

```swift
if left >= right {
  return true
}
``` 
如果没有通过检查，那么就会继续对比两边的字符。如果他们不相等的话就返回假然后退出。

```swift
let lhs = str[str.index(str.startIndex, offsetBy: left)]
let rhs = str[str.index(str.startIndex, offsetBy: right)]

if lhs != rhs {
  return false
}
```
如果他们相等，就调用这个方法本身并且相应地修改索引并继续检查剩下的字符串。

```swift
return palindrome(str, left: left + 1, right: right - 1)
```

步骤一：
`race?C ar -> raceCar -> racecar`

步骤二：
```
|     |
racecar -> r == r

 |   |
racecar -> a == a

  | |
racecar -> c == c

   |
racecar -> left index == right index -> return true
```

## 扩展阅读

[Palindrome 维基百科](https://en.wikipedia.org/wiki/Palindrome)


*作者： [Joshua Alvarado](https://github.com/https://github.com/lostatseajoshua) 翻译：Daisy*


