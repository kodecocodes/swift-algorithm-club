//: Playground - noun: a place where people can play
// Last checked with: Version 9.0 beta 4 (9M189t)
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

func twoSum(_ numbers: [Int], target: Int) -> (Int, Int)? {
  var dict: [Int: Int] = [:]
  
  for (index, number) in numbers.enumerated() {
    if let otherIndex = dict[number] {
      return (index, otherIndex)
    } else {
      dict[target - number] = index
    }
  }
  
  return nil
}

let numbers = [3, 2, 4]
let target = 6

twoSum(numbers, target: target) // expected output: indices 2 and 1
