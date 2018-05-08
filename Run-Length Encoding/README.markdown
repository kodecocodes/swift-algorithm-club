# Run-Length Encoding (RLE)

RLE is probably the simplest way to do compression. Let's say you have data that looks like this:

	aaaaabbbcdeeeeeeef...

then RLE encodes it as follows:

	5a3b1c1d7e1f...

Instead of repeating bytes, you first write how often that byte occurs and then the byte's actual value. So `5a` means `aaaaa`. If the data has a lot of "byte runs", that is lots of repeating bytes, then RLE can save quite a bit of space. It works quite well on images.

There are many different ways you can implement RLE. Here's an extension of `Data` that does a version of RLE inspired by the old [PCX image file format](https://en.wikipedia.org/wiki/PCX).

The rules are these:

- Each byte run, i.e. when a certain byte value occurs more than once in a row, is compressed using two bytes: the first byte records the number of repetitions, the second records the actual value. The first byte is stored as: `191 + count`. This means encoded byte runs can never be more than 64 bytes long.

- A single byte in the range 0 - 191 is not compressed and is copied without change.

- A single byte in the range 192 - 255 is represented by two bytes: first the byte 192 (meaning a run of 1 byte), followed by the actual value.

Here is the compression code. It returns a new `Data` object containing the run-length encoded bytes:

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
 }
```

How it works:

1. We use an `UnsafePointer` to step through the bytes of the original `Data` object.

2. At this point we've read the current byte value into the `byte` variable. If the next byte is the same, then we keep reading until we find a byte value that is different, or we reach the end of the data. We also stop if the run is 64 bytes because that's the maximum we can encode.

3. Here, we have to decide how to encode the bytes we just read. The first possibility is that we've read a run of 2 or more bytes (up to 64). In that case we write out two bytes: the length of the run followed by the byte value. But it's also possible we've read a single byte with a value >= 192. That will also be encoded with two bytes.

4. The third possibility is that we've read a single byte < 192. That simply gets copied to the output verbatim.

You can test it like this in a playground:

```swift
let originalString = "aaaaabbbcdeeeeeeef"
let utf8 = originalString.data(using: String.Encoding.utf8)!
let compressed = utf8.compressRLE()
```

The compressed `Data` object should be `<c461c262 6364c665 66>`. Let's decode that by hand to see what has happened:

	c4    This is 196 in decimal. It means the next byte appears 5 times.
	61    The data byte "a".
	c2    The next byte appears 3 times.
	62    The data byte "b".
	63    The data byte "c". Because this is < 192, it's a single data byte.
	64    The data byte "d". Also appears just once.
	c6    The next byte will appear 7 times.
	65    The data byte "e".
	66    The data byte "f". Appears just once.

So that's 9 bytes encoded versus 18 original. That's a savings of 50%. Of course, this was only a simple test case... If you get unlucky and there are no byte runs at all in your original data, then this method will actually make the encoded data twice as large! So it really depends on the input data.

Here is the decompression code:

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

1. Again this uses an `UnsafePointer` to read the `Data`. Here we read the next byte; this is either a single value less than 192, or the start of a byte run.

2. If it's a single value, then it's just a matter of copying it to the output.

3. But if the byte is the start of a run, we have to first read the actual data value and then write it out repeatedly.

To turn the compressed data back into the original, you'd do:

```swift
let decompressed = compressed.decompressRLE()
let restoredString = String(data: decompressed, encoding: NSUTF8StringEncoding)
```

And now `originalString == restoredString` must be true!

Footnote: The original PCX implementation is slightly different. There, a byte value of 192 (0xC0) means that the following byte will be repeated 0 times. This also limits the maximum run size to 63 bytes. Because it makes no sense to store bytes that don't occur, in my implementation 192 means the next byte appears once, and the maximum run length is 64 bytes.

This was probably a trade-off when they designed the PCX format way back when. If you look at it in binary, the upper two bits indicate whether a byte is compressed. (If both bits are set then the byte value is 192 or more.) To get the run length you can simply do `byte & 0x3F`, giving you a value in the range 0 to 63.

*Written for Swift Algorithm Club by Matthijs Hollemans*
*Migrated to Swift3 by Jaap Wijnen*
