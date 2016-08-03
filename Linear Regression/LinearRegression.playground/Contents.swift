// Linear Regression

import Foundation

let carAge: [Double] = [10, 8, 3, 3, 2, 1]
let carPrice: [Double] = [500, 400, 7000, 8500, 11000, 10500]
var intercept = 0.0
var slope = 0.0

func predictedCarPrice(carAge: Double) -> Double {
    return intercept + slope * carAge
}

// An iterative approach

let numberOfCarAdvertsWeSaw = carPrice.count
let numberOfIterations = 100
let alpha = 0.0001

for n in 1...numberOfIterations {
    for i in 0..<numberOfCarAdvertsWeSaw {
        let difference = carPrice[i] - predictedCarPrice(carAge[i])
        intercept += alpha * difference
        slope += alpha * difference * carAge[i]
    }
}

print("A car age of 4 years is predicted to be worth £\(Int(predictedCarPrice(4)))")

// A closed form solution

func average(input: [Double]) -> Double {
    return input.reduce(0, combine: +) / Double(input.count)
}

func multiply(input1: [Double], _ input2: [Double]) -> [Double] {
    return input1.enumerate().map({ (index, element) in return element*input2[index] })
}

func linearRegression(xVariable: [Double], _ yVariable: [Double]) -> (Double -> Double) {
    let sum1 = average(multiply(xVariable, yVariable)) - average(xVariable) * average(yVariable)
    let sum2 = average(multiply(xVariable, xVariable)) - pow(average(xVariable), 2)
    let slope = sum1 / sum2
    let intercept = average(yVariable) - slope * average(xVariable)
    return { intercept + slope * $0 }
}

let result = linearRegression(carAge, carPrice)(4)

print("A car of age 4 years is predicted to be worth £\(Int(result))")
