# 哈夫曼编码

思想：将频繁出现的对象用比更少出现的对象更少的位来进行编码。

虽然可以用这个方法来编码任何对象类型，它通常是用来压缩一串字节的。假设有下面的文本，每个字符就是一个字节：

	so much words wow many compression

如果数一下每个自己出现的频率，可以很清楚地知道一些自己比另外一些出现的次数更多：

	space: 5                  u: 1
	    o: 5	              h: 1
	    s: 4	              d: 1
	    m: 3	              a: 1
	    w: 3	              y: 1
	    c: 2	              p: 1
	    r: 2	              e: 1
	    n: 2	              i: 1
	
可以给这些字节都分配一个位字符串。字节出现的越频繁，我们就分配越少的位给它。可能会得到像这样的东西：

	space: 5    010           u: 1    11001
	    o: 5    000	          h: 1    10001
	    s: 4    101	          d: 1    11010
	    m: 3    111	          a: 1    11011
	    w: 3    0010	      y: 1    01111
	    c: 2    0011	      p: 1    11000
	    r: 2    1001	      e: 1    01110
	    n: 2    0110	      i: 1    10000

现在如果我们用这些位字符串来代替原来的字节，压缩之后的输出就是这样的：

	101 000 010 111 11001 0011 10001 010 0010 000 1001 11010 101 
	s   o   _   m   u     c    h     _   w    o   r    d     s
	
	010 0010 000 0010 010 111 11011 0110 01111 010 0011 000 111
	_   w    o   w    _   m   a     n    y     _   c    o   m
	
	11000 1001 01110 101 101 10000 000 0110 0
	p     r    e     s   s   i     o   n

最后的额外的 0 位是为了填满一个字节。我们可以将原来 34 字节的数据压缩成 16 个字节，节省了超过 50% 的空间！

但是等等...为了编码这些位，我们需要有原始的频率表。这个表需要被传输或者随着压缩的数据一块保存，否则解码者不知道如何翻译这些位。由于有频率表的开销（大概 1 千字节），在非常小的输入上用哈夫曼编码就不太值得了。

## 如何工作

当压缩一串字节的时候，算法首先创建一个频率表来计算每个字节出现的次数。在频率表的基础上，它会创建一颗二叉树来描述每个输入字节的位字符串。

对我们的例子来说，树会是这样的：

![The compression tree](Images/Tree.png)

注意，树有 16 个叶子节点（灰色的），每一个都代表一个输入的字节值。每个叶子节点也展示了它出现的次数。其他节点是 “中间” 节点。这些节点里的数字表示的事它的子节点的计数。根节点的计数就是输入的字节总数。

节点之间的边要是是 "1" 要么是 "0"。这些是与叶子节点的位编码相关的。注意到了嘛，左边的分支总是 1，而右边的分支总是 0。

压缩就是一个遍历输入字节的事情，对于每一个字节来说，从根节点开始遍历这棵树到那个字节所在的叶子节点。每次走左分支就发出一个 1 位。当走右边的分支时，就发出 0 位。
 
例如，为了从根节点到 `c`，先走右边 （`0`），还是右边 （`0`），左边 （`1`），还是左边（`1`）。所以 `c` 的哈夫曼码就是 `0011`。

解码就是相反的操作了。一个个读取压缩的位，然后遍历树直到到达一个叶子节点。叶子节点的值就是解压之后的字节。例如，如果位是 `11010`，从根节点开始，先走左边，还是左边，右边，左边，最后是右边到了 `d` =。

## 代码

在进入真正的哈夫曼编码之前，有一个能够将单独的位写入 `NSData` 对象的辅助方法是很有用的。`NSData` 能够理解的最小数据是字节，但是我们需要处理的是位，所以我们需要在他们之间做一些转换。

```swift
public class BitWriter {
  public var data = NSMutableData()
  var outByte: UInt8 = 0
  var outCount = 0

  public func writeBit(bit: Bool) {
    if outCount == 8 {
      data.append(&outByte, length: 1)
      outCount = 0
    }
    outByte = (outByte << 1) | (bit ? 1 : 0)
    outCount += 1
  }

  public func flush() {
    if outCount > 0 {
      if outCount < 8 {
        let diff = UInt8(8 - outCount)
        outByte <<= diff
      }
      data.append(&outByte, length: 1)
    }
  }
}
```

为了将位添加到 `NSData` 里需要调用 `writeBit()`。它会将每个新位加入到 `outByte` 变量中。一旦写入了 8 位，`outByte` 就真的添加到 `NSData` 里了。

