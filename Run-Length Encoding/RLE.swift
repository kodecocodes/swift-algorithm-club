import Foundation

extension NSData {
  /*
    Compresses the NSData using run-length encoding.
  */
  public func compressRLE() -> NSData {
    let data = NSMutableData()
    if length > 0 {
      var ptr = UnsafePointer<UInt8>(bytes)
      let end = ptr + length

      while ptr < end {
        var count = 0
        var byte = ptr.memory
        var next = byte

        // Is the next byte the same? Keep reading until we find a different
        // value, or we reach the end of the data, or the run is 64 bytes.
        while next == byte && ptr < end && count < 64 {
          ptr = ptr.advancedBy(1)
          next = ptr.memory
          count += 1
        }

        if count > 1 || byte >= 192 {         // byte run of up to 64 repeats
          var size = 191 + UInt8(count)
          data.appendBytes(&size, length: 1)
          data.appendBytes(&byte, length: 1)
        } else {                              // single byte between 0 and 192
          data.appendBytes(&byte, length: 1)
        }
      }
    }
    return data
  }

  /*
    Converts a run-length encoded NSData back to the original.
  */
  public func decompressRLE() -> NSData {
    let data = NSMutableData()
    if length > 0 {
      var ptr = UnsafePointer<UInt8>(bytes)
      let end = ptr + length

      while ptr < end {
        // Read the next byte. This is either a single value less than 192,
        // or the start of a byte run.
        var byte = ptr.memory
        ptr = ptr.advancedBy(1)

        if byte < 192 {                       // single value
          data.appendBytes(&byte, length: 1)

        } else if ptr < end {                 // byte run
          // Read the actual data value.
          var value = ptr.memory
          ptr = ptr.advancedBy(1)

          // And write it out repeatedly.
          for _ in 0 ..< byte - 191 {
            data.appendBytes(&value, length: 1)
          }
        }
      }
    }
    return data
  }
}
