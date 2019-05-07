//: Taking our rabin-karp algorithm for a walk

// last checked with Xcode 9.4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

import UIKit

struct Constants {
    static let hashMultiplier = 69061
}

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence
func ** (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
func ** (radix: Double, power: Int) -> Double {
    return pow(radix, Double(power))
}

extension Character {
    var asInt: Int {
        let s = String(self).unicodeScalars
        return Int(s[s.startIndex].value)
    }
}

// Find first position of pattern in the text using Rabin Karp algorithm
public func search(text: String, pattern: String) -> Int {
    // convert to array of ints
    let patternArray = pattern.compactMap { $0.asInt }
    let textArray = text.compactMap { $0.asInt }

    if textArray.count < patternArray.count {
        return -1
    }

    let patternHash = hash(array: patternArray)
    var endIdx = patternArray.count - 1
    let firstChars = Array(textArray[0...endIdx])
    let firstHash = hash(array: firstChars)

    if patternHash == firstHash {
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
        let windowHash = nextHash(
          prevHash: prevHash,
          dropped: textArray[idx - 1],
          added: textArray[endIdx],
          patternSize: patternArray.count - 1
        )

        if windowHash == patternHash {
            if patternArray == window {
                return idx
            }
        }

        prevHash = windowHash
    }

    return -1
}

public func hash(array: Array<Int>) -> Double {
    var total: Double = 0
    var exponent = array.count - 1
    for i in array {
        total += Double(i) * (Double(Constants.hashMultiplier) ** exponent)
        exponent -= 1
    }

    return Double(total)
}

public func nextHash(prevHash: Double, dropped: Int, added: Int, patternSize: Int) -> Double {
    let oldHash = prevHash - (Double(dropped) *
      (Double(Constants.hashMultiplier) ** patternSize))
    return Double(Constants.hashMultiplier) * oldHash + Double(added)
}

// TESTS
assert(search(text:"The big dog jumped over the fox",
  pattern:"ump") == 13, "Invalid index returned")

assert(search(text:"The big dog jumped over the fox",
  pattern:"missed") == -1, "Invalid index returned")

assert(search(text:"The big dog jumped over the fox",
  pattern:"T") == 0, "Invalid index returned")
