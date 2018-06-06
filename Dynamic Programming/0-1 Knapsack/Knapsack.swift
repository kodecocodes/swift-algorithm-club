import Foundation

struct KnapsackItem {
    
    var weight: Int
    var value: Int
    
    init(weight: Int, value: Int) {
        self.weight = weight
        self.value = value
    }
}

public final class Knapsack {
    
    var capacityOfBag:Int
    var knapsackItems: [KnapsackItem]
    
    init(capacityOfBag: Int, knapsackItems: [KnapsackItem]) {
        self.capacityOfBag = capacityOfBag
        self.knapsackItems = knapsackItems
    }
    
    func knapsack() -> Int {
        
        var tableOfValues = [[Int]]()
        
        tableOfValues = Array(repeating: Array(repeating: 0, count: capacityOfBag+1),
                              count: knapsackItems.count+1)
        
        for itemIndex in 1...knapsackItems.count {
            for totalWeight in 1...capacityOfBag {
                
                if totalWeight < knapsackItems[itemIndex-1].weight {
                    tableOfValues[itemIndex][totalWeight] = tableOfValues[itemIndex-1][totalWeight]
                } else {
                    let remainingCapacity = totalWeight - knapsackItems[itemIndex-1].weight
                    tableOfValues[itemIndex][totalWeight] = max(knapsackItems[itemIndex-1].value + tableOfValues[itemIndex-1][remainingCapacity], tableOfValues[itemIndex-1][totalWeight])
                }
            }
        }
        return tableOfValues[knapsackItems.count][capacityOfBag]
    }
}
