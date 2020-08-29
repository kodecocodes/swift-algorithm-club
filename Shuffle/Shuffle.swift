import Foundation

/* Returns a random integer between 0 and n-1. */
public func random(_ n: Int) -> Int {
  return Int(arc4random_uniform(UInt32(n)))
}

extension Array {
  /*
   Randomly shuffles the array in-place
   This is the Fisher-Yates algorithm, also known as the Knuth shuffle.
   Time complexity: O(n)
   */
  public mutating func shuffle() {
    for i in (1...count-1).reversed() {
      let j = random(i + 1)
      if i != j {
        let t = self[i]
        self[i] = self[j]
        self[j] = t
      }
    }
  }
}

/*
 Simultaneously initializes an array with the values 0...n-1 and shuffles it.
 */
public func shuffledArray(_ n: Int) -> [Int] {
  var a = Array(repeating: 0, count: n)
  for i in 0..<n {
    let j = random(i + 1)
    a[i] = a[j]
    a[j] = i  // insert next number from the sequence
  }
  return a
}

