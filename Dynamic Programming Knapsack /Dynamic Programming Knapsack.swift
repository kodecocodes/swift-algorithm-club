var number_of_items = Int()
var capacity_of_bag = Int()
var weights_items = [Int]()
var values_items = [Int]()
var dp = [[Int]]()

func knapsack() -> Int {
    dp = Array(repeating: Array(repeating: 0, count: capacity_of_bag+1),
               count: number_of_items+1)
    for i in 0...number_of_items {
        for j in 0...capacity_of_bag {
            if i == 0 || j == 0 {
                dp[i][j] = 0
                continue
            }
            if j<weights_items[i] {
                dp[i][j] = dp[i-1][j]
            } else {
                dp[i][j] = max(values_items[i] + dp[i-1][j-weights_items[i]], dp[i-1][j])
            }
        }
    }
    return dp[number_of_items][capacity_of_bag]
}