`flush()` 方法是用来输出最后的字节的。并不能保证最后压缩的位正好是 8 的倍数，这样的话，在最后就有一些空的位。如果这样的话，`flush()` 会讲 0 添加到最后以填满一个字节。

我们会用一个相似的辅助方法来从 `NSData` 中读取耽搁的位：

```swift
public class BitReader {
  var ptr: UnsafePointer<UInt8>
  var inByte: UInt8 = 0
  var inCount = 8

  public init(data: NSData) {
    ptr = data.bytes.assumingMemoryBound(to: UInt8.self)
  }

  public func readBit() -> Bool {
    if inCount == 8 {
      inByte = ptr.pointee    // load the next byte
      inCount = 0
      ptr = ptr.successor()
    }
    let bit = inByte & 0x80  // read the next bit
    inByte <<= 1
    inCount += 1
    return bit == 0 ? false : true
  }
}
```

工作的方式都是一样的。从 `NSData` 中读取一整个字节，然后将它放入 `inByte`。然后 `readBit()` 就会返回那个字节里的单个位。一旦 `readBit()` 调用了 8 次，就从 `NSData` 里读取下个字节。

> **注意：** 如果你堆这些位操作不熟悉的话并不是什么了不起的事情。只要知道这两个辅助方法可以简化我们读写对象的位，不用担心任何保证他们最后都在正确位置的麻烦事情。

## 频率表

哈夫曼压缩的第一步就是读取整个输入流并且构建频率表。这个表包含了所有 256 个可能的字节值以及他们在输入数据中出现的频率。

可以将这个频率信息存储在字典或者数组里，但是既然无论如何都要构建一棵树，我们就将频率表作为树的叶子来存储。

下面是我们需要的定义：

```swift
class Huffman {
  typealias NodeIndex = Int
 
  struct Node {
    var count = 0
    var index: NodeIndex = -1
    var parent: NodeIndex = -1
    var left: NodeIndex = -1
    var right: NodeIndex = -1
  }

  var tree = [Node](repeating: Node(), count: 256)

  var root: NodeIndex = -1
}
```

树结构是存储在 `tree` 数组里的，由 `Node` 对象组成。由于这个是一个[二叉树](../Binary%20Tree/README-CN.markdown)，每个节点需要有两个子节点， `left` 和 `right`，以及一个指向 `parent` 节点的引用。然而，与普通的二叉树不一样的是，这些节点不是用指针来指向其他节点而是 `tree` 数组中的索引来互相引用。（我们也存储 节点本身的 `index`；到后面的时候就知道这样做的原因了）

现在 `tree` 有可以存储 256 个元素的空间。这些是给叶子节点用的，因为有 256 个可能的字节值。当然，并不是所有这些都被用到了，这要取决于输入的数据。后面，在构建树的过程中还会增加更多的节点。这个时候还没有树呢，只是 256 个没有建立连接的单独的叶子节点。所有节点的计数都是 0。

我们用下面的方法来计算每个字节在输入数据中出现的频率：

```swift
  fileprivate func countByteFrequency(inData data: NSData) {
    var ptr = data.bytes.assumingMemoryBound(to: UInt8.self)
    for _ in 0..<data.length {
      let i = Int(ptr.pointee)
      tree[i].count += 1
      tree[i].index = i
      ptr = ptr.successor()
    }
  }
```

这一步就是从头到尾遍历 `NSData` 对象，对于每一个字节，增加它所对应的叶子节点的 `count` 值。这就是所有它要做的。在 `countByteFrequency()` 完成之后，`tree` 数组里的最开始的 256 个 `Node` 对象就是频率表。

现在，我提到过要解码哈夫曼编码的数据块也需要原始的频率表。如果将压缩后的数据写入一个文件，那么在文件的某个地方也要包含这个频率表。

可以简单的将 `tree` 数组最开始的 256 个元素到过去，但是这个就没有什么效率了。可能并不是所有的 256 个元素都被使用了，再加上你也不需要序列化 `parent`, `right`, 和 `left` 指针。我们需要的只是频率信息，而不是整个树。

反之，我们会增加一个方法来导出一个没有我们不需要的信息的频率表：

```swift
  struct Freq {
    var byte: UInt8 = 0
    var count = 0
  }
  
  func frequencyTable() -> [Freq] {
    var a = [Freq]()
    for i in 0..<256 where tree[i].count > 0 {
      a.append(Freq(byte: UInt8(i), count: tree[i].count))
    }
    return a
  }
```

`frequencyTable()` 方法查找树中最开始的 256 个节点但是只保留那些我们需要的，没有 `parent`, `left`, 和 `right` 指针。返回一个 `Freq` 对象数组。你需要将这个和压缩后的数据一起序列化以便后面正确地解压缩。

