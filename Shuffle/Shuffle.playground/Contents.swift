//: Playground - noun: a place where people can play

import Foundation

/* Returns a random integer between 0 and n-1. */
public func random(_ n: Int) -> Int {
  return Int(arc4random_uniform(UInt32(n)))
}



/* Fisher-Yates / Knuth shuffle */
extension Array {
  public mutating func shuffle() {
    for i in stride(from: count - 1, through: 1, by: -1) {
      let j = random(i + 1)
      if i != j {
        swap(&self[i], &self[j])
      }
    }
  }
}

var list = [ "a", "b", "c", "d", "e", "f", "g" ]
list.shuffle()
list.shuffle()
list.shuffle()



/* Create a new array of numbers that is already shuffled. */
public func shuffledArray(_ n: Int) -> [Int] {
  var a = [Int](repeating: 0, count: n)
  for i in 0..<n {
    let j = random(i + 1)
    if i != j {
      a[i] = a[j]
    }
    a[j] = i
  }
  return a
}

let numbers = shuffledArray(10)
