import Foundation

extension NSData {
  /*
    Helper method that reads the next run of bytes. Returns the size of the
    run (between 1 and 64), the byte value, and the updated read pointer.
  */
  private func readRun(start start: UnsafePointer<UInt8>, end: UnsafePointer<UInt8>) -> (Int, UInt8, UnsafePointer<UInt8>) {
    var ptr = start
    var count = 0

    // Read the current byte.
    let previous = ptr.memory
    var current = previous

    // Is the next byte the same? Then keep reading until we find another
    // byte, or we reach the end of the data, or the run is 64 bytes.
    while current == previous && ptr < end && count < 64 {
      ptr = ptr.advancedBy(1)
      current = ptr.memory
      count += 1
    }
    
    return (count, previous, ptr)
  }

  /*
    Compresses the NSData using run-length encoding.
  */
  public func compressRLE() -> NSData {
    let data = NSMutableData()
    if length > 0 {
      var ptr = UnsafePointer<UInt8>(bytes)
      let end = ptr + length
      
      while ptr < end {
        var (count, byte, out) = readRun(start: ptr, end: end)

        if count == 0 {                        // end-of-file
          out = end
        } else if count > 1 || byte >= 192 {   // byte run, up to 64 repeats
          var pair: [UInt8] = [191 + UInt8(count), byte]
          data.appendBytes(&pair, length: 2)
        } else {                               // single byte between 0 and 192
          data.appendBytes(&byte, length: 1)
        }
        ptr = out
      }
    }
    return data
  }
  

  /*
    Converts a run-length encoded NSData back to the original.
  */
  public func decompressRLE() -> NSData {
    return NSData()
  }
}
