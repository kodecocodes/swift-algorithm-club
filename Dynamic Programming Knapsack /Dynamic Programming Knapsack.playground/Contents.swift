import Foundation

var numberOfItems = Int()
var capacityOfBag = Int()
var items = [Int]()
var values = [Int]()
var dp = [[Int]]()

func knapsack() -> Int {
    dp = Array(repeating: Array(repeating: 0, count: capacityOfBag+1),
               count: numberOfItems+1)
    for i in 0...numberOfItems {
        for j in 0...capacityOfBag {
            if i == 0 || j == 0 {
                continue
            }
            if j<items[i] {
                dp[i][j] = dp[i-1][j]
            } else {
                dp[i][j] = max(values[i] + dp[i-1][j-items[i]], dp[i-1][j])
            }
        }
    }
    return dp[numberOfItems][capacityOfBag]
}

func solution() {
    
    capacityOfBag = 4
    numberOfItems = 5
    
    items = [0, 1, 2, 3, 2, 2]
    values = [0, 8, 4, 0, 5, 3]
    
    let result = knapsack()
    
    print(result)
}

solution()
