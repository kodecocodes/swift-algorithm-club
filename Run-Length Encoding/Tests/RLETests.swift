import XCTest

class RLETests: XCTestCase {
  private var showExtraOutput = false

  private func dumpData(data: NSData) {
    if showExtraOutput {
      var ptr = UnsafePointer<UInt8>(data.bytes)
      for _ in 0..<data.length {
        print(String(format: "%02x", ptr.memory))
        ptr = ptr.advancedBy(1)
      }
    }
  }

  private func encodeAndDecode(bytes: [UInt8]) {
    var bytes = bytes

    let data1 = NSMutableData(bytes: &bytes, length: bytes.count)
    print("data1 is \(data1.length) bytes")
    dumpData(data1)

    let rleData = data1.compressRLE()
    print("encoded data is \(rleData.length) bytes")
    dumpData(rleData)

    let data2 = rleData.decompressRLE()
    print("data2 is \(data2.length) bytes")
    dumpData(data2)

    XCTAssertEqual(data1, data2)
    print("")
  }

  func testEmpty() {
    let bytes: [UInt8] = []
    encodeAndDecode(bytes)
  }

  func testOneByteWithLowValue() {
    let bytes: [UInt8] = [ 0x80 ]
    encodeAndDecode(bytes)
  }

  func testOneByteWithHighValue() {
    let bytes: [UInt8] = [ 0xD0 ]
    encodeAndDecode(bytes)
  }

  func testSimpleCases() {
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
    encodeAndDecode(bytes)
  }

  func testBufferWithoutSpans() {
    // There is nothing that can be encoded in this buffer, so the encoded
    // data ends up being longer.

    var bytes: [UInt8] = []
    for i in 0..<1024 {
      bytes.append(UInt8(i % 256))
    }
    encodeAndDecode(bytes)
  }

  func bufferWithSpans(spanSize: Int) {
    if showExtraOutput {
      print("span size \(spanSize)")
    }

    let length = spanSize * 32
    var bytes: [UInt8] = .init(count: length, repeatedValue: 0)

    for t in 0.stride(to: length, by: spanSize) {
      for i in 0..<spanSize {
        bytes[t + i] = UInt8(t % 256)
      }
    }
    encodeAndDecode(bytes)
  }

  func testBufferWithSpans() {
    bufferWithSpans(4)
    bufferWithSpans(63)
    bufferWithSpans(64)
    bufferWithSpans(65)
    bufferWithSpans(66)
    bufferWithSpans(80)
  }

  func testRandomBytes() {
    for _ in 0..<10 {
      let length = 1 + Int(arc4random_uniform(2048))
      var bytes: [UInt8] = []
      for _ in 0..<length {
        bytes.append(UInt8(arc4random() % 256))
      }
      encodeAndDecode(bytes)
    }
  }
}