## 树

作为一个提醒，有一个这个例子的压缩树：

![The compression tree](Images/Tree.png)

叶子节点表示的是输入数据中有的实际的字节。中间节点以这样的方式连接叶子，使得从根到频繁使用的字节值的路径比不频繁使用的更短。就像你看到的，`m`, `s`, 空格, 和 `o` 是我们的输入数据中最常用的字母，因此他们在树的最高的地方。

为了构建树，需要这样做：

1. 找到两个还没有父节点的最小计数的节点。
2. 创建一个父节点将这两个节点连起来
3. 重复这个过程直到只有一个节点没有父节点。这就是树的根节点

这是一个使用 [优先队列](../Priority%20Queue/README-CN.markdown) 的理想场所。优先队列是优化了以便更快地查找最小值。在这里，我们需要频繁地查找最小计数的节点。

函数 `buildTree()` 就变成了这样：

```swift
  fileprivate func buildTree() {
    var queue = PriorityQueue<Node>(sort: { $0.count < $1.count })
    for node in tree where node.count > 0 {
      queue.enqueue(node)                            // 1
    }

    while queue.count > 1 {
      let node1 = queue.dequeue()!                   // 2
      let node2 = queue.dequeue()!

      var parentNode = Node()                        // 3
      parentNode.count = node1.count + node2.count
      parentNode.left = node1.index
      parentNode.right = node2.index
      parentNode.index = tree.count
      tree.append(parentNode)

      tree[node1.index].parent = parentNode.index    // 4
      tree[node2.index].parent = parentNode.index
      
      queue.enqueue(parentNode)                      // 5
    }

    let rootNode = queue.dequeue()!                  // 6
    root = rootNode.index
  }
```

下面是它如何一步步工作的：

1. 创建一个优先队列，将所有至少有一个计数的叶子节点入列。（如果计数是 0，那么这个字节的值就没有出现在输入数据里）`PriorityQueue` 对象通过他们的计数来对他们进行排序，这样具有最少计数的节点就总是在第一个出列。

2. 当队列中至少还有两个节点的时候，从队列里移除这两个节点。因为这是一个最小优先队列，这样我们就得到了两个还没有父节点的最小计数的节点。

3. 创建一个中间节点来连接 `node1` 和 `node2`。新节点的计数是 node1 和 node2 的计数的和。由于节点是通过数组索引而不是真的指针来连接的，我们用 `node1.index` 和 `node2.index` 来找到 `tree` 数组中的这些节点。（这就是为什么 `Node` 要自己知道自己的索引）

4. 将两个节点连接到他们的父节点。现在新的中间节点变成了树的一部分。

5. 将新的中间节点放回到队列里。这个时候我们就完成了 `node1` 和 `node2`，但是 `parentNode` 还需要连接到树中的其他节点。

6. 重复过程 2-5 直到队列中只有一个节点。这就是树的根节点，然后我们就结束了。

下面的动画展示的是上面这个过程：

![Building the tree](Images/BuildTree.gif)

> **注意：** 不用优先队列的话，可以不断得迭代遍历 `tree` 数组来找到最小的两个节点，但是这就使得压缩特别慢，**O(n^2)**。用优先队列的话，运行时间只要 **O(n log n)**，**n** 是节点个个数。

> **有趣的事实：** 由于二叉树的特点，如果我们有 *x* 个叶子节点，我们就最多只能添加 *x - 1* 个节点到这棵树，树不会有查过 511 个节点。

## 压缩

现在我们知道如何从频率表构建一颗压缩树，我们可以用它来压缩 `NSData` 对象的内容了。下面是代码：

```swift
  public func compressData(data: NSData) -> NSData {
    countByteFrequency(inData: data)
    buildTree()

    let writer = BitWriter()
    var ptr = data.bytes.assumingMemoryBound(to: UInt8.self)
    for _ in 0..<data.length {
      let c = ptr.pointee
      let i = Int(c)
      traverseTree(writer: writer, nodeIndex: i, childIndex: -1)
      ptr = ptr.successor()
    }
    writer.flush()
    return writer.data
  }
```
 
第一步就是调用 `countByteFrequency()` 来构建频率表，然后是 `buildTree()` 构建压缩树。同时也会创建一个 `BitWriter` 对象来写入单个的位数据。

然后它就开始循环遍历整个输入，对每个字节调用 `traverseTree()`。这个方法会遍历树的节点并且为每个节点写入 1 或者 0 位。最后，返回一个 `BitWriter` 的数据对象。

> **注意：** 压缩总是需要两次遍历整个输入数据：第一次是构建频率表，第二次是将字节转换成他们对应的压缩位序列。

