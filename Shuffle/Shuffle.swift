import Foundation

extension Array {
  /*
    Randomly shuffles the array in-place
    This is the Fisher-Yates algorithm, also known as the Knuth shuffle.
    Time complexity: O(n)
  */
  public mutating func shuffle() {
    for i in (count - 1).stride(through: 1, by: -1) {
      let j = random(i + 1)
      if i != j {
        swap(&self[i], &self[j])
      }
    }
  }
}

/*
  Simultaneously initializes an array with the values 0...n-1 and shuffles it.
*/
public func shuffledArray(n: Int) -> [Int] {
  var a = [Int](count: n, repeatedValue: 0)
  for i in 0..<n {
    let j = random(i + 1)
    if i != j {
      a[i] = a[j]
    }
    a[j] = i  // insert next number from the sequence
  }
  return a
}
