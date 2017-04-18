# 暴力搜索字符串

如果在不允许导入 Foundation 和不能使用  `NSString` 的 `rangeOfString()` 方法的情况下你会如何写一个字符串搜索算法呢？

目标是实现一个 `String` 的 `indexOf(pattern: String)` 扩展方法，返回第一个符合搜索范式的 `String.Index` 值，在没有找到的时候返回 `nil` 。
 
例如：

```swift
// Input: 
let s = "Hello, World"
s.indexOf("World")

// Output:
<String.Index?> 7

// Input:
let animals = "🐶🐔🐷🐮🐱"
animals.indexOf("🐮")

// Output:
<String.Index?> 6
```

> **注意：** 奶牛的索引是 6 ，而不是期望的 3，因为字符串需要使用多个字符来存储 emoji。`String.Index` 的实际值并不重要，只要它指向了正确的字符就行。

下面是暴力搜索的实现：

```swift
extension String {
  func indexOf(_ pattern: String) -> String.Index? {
    for i in self.characters.indices {
        var j = i
        var found = true
        for p in pattern.characters.indices{
            if j == self.characters.endIndex || self[j] != pattern[p] {
                found = false
                break
            } else {
                j = self.characters.index(after: j)
            }
        }
        if found {
            return i
        }
    }
    return nil
  }
}
```

按顺序查找源字符串中的每个字符。如果字符等于搜索范式的第一个字符，内层循环就检查剩下的字符是否和范式相匹配。如果没有找到匹配的，外层循环就继续寻找剩下的。直到找到一个完整的匹配或者到了源字符串的结尾才结束。

暴力方法工作起来是 OK 的，但是它不是很有效率（或者是漂亮）。虽然在字符串比较小的时候是没有问题的。对于大块文本的搜索，有一个更聪明的算法，参考 [Boyer-Moore](../Boyer-Moore/README-CN.markdown) 字符串搜索。

*作者：Matthijs Hollemans 翻译：Daisy*


