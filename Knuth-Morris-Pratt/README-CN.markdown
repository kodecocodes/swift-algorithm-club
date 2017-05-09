# Knuth-Morris-Pratt 字符串搜索

目标：用 Swift 写一个返回给定模式出现的所有的索引的线性时间的字符串匹配算法。

换句话说，想要实现一个 `String` 的 `indexesOf(pattern: String)` 扩展，返回一个整数数组 `[Int]` 表示所有搜索模式出现的索引，或者是没有找到时返回 `nil`。

例如：

```swift
let dna = "ACCCGGTTTTAAAGAACCACCATAAGATATAGACAGATATAGGACAGATATAGAGACAAAACCCCATACCCCAATATTTTTTTGGGGAGAAAAACACCACAGATAGATACACAGACTACACGAGATACGACATACAGCAGCATAACGACAACAGCAGATAGACGATCATAACAGCAATCAGACCGAGCGCAGCAGCTTTTAAGCACCAGCCCCACAAAAAACGACAATFATCATCATATACAGACGACGACACGACATATCACACGACAGCATA"
dna.indexesOf(ptnr: "CATA")   // Output: [20, 64, 130, 140, 166, 234, 255, 270]

let concert = "🎼🎹🎹🎸🎸🎻🎻🎷🎺🎤👏👏👏"
concert.indexesOf(ptnr: "🎻🎷")   // Output: [6]
```

