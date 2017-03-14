import Foundation

class KnapsackItem: NSObject {
    var weight: Int
    var value: Int
    
    init(weight: Int, value: Int) {
        self.weight = weight
        self.value = value
    }
}

var capacityOfBag = Int()
var knapsackItems = [KnapsackItem]()

func knapsack() -> Int {
    
    var dp = [[Int]]()
    
    dp = Array(repeating: Array(repeating: 0, count: capacityOfBag+1),
               count: knapsackItems.count+1)
   
    for itemIndex in 1...knapsackItems.count {
        for totalWeight in 1...capacityOfBag {
            
            if totalWeight < knapsackItem.weight {
                dp[knapsackItem.weight][totalWeight] = dp[knapsackItem.weight][totalWeight]
            } else {
                dp[knapsackItem.weight][totalWeight] = max(knapsackItem.value + dp[knapsackItem.weight][totalWeight - knapsackItem.weight], dp[knapsackItem.weight][totalWeight])
            }
        }
    }
    return dp[knapsackItems.count][capacityOfBag]
}

func solution() {
    
    capacityOfBag = 50
    
    knapsackItems = [KnapsackItem(weight: 10, value: 20),
                         KnapsackItem(weight: 20, value: 30),
                         KnapsackItem(weight: 30, value: 120)]

    let result = knapsack()
    
    print(result)
}

solution()





