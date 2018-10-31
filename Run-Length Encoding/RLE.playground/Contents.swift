//: Playground - noun: a place where people can play

import Foundation

let originalString = "aaaaabbbcdeeeeeeef"
let utf8 = originalString.data(using: String.Encoding.utf8)!
let compressed = utf8.compressRLE()

let decompressed = compressed.decompressRLE()
let restoredString = String(data: decompressed, encoding: String.Encoding.utf8)
originalString == restoredString

func encodeAndDecode(_ bytes: [UInt8]) -> Bool {
    var bytes = bytes

    var data1 = Data(bytes: &bytes, count: bytes.count)
    print("data1 is \(data1.count) bytes")

    var rleData = data1.compressRLE()
    print("encoded data is \(rleData.count) bytes")

    var data2 = rleData.decompressRLE()
    print("data2 is \(data2.count) bytes")

    return data1 == data2
}

func testEmpty() -> Bool {
    let bytes: [UInt8] = []
    return encodeAndDecode(bytes)
}

func testOneByteWithLowValue() -> Bool {
    let bytes: [UInt8] = [0x80]
    return encodeAndDecode(bytes)
}

func testOneByteWithHighValue() -> Bool {
    let bytes: [UInt8] = [0xD0]
    return encodeAndDecode(bytes)
}

func testSimpleCases() -> Bool {
    let bytes: [UInt8] = [
        0x00,
        0x20, 0x20, 0x20, 0x20, 0x20,
        0x30,
        0x00, 0x00,
        0xC0,
        0xC1,
        0xC0, 0xC0, 0xC0,
        0xFF, 0xFF, 0xFF, 0xFF
    ]
    return encodeAndDecode(bytes)
}

func testBufferWithoutSpans() -> Bool {
    // There is nothing that can be encoded in this buffer, so the encoded
    // data ends up being longer.
    var bytes: [UInt8] = []
    for i in 0..<1024 {
        bytes.append(UInt8(i % 256))
    }
    return encodeAndDecode(bytes)
}

func testBufferWithSpans(_ spanSize: Int) -> Bool {
    print("span size \(spanSize)")

    let length = spanSize * 32
    var bytes: [UInt8] = Array<UInt8>(repeating: 0, count: length)

    for t in stride(from: 0, to: length, by: spanSize) {
        for i in 0..<spanSize {
            bytes[t + i] = UInt8(t % 256)
        }
    }
    return encodeAndDecode(bytes)
}

func testRandomByte() -> Bool {
    let length = 1 + Int(arc4random_uniform(2048))
    var bytes: [UInt8] = []
    for _ in 0..<length {
        bytes.append(UInt8(arc4random() % 256))
    }
    return encodeAndDecode(bytes)
}

func runTests() -> Bool {
    var tests: [Bool] = [
        testEmpty(),
        testOneByteWithLowValue(),
        testOneByteWithHighValue(),
        testSimpleCases(),
        testBufferWithoutSpans(),
        testBufferWithSpans(4),
        testBufferWithSpans(63),
        testBufferWithSpans(64),
        testBufferWithSpans(65),
        testBufferWithSpans(66),
        testBufferWithSpans(80)
    ]
    for _ in 0..<10 {
        let result = testRandomByte()
        tests.append(result)
    }
    var result = true
    for bool in tests {
        result = result && bool
    }

    return result
}

runTests()
