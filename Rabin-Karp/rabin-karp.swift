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

public func hash(_ string: String) -> Int {
  return string.reduce(0) { (result: Int, character: Character) in
    result &+ character.hashValue
  }
}

public func nextHash(prevHash: Int, dropped: Character, added: Character) -> Int {
  return prevHash &- dropped.hashValue &+ added.hashValue
}

public func search(text: String, pattern: String) -> [String.Index] {
  if text.count < pattern.count { return [] }
  
  var indices = [String.Index]()
  
  let patternHash = hash(pattern)
  let patternLength = pattern.count - 1
  let offset = text.index(text.startIndex, offsetBy: patternLength)
  let firstText = String(text[...offset])
  let firstHash = hash(firstText)
  
  if patternHash == firstHash {
    if firstText == pattern {
      indices.append(text.startIndex)
    }
  }
  
  let start = text.index(after: text.startIndex)
  let end = text.index(text.endIndex, offsetBy: -patternLength)
  var prevHash = firstHash
  var i = start

  while i != end {
    let terminator = text.index(i, offsetBy: patternLength)
    let window = text[i...terminator]
    let prev = text.index(before: i)
    let windowHash = nextHash(prevHash: prevHash, dropped: text[prev], added: text[terminator])
    
    if windowHash == patternHash,
      pattern == window {
      indices.append(i)
    }
    
    prevHash = windowHash
    
    i = text.index(after: i)
  }
  
  return indices
}

// TESTS
assert(search(text:"The big dog jumped over the fox",
              pattern:"ump") == 13, "Invalid index returned")

assert(search(text:"The big dog jumped over the fox",
              pattern:"missed") == -1, "Invalid index returned")

assert(search(text:"The big dog jumped over the fox",
              pattern:"T") == 0, "Invalid index returned")
