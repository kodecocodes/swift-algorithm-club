# 最长公共子序列

两个字符串的最长公共子序列（LCS）是在两个字符串中同时出现的同样顺序的字符序列。

例如，`"Hello World"` 和 `"Bonjour le monde"` 的 LCS 是 `"oorld"`。如果从左到右遍历这两个字符串的话，就会发现字符 `o`, `o`, `r`, `l`, `d` 在两个字符串中都是以同样的顺序存在的。

其他可能的子序列是 `"ed"` 和 `"old"`，但是他们都比 `"oorld"` 要短。

> **注意：** 不要将这个和最长公共子字符串问题混淆了，公共子字符串中的字符必须是两个字符串的子字符串里的，即他们必须是紧挨着的。在子序列里，如果字符没有挨着也是没有我恩替的，但是他们的顺序必须是一样的。

找到两个字符串 `a` 和 `b` 的 LCS 的一个方法是使用动态编程和回溯策略。

## 使用动态编程找到 LCS 的长度

首先，我们想要找到字符串 `a` 和 `b` 的最长公共子序列的长度。这个时候我们还没有找到实际的序列，只是找出它有多长。

要确定 `a` 和 `b` 的子串的所有组合之间的 LCS 的长度，可以使用 *动态编程* 技术。动态编程的意思是对比所有的可能性并且将他们存储在一个查询表中。

> **注意** 在下面的解释中，`n` 是字符串 `a` 的长度，`m` 是字符串 `b` 的长度。

为了找到所有可能子序列的长度，我们需要使用一个辅助方法 `lcsLength(_:)`。它会创建一个 `(n+1)` 乘以 `(m+1)` 大小的矩阵，`matrix[x][y]` 是子串 `a[0...x-1]` 和 `b[0...y-1]` 之间的 LCS 的长度。

给定字符串 `"ABCBX"` 和 `"ABDCAB"`， `lcsLength(_:)` 的输出矩阵是：

```
|   | Ø | A | B | D | C | A | B |
| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |  
| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
| C | 0 | 1 | 2 | 2 | 3 | 3 | 3 |
| B | 0 | 1 | 2 | 2 | 3 | 3 | 4 |
| X | 0 | 1 | 2 | 2 | 3 | 3 | 4 |
```

在这个例子中，如果我们查找 `matrix[3][4]`，我们会找到 `3` 。这就是说 `a[0...2]` 和 `b[0...3]`，或者是 `"ABC"` 和 `"ABDC"` 之间的 LCS 的长度是 3。这是对的，因为这两个子串有共同的 `ABC` 序列。（注意：矩阵的第一行和第一列始终都是 0）

下面是 `lcsLength(_:)` 的源代码；它是在 `String` 的一个扩展里：

```swift
func lcsLength(_ other: String) -> [[Int]] {

  var matrix = [[Int]](repeating: [Int](repeating: 0, count: other.characters.count+1), count: self.characters.count+1)

  for (i, selfChar) in self.characters.enumerated() {
	for (j, otherChar) in other.characters.enumerated() {
	  if otherChar == selfChar {
		// Common char found, add 1 to highest lcs found so far.
		matrix[i+1][j+1] = matrix[i][j] + 1
	  } else {
		// Not a match, propagates highest lcs length found so far.
		matrix[i+1][j+1] = max(matrix[i][j+1], matrix[i+1][j])
	  }
	}
  }

  return matrix
}
```

首先，创建一个新的矩阵 -- 实际上是一个二维数组 -- 并且填入 0。然后遍历两个字符串， `self` 和 `other`，按顺序对比他们的字符来填充矩阵。如果两个字符匹配的话，就增加子序列的长度。然而，如果两个字符不一样的话，就“传播”目前位置最大的 LCS 长度。

假设下面的是当前的情况：

```
|   | Ø | A | B | D | C | A | B |
| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |  
| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
| C | 0 | 1 | 2 | * |   |   |   |
| B | 0 |   |   |   |   |   |   |
| X | 0 |   |   |   |   |   |   |
```

`*` 表示的是我们现在正在对比的字符，`C` 对 `D`。这两个字符是不一样的，所以我们就传播我们看到的最大的长度 `2`：

```
|   | Ø | A | B | D | C | A | B |
| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |  
| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
| C | 0 | 1 | 2 | 2 | * |   |   |
| B | 0 |   |   |   |   |   |   |
| X | 0 |   |   |   |   |   |   |
```

现在我们对比 `C` 和 `C`。他们是相同的，然后我们就将长度增加得到 `3`：

