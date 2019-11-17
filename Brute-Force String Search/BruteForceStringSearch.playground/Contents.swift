//: Playground - noun: a place where people can play

// last checked with Xcode 11.0
#if swift(>=5.0)
print("Hello, Swift 5!")
#endif

extension String {
  func indexOf(_ pattern : String) -> String.Index? {
    let noOfLoops = self.count - pattern.count + 1
    for i in 0..<noOfLoops {
      for (index,char) in pattern.enumerated() {
        if char == Array(self)[i + index] {
          if index == pattern.count - 1 {
            //Pattern found in the string
            return self.index(self.startIndex, offsetBy: i)
          }
        } else {
          break
        }
      }
    }
    return nil
  }
}

// A few simple tests

let testString = "Hello, World"
if let foundIndex = testString.indexOf("World") {
  print(testString.distance(from: testString.startIndex, to: foundIndex)) // 7
} else {
  print("Pattern not found")
}


let testString2 = "3453853454444555553"
if let foundIndex = testString2.indexOf("44") {
  print(testString2.distance(from: testString2.startIndex, to: foundIndex)) // 9
} else {
  print("Pattern not found")
}

let animals = "🐶🐔🐷🐮🐱"
if let foundIndex = animals.indexOf("🐮") {
  print(animals.distance(from: animals.startIndex, to: foundIndex)) // 3
} else {
  print("Pattern not found")
}


