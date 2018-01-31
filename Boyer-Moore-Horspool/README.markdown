# Boyer-Moore 字符串搜索

> [栗子](https://www.raywenderlich.com/163964/swift-algorithm-club-booyer-moore-string-search-algorithm)

目标：不导入 `Foundation` ，不使用 `NSString` 的 `rangeOfString()` 方法写一个纯Swift版的字符串搜索算法。

换句话说，我们想实现 `String` 的一个 `indexOf(pattern: String)` 扩展，返回 第一个查询到的模式字符串的`String.Index` ，如果不存在返回 `nil` 。

例如:

```swift
// Input:
let s = "Hello, World"
s.indexOf(pattern: "World")

// Output:
<String.Index?> 7

// Input:
let animals = "🐶🐔🐷🐮🐱"
animals.indexOf(pattern: "🐮")

// Output:
<String.Index?> 6
```

> **注意**：奶牛的索引为 6 ，而不是 3，因为这里使用的 emoji，它需要更多的字节。实际的 `String.Index` 值并不重要只要它指向正确的位置。 

[brute-force ](../Brute-Force%20String%20Search/) 算法实现，但是效率非常低，尤其在有大量的文本的时候。实际上你不用挨个查看原文本中字符，很多情形下你可以直接跳过一些字符。

这种跳跃式查找的算法称为 [Boyer-Moore](https://en.wikipedia.org/wiki/Boyer–Moore_string_search_algorithm) 。这个算法存在已近已经很久了，它作为字符串查找算法基准。

`Swift` 版实现：

```swift
extension String {
    func index(of pattern: String) -> Index? {
      //缓存搜索模式串的长度，因为我们以后会多次使用它，计算一次比较耗时。
        let patternLength = pattern.characters.count
        guard patternLength > 0, patternLength <= characters.count else { return nil }

      // 创建跳表，当模式串中的一个字符被找到后决定跳多远
        var skipTable = [Character: Int]()
        for (i, c) in pattern.characters.enumerated() {
            skipTable[c] = patternLength - i - 1
        }

      //指向模式串的最后一个字符
        let p = pattern.index(before: pattern.endIndex)
        let lastChar = pattern[p]
      
      //模式串的匹配是自右向左，所以查找时跳的长度根据模式串决定。(因为索引开始值指向字符串中的第一个字符，所以它最小是1)
        var i = index(startIndex, offsetBy: patternLength - 1)

      //这个函数用于反向遍历原字符串和模式串，找到不匹配的字符或者到达模式串的开头后退出
        func backwards() -> Index? {
            var q = p
            var j = i
            while q > pattern.startIndex {
                j = index(before: j)
                q = index(before: q)
                if self[j] != pattern[q] { return nil }
            }
            return j
        }

      //主循环一直遍历到字符串的末尾
        while i < endIndex {
            let c = self[i]

          //当前字符与模式串的最后一个字符是否匹配
            if c == lastChar {

              //可能匹配，做一个 brute-force 反向查找
                if let k = backwards() { return k }

              //如果不匹配，只能向前跳过该字符
                i = index(after: i)
            } else {
                
              //字符不匹配，直接跳过。跳过的距离由跳表决定，如果字符没有在模式串中，可以直接跳模式串的长度，但是如果字符是在模式串中，前面可能有可以匹配的，所以我们现在还不能跳
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        return nil
    }
}
```

这个算法工作如下。把模式串与原字符串对齐，看看那个字符与模式串的最后一个字符对齐：

```
source string:  Hello, World
search pattern: World
                    ^
```

有三种可能：

1. 这两个字符相等，正好匹配上。
2. 如果字符不相同，但是这个字符在原字符串中存在，也在模式串中存在。
3. 这个字符都没有在模式串中出现过。

举个例子，如下面 `o` 和 `d` 不相同，但是 `o` 出现在搜索字符串中。因为着可以跳过几个字符：

```
source string:  Hello, World
search pattern:    World
                       ^
```

注意 `o` 对齐了，然后再对比搜索字符串的最后一个字符 `W` 和 `d` 。两者不同，但是 `W` 在模式串中出现了。因此跳过几个字符对齐两个 `W` ：

```
source string:  Hello, World
search pattern:        World
                           ^
```

现在两个字符相同，模式串可能与原字符串相同。从尾到头做 `brute-force` 的反向搜索，这就是这个算法整个流程。

跳过多少位由 “跳表” 决定，它通过字典类型存储每个字符和其要跳跃多少位。跳表如下：

```
W: 4
o: 3
r: 2
l: 1
d: 0
```

越在模式串末尾的字符，跳的位数越小。如果模式串中有重复的字符，由靠近尾部的字符决定跳的位数。

> **注意：** 如果模式串包含很少的字符，做 `brute-force` 搜索也很快，在这种情况下需要权衡一下建跳表的代价，因为做 `brute-force` 也很快。

申明：这段代码是基于1989年7月 Costas Menico 在 Dr Dobb 杂志发表的文章 ——[《更快的字符搜索》](http://www.drdobbs.com/database/faster-string-searches/184408171) 。1989年啊！有时候保存点旧杂志还是有用的！

参见更加详细的[分析](http://www.inf.fh-flensburg.de/lang/algorithmen/pattern/bmen.htm)

## Boyer-Moore-Horspool 算法

上面算法改进版的是 [Boyer-Moore-Horspool 算法](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore%E2%80%93Horspool_algorithm)。

类似 Boyer-Moore 算法，它也使用跳表进行跳跃。不同之处在于我们如何处理部分匹配的情况。在上面的版本中，如果只有部分匹配，我们只跳一个字符，在本算法中，我们也是用跳表。

下面是 Boyer-Moore-Horspool 的算法：

```swift
extension String {
    func index(of pattern: String) -> Index? {
        //缓存搜索模式串的长度，因为我们以后会多次使用它，计算一次比较耗时。
        let patternLength = pattern.characters.count
        guard patternLength > 0, patternLength <= characters.count else { return nil }

        // 创建跳表，当模式串中的一个字符被找到后决定跳多远
        var skipTable = [Character: Int]()
        for (i, c) in pattern.characters.enumerated() {
            skipTable[c] = patternLength - i - 1
        }

        //指向模式串的最后一个字符
        let p = pattern.index(before: pattern.endIndex)
        let lastChar = pattern[p]

        //模式串的匹配是自右向左，所以查找时跳的长度根据模式串决定。(因为索引开始值指向字符串中的第一个字符，所以它最小是1)
        var i = index(startIndex, offsetBy: patternLength - 1)

        //这个函数用于反向遍历原字符串和模式串，找到不匹配的字符或者到达模式串的开头后退出
        func backwards() -> Index? {
            var q = p
            var j = i
            while q > pattern.startIndex {
                j = index(before: j)
                q = index(before: q)
                if self[j] != pattern[q] { return nil }
            }
            return j
        }

         //主循环一直遍历到字符串的末尾
        while i < endIndex {
            let c = self[i]

            //当前字符与模式串的最后一个字符是否匹配
            if c == lastChar {

                //可能匹配，做一个 brute-force 反向查找
                if let k = backwards() { return k }

              //确定至少可以跳一个字符(因为第一个字符是在跳表中，而且 `skipTable[lastChar] = 0`)
                let jumpOffset = max(skipTable[c] ?? patternLength, 1)
                i = index(i, offsetBy: jumpOffset, limitedBy: endIndex) ?? endIndex
            } else {
                //字符不匹配，直接跳过。跳过的距离由跳表决定，如果字符没有在模式串中，可以直接跳模式串的长度，但是如果字符是在模式串中，前面可能有可以匹配的，所以我们现在还不能跳
                i = index(i, offsetBy: skipTable[c] ?? patternLength, limitedBy: endIndex) ?? endIndex
            }
        }
        return nil
    }
}
```

实际上 Horspool 版本的算法要比原先的好一些，但是还是要看你做什么。

申明：本代码基于本论文:[R. N. Horspool (1980). "Practical fast searching in strings". Software - Practice & Experience 10 (6): 501–506.](http://www.cin.br/~paguso/courses/if767/bib/Horspool_1980.pdf)

_作者 Matthijs Hollemans, 更新 Andreas Neusüß_, [Matías Mazzei](https://github.com/mmazzei) *译者 KeithMorning*