```
|   | Ø | A | B | D | C | A | B |
| Ø | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| A | 0 | 1 | 1 | 1 | 1 | 1 | 1 |  
| B | 0 | 1 | 2 | 2 | 2 | 2 | 2 |
| C | 0 | 1 | 2 | 2 | 3 | * |   |
| B | 0 |   |   |   |   |   |   |
| X | 0 |   |   |   |   |   |   |
```

一直这样进行下去。这就是 `lcsLength(_:)` 填充矩阵的方法。

## 回溯来找到实际的子序列

目前为止我们计算了每一个可能的子序列的长度。最大子序列的长度就是矩阵的右下角，`matrix[n+1][m+1]`。在上面的例子中是 4，所以 LCS 由四个字符组成。

有了每一个子串组合的长度使得使用回溯策略来确定 *哪些* 字符是 LCS 的一部分变得可能。

回溯是从 `matrix[n+1][m+1]` 开始，往上和左（要以这个优先级）来查找没有简单传播的变化。

```
|   |  Ø|  A|  B|  D|  C|  A|  B|
| Ø |  0|  0|  0|  0|  0|  0|  0|
| A |  0|↖ 1|  1|  1|  1|  1|  1|  
| B |  0|  1|↖ 2|← 2|  2|  2|  2|
| C |  0|  1|  2|  2|↖ 3|← 3|  3|
| B |  0|  1|  2|  2|  3|  3|↖ 4|
| X |  0|  1|  2|  2|  3|  3|↑ 4|
```

每个 `↖` 移动表示字符（以行/列的形式）是 LCS 的一部分。

如果左边和上面的数字和当前位置的数字不一样的话，就表示没有广播发生。这样的话 `matrix[i][j]` 只表示字符串 `a` 和 `b` 之间的一个公共字符。所以在 `a[i - 1]` 和 `b[j - 1]` 是要查找的 LCS 的一部分。

要注意的一个事情是，因为它是往后运行的，LCS 是以倒转的顺序来构建的。在返回之前，需要将结果倒转过来来对应实际的 LCS。

下面是回溯的代码：

```swift
func backtrack(_ matrix: [[Int]]) -> String {
  var i = self.characters.count
  var j = other.characters.count
  
  var charInSequence = self.endIndex
  
  var lcs = String()
  
  while i >= 1 && j >= 1 {
	// Indicates propagation without change: no new char was added to lcs.
	if matrix[i][j] == matrix[i][j - 1] {
	  j -= 1
	}
	// Indicates propagation without change: no new char was added to lcs.
	else if matrix[i][j] == matrix[i - 1][j] {
	  i -= 1
	  charInSequence = self.index(before: charInSequence)
	}
	// Value on the left and above are different than current cell.
	// This means 1 was added to lcs length.
	else {
	  i -= 1
	  j -= 1
	  charInSequence = self.index(before: charInSequence)
	  lcs.append(self[charInSequence])
	}
  }
  
  return String(lcs.characters.reversed())
}
```  

回溯是从 `matrix[n+1][m+1]` （右下角）到 `matrix[1][1]` （左上角），查找两个字符串的共同字符。将这些字符放到一个新的字符串 `lcs` 里。

`charInSequence` 变量是给定的 `self` 字符串里的索引。开始的时候它指向的是字符串的最后一个字符。每次对 `i` 减 1 的时候，同时也会将 `charInSequence` 往后挪动。当发现两个字符一样的时候，就将 `self[charInSequence]` 的字符添加到新的 `lcs` 字符串。（不能用 `self[i]`，因为 `i` 可能不是当前 Swift 字符串的当前位置。）

由于是回溯，字符添加的顺序是反序的，所以最后需要调用 `reversed()` 来将字符串变回正确的顺序。（将字符添加到字符串的最后然后最后将字符串做一次翻转比在字符串的开头插入字符要快得多。）

## 将所有东西放到一起

为了查找两个字符串的 LCS，首先调用 `lcsLength(_:)` 然后调用 `backtrack(_:)`：

```swift
extension String {
  public func longestCommonSubsequence(_ other: String) -> String {

    func lcsLength(_ other: String) -> [[Int]] {
      ...
    }
    
    func backtrack(_ matrix: [[Int]]) -> String {
      ...
    }

    return backtrack(lcsLength(other))
  }
}
```

为了保持整洁，两个辅助方法都放在 `longestCommonSubsequence()` 方法里了。

下面是如何在 playground 里测试的代码：

```swift
let a = "ABCBX"
let b = "ABDCAB"
a.longestCommonSubsequence(b)   // "ABCB"

let c = "KLMK"
a.longestCommonSubsequence(c)   // "" (no common subsequence)

"Hello World".longestCommonSubsequence("Bonjour le monde")   // "oorld"
```

*作者：Pedro Vereza 翻译：Daisy*


