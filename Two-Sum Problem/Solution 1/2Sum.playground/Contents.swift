//: Playground - noun: a place where people can play
// Last checked with: Version 9.0 beta 4 (9M189t)
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

func twoSum(_ nums: [Int], target: Int) -> (Int, Int)? {
    var dict = [Int: Int]()
    
    for (currentIndex, n) in nums.enumerated() {
        let complement = target - n
        
        if let complementIndex = dict[complement] {
            return (complementIndex, currentIndex)
        }
        
        dict[n] = currentIndex
    }
    
    return nil
}

let numbers = [3, 2, 8, 4]
let target = 6

twoSum(numbers, target: target) // expected output: indices 1 and 3