[Knuth-Morris-Pratt 算法](https://en.wikipedia.org/wiki/Knuth–Morris–Pratt_algorithm) 被认为是解决模式匹配问题最好的算法。虽然实际中可能 [Boyer-Moore](../Boyer-Moore/README-CN.markdown) 更受欢迎，我们将要介绍的算法更简单，同样也是线性时间的。

算法背后的思想和 [简单字符串搜索](../Brute-Force%20String%20Search/README-CN.markdown) 并没有很大的不同。Knuth-Morris-Pratt 讲文本和模式对齐并从左到右进行字符比较。但是，在遇到不匹配时移动一个字符的位置不同的是，它会用一个聪明的方式来沿着文本来移动模式。事实上，这个算法有一个模式预处理阶段，其中它获取将使算法跳过冗余比较的所有信息，导致更大的偏移。

预处理阶段会生成一个整数数组 （代码里叫做 `suffixPrefix`），其中每个元素 `suffixPrefix[i]` 记录的是与 `P` 的前缀匹配的最长后缀 `P[0...i]` （其中 `P` 是模式）的长度。换句话说，`suffixPrefix[i]` 是 `P` 在位置 `i` 的最长子串，也就是 `P` 的前缀。举个例子，假设 `P = "abadfryaabsabadffg"`，`suffixPrefix[4] = 0`，`suffixPrefix[9] = 2`, `suffixPrefix[14] = 4`。

有很多方法可以活的 `SuffixPrefix` 数组的值。我们会用基于 [Z 算法](../Z-Algorithm/README-CN.markdown) 的方法。函数接收一个模式输入并输出一个整数数组。每个元素代表的是 `P` 从位置 `i` 开始与 `P` 的前缀匹配的最长子串的长度。注意到这两个数组很相似，他们在不同的地方记录了相同的信息。我们只要找找让 `Z[i]` 和 `suffixPrefix[j]` 匹配的方法。这并不难，下面就是代码：

```swift
for patternIndex in (1 ..< patternLength).reversed() {
    textIndex = patternIndex + zeta![patternIndex] - 1
    suffixPrefix[textIndex] = zeta![patternIndex]
}
```

我们只是简单地计算从 `i` 开始的子串（与 `P` 的前缀匹配）的结束的索引。在索引位置的 `suffixPrefix` 的元素就会设置成子串的长度。

一旦偏移数组 `suffixPrefix` 准备好之后就可以开始模式搜索了。算法一开始是将文本和模式进行比较，如果成功，就继续直到发现不匹配。当不匹配的时候，就检查当前是否有匹配的模式出现（并且报告）。否则，如果没有，文本的光标就往前移动，否则就将模式往右边移动。移动的数量是由 `suffixPrefix` 数据决定的，它保证前缀 `P[0...suffixPrefix[i]]` 会与文本中相对的子串匹配。这样的话，移动多个字符可以避免很多不必要的比较，节省时间。

下面是 Knuth-Morris-Pratt 算法的代码：

```swift
extension String {

    func indexesOf(ptnr: String) -> [Int]? {

        let text = Array(self.characters)
        let pattern = Array(ptnr.characters)

        let textLength: Int = text.count
        let patternLength: Int = pattern.count

        guard patternLength > 0 else {
            return nil
        }

        var suffixPrefix: [Int] = [Int](repeating: 0, count: patternLength)
        var textIndex: Int = 0
        var patternIndex: Int = 0
        var indexes: [Int] = [Int]()

        /* Pre-processing stage: computing the table for the shifts (through Z-Algorithm) */
        let zeta = ZetaAlgorithm(ptnr: ptnr)

        for patternIndex in (1 ..< patternLength).reversed() {
            textIndex = patternIndex + zeta![patternIndex] - 1
            suffixPrefix[textIndex] = zeta![patternIndex]
        }

        /* Search stage: scanning the text for pattern matching */
        textIndex = 0
        patternIndex = 0

        while textIndex + (patternLength - patternIndex - 1) < textLength {

            while patternIndex < patternLength && text[textIndex] == pattern[patternIndex] {
                textIndex = textIndex + 1
                patternIndex = patternIndex + 1
            }

            if patternIndex == patternLength {
                indexes.append(textIndex - patternIndex)
            }

            if patternIndex == 0 {
                textIndex = textIndex + 1
            } else {
                patternIndex = suffixPrefix[patternIndex - 1]
            }
        }

        guard !indexes.isEmpty else {
            return nil
        }
        return indexes
    }
}
```
  
让我们用上面的代码来举一个例子。假设字符串 `P = ACTGACTA"`，文本 `T = "GCACTGACTGACTGACTAG"`，因此可以得到 `suffixPrefix` 数组是 `[0, 0, 0, 0, 0, 0, 3, 1]`。算法会像下面这样将文本和模式对齐。要将 `T[0]` 和 `P[0]` 进行比较。

                              1       
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:      ^
    pattern:        ACTGACTA
    patternIndex:   ^
                    x
    suffixPrefix:   00000031

第一个字符不匹配，所以继续比较 `T[1]` and `P[0]`。我们要先检查是不是有一个模式出现了，但是还没有。所以，要将模式往右边移动并且要检查 `suffixPrefix[1 - 1]`。它的值是 `0`，然后我们重新开始比较 `T[1]` with `P[0]`。还是一个不匹配，所以继续比较 `T[2]` with `P[0]`.

                              1      
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:        ^
    pattern:          ACTGACTA
    patternIndex:     ^
    suffixPrefix:     00000031

这次我们有一个匹配了。并且能够持续到位置 `8`。不幸的是匹配的长度和模式的长度不一样，不能报告说有发现。但我们还是幸运的，因为现在我们可以用 `suffixPrefix` 数组里的值了。事实上，匹配的长度是 `7`，如果我们查看元素 `suffixPrefix[7 - 1]` 的值发现它是 `3`。 这个信息告诉我们 P 的前缀和子串 `T[0...8]` 的后缀匹配。所以 `suffixPrefix` 可以保证两个子串匹配并且我们不需要再进行比较他们的字符了，所以我们将模式往右移动不止一个字符的距离！

比较又要从 `T[9]` 和 `P[3]` 重新开始了。

                              1       
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:               ^
    pattern:              ACTGACTA
    patternIndex:            ^
    suffixPrefix:         00000031

他们匹配上了所以我们继续直到位置 `13`， `G` 和 `A` 出现了一个不匹配。就像之前一样，我们比较幸运，可以用 `suffixPrefix` 数组来往右移动模式。

                              1       
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:                   ^
    pattern:                  ACTGACTA
    patternIndex:                ^
    suffixPrefix:             00000031

再一次，我们还是要比较。但是这次的比较最终告诉我们发现了一个模式匹配，在位置 `17 - 7 = 10`。

                              1       
                    0123456789012345678
    text:           GCACTGACTGACTGACTAG
    textIndex:                       ^
    pattern:                  ACTGACTA
    patternIndex:                    ^
    suffixPrefix:             00000031

算法继续比较 `T[18]` 和 `P[1]` （因为我们用的 `suffixPrefix[8 - 1] = 1` 的值），但是它失败了，再下一个迭代里就结束了它的工作。


预处理阶段只跟模式有关。Z 算法的运行事件是线性的，即 `O(n)`，其中 `n` 是模式 `P` 的长度。之后，搜索阶段不会 “超过” 文本 `T` 的长度（叫它 `m`）。可以证明得到搜索阶段的比较次数不会超过 `2 * m`。Knuth-Morris-Pratt 的最后运行时间是 `O(n + m)`。


> **注意：** 要执行 [KnuthMorrisPratt.swift](./KnuthMorrisPratt.swift) 里的代码，需要将文件夹 [Z-Algorithm](../Z-Algorithm/) 里的 [ZAlgorithm.swift](../Z-Algorithm/ZAlgorithm.swift) 文件拷贝过来 [KnuthMorrisPratt.playground](./KnuthMorrisPratt.playground) 已经包含了 `Zeta` 函数的定义。

归功于： 代码是基于 Dan Gusfield 的 ["Algorithm on String, Trees and Sequences: Computer Science and Computational Biology"](https://books.google.it/books/about/Algorithms_on_Strings_Trees_and_Sequence.html?id=Ofw5w1yuD8kC&redir_esc=y) , 剑桥大学出版社, 1997.

*作者：Matteo Dunnhofer 翻译：Daisy*


