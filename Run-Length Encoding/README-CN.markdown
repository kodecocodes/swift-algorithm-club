# 游程编码 (RLE)

RLE 可能是最简单的压缩方法。假如我们有像这样的数据：

	aaaaabbbcdeeeeeeef...

RLE 编码之后就是这样的：

	5a3b1c1d7e1f...

首先协商字节出现的频率然后是字节的实际值，而不是重复的字节。所以 `5a` 的意思就是 `aaaaa`。如果数据有很多 “字节行程”，也就是有很多重复的字节，那么 RLE 就可以节省很多存储空间。在图片的压缩中它工作的非常好。

有很多方法可以实现 RLE。这里是一个 `Data` 的扩展，灵感来自于老的 [PCX 图片文件格式](https://en.wikipedia.org/wiki/PCX)。

规则是这样的：

- 每个字节行程，即某个自己值在一行中不止出现一次，可以用两个字节来进行压缩：第一个字节记录重复的次数，第二个记录实际的值。第一个字节存储为：`191 + count`。这个意思就是编码的字节行程不能比64字节长。

- 在范围 0 - 191 里面的单个字节是不压缩的，直接拷贝。

- 在 192 - 255 范围内的单个字节就用两个字节进行压缩：第一个字节 192 （表示有一个字节行程），后面跟的是实际的值。

下面是压缩代码。它返回一个包含行程长度编码字节的 `Data` 对象：

```swift
extension Data {
    public func compressRLE() -> Data {
        var data = Data()
        self.withUnsafeBytes { (uPtr: UnsafePointer<UInt8>) in
            var ptr = uPtr
            let end = ptr + count
            while ptr < end { 						//1
                var count = 0
                var byte = ptr.pointee
                var next = byte

                while next == byte && ptr < end && count < 64 { //2
                    ptr = ptr.advanced(by: 1)
                    next = ptr.pointee
                    count += 1
                }

                if count > 1 || byte >= 192 {       // 3
                    var size = 191 + UInt8(count)
                    data.append(&size, count: 1)
                    data.append(&byte, count: 1)
                } else {                            // 4
                    data.append(&byte, count: 1)
                }
            }
        }
        return data
    }
```

它是如何工作的：

1. 用 `UnsafePointer` 来遍历原始数据 `Data` 对象的字节。

2. 这个时候我们就将当前字节读到 `byte` 变量里。如果下个字节是一样的，那就继续读取直到找到一个不一样的字节，或者是到了数据的结尾。如果行程到了 64 字节我们也会停止，因为这是我们能编码的最大数。

3. 这里我们就要决定如何编码已经读取的数据了。第一种可能就是我们读了 2 个或者更多的行程（最多 64）。这样的话我们就写入两个字节：行程长度后面跟着字节值。但也有可能是我们只读了一个 >= 192 的字节。这个也会编码成两个字节。
 
4. 第三种可能是我们读了一个 < 192 的字节。这时候只要简单逐字地拷贝到输出即可。

可以在 playground 中这样进行测试：

```swift
let originalString = "aaaaabbbcdeeeeeeef"
let utf8 = originalString.data(using: String.Encoding.utf8)!
let compressed = utf8.compressRLE()
```

压缩之后的 `Data` 对象应该是 `<c461c262 6364c665 66>`。我们来一步步编码一下看看到底发生了什么：

	c4    This is 196 in decimal. It means the next byte appears 5 times.
	61    The data byte "a".
	c2    The next byte appears 3 times.
	62    The data byte "b".
	63    The data byte "c". Because this is < 192, it's a single data byte.
	64    The data byte "d". Also appears just once.
	c6    The next byte will appear 7 times.
	65    The data byte "e".
	66    The data byte "f". Appears just once.

所以只用 9 个字节就编码了原来 18 个字节的数据。节省了 50% 的空间。当然，这只是一个简单的测试用例...如果你很不幸的话可能在原始数据中根本没有字节行程，那么这个方法就会让编码后的数据是原来的两倍大！所以这就真的要取决于输入的数据了。

下面是解压缩的代码：

```swift
public func decompressRLE() -> Data {
        var data = Data()
        self.withUnsafeBytes { (uPtr: UnsafePointer<UInt8>) in
            var ptr = uPtr
            let end = ptr + count

            while ptr < end {
                // Read the next byte. This is either a single value less than 192,
                // or the start of a byte run.
                var byte = ptr.pointee							// 1
                ptr = ptr.advanced(by: 1)

                if byte < 192 {                     // 2
                    data.append(&byte, count: 1)
                } else if ptr < end {               // 3
                    // Read the actual data value.
                    var value = ptr.pointee
                    ptr = ptr.advanced(by: 1)

                    // And write it out repeatedly.
                    for _ in 0 ..< byte - 191 {
                        data.append(&value, count: 1)
                    }
                }
            }
        }
        return data
    }

```

1. 再一次用了 `UnsafePointer` 来读取 `Data`。在这里我们读的是下一个字节；它要么是一个小于 192 的数据，要么是一个字节行程的开始。

2. 如果它是单个的数据，那么它就只是将它拷贝到输出即可。

3. 但如果字节是行程的开始，我们就要先读取实际的值然后反复将它写入到输入。

为了将压缩厚的数据变回到原来，可以这样做：

```swift
let decompressed = compressed.decompressRLE()
let restoredString = String(data: decompressed, encoding: NSUTF8StringEncoding)
```

现在 `originalString == restoredString` 一定就是真的！

备注：原来的 PCX 实现有一些不同。在那里，值为 192 的字节的意思是后面的字节重复了 0 次。这同时也见过最大行程数限制在 63 个字节了。因为没有必要存储不存在的字节，所以在我的实现里 192 就表示后接下来的字节出现了一次，并且最大行程长度是 64 字节。

当他们设计 PCX 格式时，这可能是一个权衡。如果用二进制来看的话，高位的两位表示是否一个字节被压缩了。（如果两个位都被设置的话，字节值就是 192 或者更大）为了得到行程长度，可以简单地做 `byte & 0x3F`，就可以得到一个 0 到 63 的值。


*作者：Matthijs Hollemans 翻译：Daisy*
*移植到 Swift 3：Jaap Wijnen*


