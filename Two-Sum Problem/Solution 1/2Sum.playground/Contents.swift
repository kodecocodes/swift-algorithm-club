//: Two Sum
// Last checked with: Version 9.0 (9A235)
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

twoSum([3, 2, 9, 8], target: 10) // expected output: indices 1 and 3
