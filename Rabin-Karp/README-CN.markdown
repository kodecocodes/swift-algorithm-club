# Rabin-Karp 字符串搜索算法

Rabin-Karp 字符串搜搜算法是用来搜索特定范式的文本的。

这个算法的一个典型应用是检测抄袭。给定源材料，算法可以快速搜索原材料中的句子在文章中的实例，并且会忽略诸如大小写和标点符号这样的细节。由于需要大量搜索字符串，简单的字符串搜索算法就不实用了。

## 示例

给定一个文本 “The big dog jumped over the fox” 和一个搜索范式 “ump” ，返回的结果是 13.
从对 ”ump“ 进行散列开始，然后对 ”The“ 进行散列。如果散列值不匹配的话，然后就将窗口每次往右挪动一个字符（例如：”he “）然后减去前面散列值里的 ”T“。

## 算法

Rabin-Karp 算法用的是和搜索范式同样大小的滑动窗口。以对搜索范式进行散列开始，然后再对文本字符串的前 x 个字符进行散列，x 的值是搜索范式的长度。然后将滑动窗口往前挪动一个位置，然后用前面的散列值来快速的计算新的散列值。只有当它找到了一个和搜索范式匹配的散列值它才会去比较两个字符串看他们是不是一样的（防止散列冲突造成的错误）。

## 代码

主要搜索算法在下面。更多的实现细节在 rabin-karp.swfit 里。

```swift
public func search(text: String , pattern: String) -> Int {
    // convert to array of ints
    let patternArray = pattern.characters.flatMap { $0.asInt }
    let textArray = text.characters.flatMap { $0.asInt }

    if textArray.count < patternArray.count {
        return -1
    }

    let patternHash = hash(array: patternArray)
    var endIdx = patternArray.count - 1
    let firstChars = Array(textArray[0...endIdx])
    let firstHash = hash(array: firstChars)

    if (patternHash == firstHash) {
        // Verify this was not a hash collison
        if firstChars == patternArray {
            return 0
        }
    }

    var prevHash = firstHash
    // Now slide the window across the text to be searched
    for idx in 1...(textArray.count - patternArray.count) {
        endIdx = idx + (patternArray.count - 1)
        let window = Array(textArray[idx...endIdx])
        let windowHash = nextHash(prevHash: prevHash, dropped: textArray[idx - 1], added: textArray[endIdx], patternSize: patternArray.count - 1)

        if windowHash == patternHash {
            if patternArray == window {
                return idx
            }
        }

        prevHash = windowHash
    }

    return -1
}
```

可以用下面的方法来在 playground 里测试上面的代码：

```swift
  search(text: "The big dog jumped"", "ump")
```

会返回13，因为 ump 在从 0 开始算起的字符串的第 13 的位置上。

## 更多资源

[Rabin-Karp 维基百科](https://en.wikipedia.org/wiki/Rabin%E2%80%93Karp_algorithm)


*作者： [Bill Barbour](https://github.com/brbatwork) 翻译：Daisy*

