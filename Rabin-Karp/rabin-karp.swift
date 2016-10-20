// The MIT License (MIT)

// Copyright (c) 2016 Bill Barbour (brbatwork[at]gmail.com)

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

struct Constants {
    static let hashMultiplier = 69069
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
    let patternArray = pattern.characters.flatMap { $0.asInt }
    let textArray = text.characters.flatMap { $0.asInt }

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
