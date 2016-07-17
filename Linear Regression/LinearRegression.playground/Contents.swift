// Linear Regression

import Foundation

let carAge: [Double] = [10, 8, 3, 3, 2, 1]
let carPrice: [Double] = [500, 400, 7000, 8500, 11000, 10500]
var intercept = 10000.0
var slope = -1000.0
let alpha = 0.0001
let numberOfCarAdvertsWeSaw = carPrice.count

func h(carAge: Double) -> Double {
    return intercept + slope * carAge
}

for n in 1...10000 {
    for i in 1...numberOfCarAdvertsWeSaw {
        intercept += alpha * (carPrice[i-1] - h(carAge[i-1])) * 1
        slope += alpha * (carPrice[i-1] - h(carAge[i-1])) * carAge[i-1]
    }
}

print("A car age 4 years is predicted to be worth £\(Int(h(4)))")
