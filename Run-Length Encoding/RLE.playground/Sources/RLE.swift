import Foundation

extension Data {
    /*
     Compresses the NSData using run-length encoding.
     */
    public func compressRLE() -> Data {
        var data = Data()
        self.withUnsafeBytes { (uPtr: UnsafePointer<UInt8>) in
            var ptr = uPtr
            let end = ptr + count
            while ptr < end {
                var count = 0
                var byte = ptr.pointee
                var next = byte

                // Is the next byte the same? Keep reading until we find a different
                // value, or we reach the end of the data, or the run is 64 bytes.
                while next == byte && ptr < end && count < 64 {
                    ptr = ptr.advanced(by: 1)
                    next = ptr.pointee
                    count += 1
                }

                if count > 1 || byte >= 192 {       // byte run of up to 64 repeats
                    var size = 191 + UInt8(count)
                    data.append(&size, count: 1)
                    data.append(&byte, count: 1)
                } else {                            // single byte between 0 and 192
                    data.append(&byte, count: 1)
                }
            }
        }
        return data
    }

    /*
     Converts a run-length encoded NSData back to the original.
     */
    public func decompressRLE() -> Data {
        var data = Data()
        self.withUnsafeBytes { (uPtr: UnsafePointer<UInt8>) in
            var ptr = uPtr
            let end = ptr + count

            while ptr < end {
                // Read the next byte. This is either a single value less than 192,
                // or the start of a byte run.
                var byte = ptr.pointee
                ptr = ptr.advanced(by: 1)

                if byte < 192 {                     // single value
                    data.append(&byte, count: 1)
                } else if ptr < end {               // byte run
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
}