有趣的事情发生在 `traverseTree()`。下面是递归方法：

```swift
  private func traverseTree(writer: BitWriter, nodeIndex h: Int, childIndex child: Int) {
    if tree[h].parent != -1 {
      traverseTree(writer: writer, nodeIndex: tree[h].parent, childIndex: h)
    }
    if child != -1 {
      if child == tree[h].left {
        writer.writeBit(bit: true)
      } else if child == tree[h].right {
        writer.writeBit(bit: false)
      }
    }
  }
```

当从 `compressData()` 里调用这个方法的时候，`nodeIndex` 是我们要编码的字节的叶子节点在数组中的索引。这个方法递归地从叶子节点走到树的根节点，然后再回来。

在我们从根节点回到叶子节点的过程中，对于每一个遇到的节点我们会写入 1 或者 0 位。如果子节点是左节点，我们就写 1，如果是右节点，我们就写 0。

用图片来表示的话就是：

![How compression works](Images/Compression.png)

Even though the illustration of the tree shows a 0 or 1 for each edge between the nodes, the bit values 0 and 1 aren't actually stored in the tree! The rule is that we write a 1 bit if we take the left branch and a 0 bit if we take the right branch, so just knowing the direction we're going in is enough to determine what bit value to write.

可以像下面这样使用 `compressData()` 方法：

```swift
let s1 = "so much words wow many compression"
if let originalData = s1.dataUsingEncoding(NSUTF8StringEncoding) {
  let huffman1 = Huffman()
  let compressedData = huffman1.compressData(originalData)
  print(compressedData.length)
}
```

## 解压缩

解压缩很像压缩的发操作。然而，压缩厚的位在没有频率表时对我们来说没有任何用途。之前已经看到了返回 `Freq` 对象的 `frequencyTable()` 方法。思想是这样的，如果你要将压缩后的数据写入一个文件或者将它通过互联网发送出去的，要带着 `[Freq]` 数组一块保存。

我们首先需要一些方法来将 `[Freq]` 数组变成一颗压缩树。幸运的是，这非常简单：

```swift
  fileprivate func restoreTree(fromTable frequencyTable: [Freq]) {
    for freq in frequencyTable {
      let i = Int(freq.byte)
      tree[i].count = freq.count
      tree[i].index = i
    }
    buildTree()
  }
```

我们将 `Freq` 对象转换成叶子节点然后调用 `buildTree()` 来完成剩下的。

下面是 `decompressData()`，输入一个哈夫曼编码位的 `NSData` 对象，和一个频率表，然后返回原始数据：

```swift
  func decompressData(data: NSData, frequencyTable: [Freq]) -> NSData {
    restoreTree(fromTable: frequencyTable)

    let reader = BitReader(data: data)
    let outData = NSMutableData()
    let byteCount = tree[root].count

    var i = 0
    while i < byteCount {
      var b = findLeafNode(reader: reader, nodeIndex: root)
      outData.append(&b, length: 1)
      i += 1
    }
    return outData
  }
```

这里同样也使用了一个辅助方法来遍历树：

```swift
  private func findLeafNode(reader reader: BitReader, nodeIndex: Int) -> UInt8 {
    var h = nodeIndex
    while tree[h].right != -1 {
      if reader.readBit() {
        h = tree[h].left
      } else {
        h = tree[h].right
      }
    }
    return UInt8(h)
  }
```

`findLeafNode()` 根据给定的 `nodeIndex` 从根节点往下走到叶子节点。在每一个中间节点我们都读取一位然后走到左（位是 1）或 右（位是 0）节点。当到达叶子节点的时候，就简单的返回它的索引，它就等于原始的字节值。

用图片来表示的话就是这样的：

![How decompression works](Images/Decompression.png)

下面是如何使用解压缩方法：

```swift
  let frequencyTable = huffman1.frequencyTable()
  
  let huffman2 = Huffman()
  let decompressedData = huffman2.decompressData(compressedData, frequencyTable: frequencyTable)
  
  let s2 = String(data: decompressedData, encoding: NSUTF8StringEncoding)!
```

首先你从某处得到了频率表（这里就是我们用来编码数据的 `Huffman` 对象）然后调用 `decompressData()`。最后的结果字符串应该与最开始压缩的字符串是相等的。

可以在 playground 里看看它是如何工作的。

## 参考

[Huffman coding at Wikipedia](https://en.wikipedia.org/wiki/Huffman_coding)

有点代码是基于 Stevens 的 C 编程，来自于 Dr.Dobb's 杂志, 二月 1991 and 十月 1992

*作者：Matthijs Hollemans 翻译：Daisy*


