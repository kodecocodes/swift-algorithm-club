//
//  main.swift
//  NaiveBayes
//
//  Created by Philipp Gabriel on 14.04.17.
//  Copyright © 2017 ph1ps. All rights reserved.
//

//TODO naming
import Foundation

extension Array where Element == Double {

    func mean() -> Double {
        return self.reduce(0, +) / Double(count)
    }
    
    func standardDeviation() -> Double {
        let calculatedMean = mean()
        
        let sum = self.reduce(0.0) { (previous, next) in
            return previous + pow(next - calculatedMean, 2)
        }
        
        return sqrt(sum / Double(count - 1))
    }
}

extension Array where Element == Int {
    
    //Is this the best way?!
    func uniques() -> [Int] {
        return Array(Set(self))
    }
    
}

class NaiveBayes {

    var data: [[Double]]
    var classes: [Int]
    var variables: [Int: [(feature: Int, mean: Double, stDev: Double)]]
    
    init(data: [[Double]], classes: [Int]) {
        self.data = data
        self.classes = classes
        self.variables = [Int: [(feature: Int, mean: Double, stDev: Double)]]()
    }
    
    //TODO
    //init(dataAndClasses: [[Double]], index ofClassRow: Int) {}

    //TODO: Does it really need to be n^2 runtime?
    func train() {

        for `class` in 0..<classes.uniques().count {
            variables[`class`] = [(feature: Int, mean: Double, stDev: Double)]()
            
            for feature in 0..<data[0].count {
                
                let values = data.map{ $0[feature] }.enumerated().filter { (offset, _) in
                    return classes[offset] == `class`
                }.map { $0.element }

                variables[`class`]?.append((feature, values.mean(), values.standardDeviation()))
            }
        }

        data.removeAll(keepingCapacity: false)
    }
    
    func predictClass(input: [Double]) -> Int {
        let likelihoods = predictLikelihood(input: input).max { (first, second) -> Bool in
            return first.1 < second.1
        }
        
        guard let `class` = likelihoods?.0 else {
            return -1
        }
        
        return `class`
    }
    
    func predictLikelihood(input: [Double]) -> [(Int, Double)] {
    
        var probabilityOfClasses = [Int: Double]()
        let amount = classes.uniques().count
        
        classes.forEach { `class` in
            let individual = classes.filter { $0 == `class` }.count
            probabilityOfClasses[`class`] = Double(amount) / Double(individual)
        }
        
        let probaClass = variables.map { (key, value) -> (Int, [Double]) in
            let probaFeature = value.map { (feature, mean, stDev) -> Double in
                let featureValue = input[feature]
                let eulerPart = pow(M_E, -1 * pow(featureValue - mean, 2) / (2 * pow(stDev, 2)))
                let distribution = eulerPart / sqrt(2 * .pi) / stDev
                return distribution
            }
            return (key, probaFeature)
        }
        
        let likelihoods = probaClass.map { (key, probaFeature) in
            return (key, probaFeature.reduce(1, *) * (probabilityOfClasses[key] ?? 1.0))
        }

        let sum = likelihoods.map { $0.1 }.reduce(0, +)
        let normalized = likelihoods.map { (`class`, likelihood) in
            return (`class`, likelihood / sum)
        }
        
        return normalized
    }
}

let data: [[Double]] = [
    [6,180,12],
    [5.92,190,11],
    [5.58,170,12],
    [5.92,165,10],
    [5,100,6],
    [5.5,150,8],
    [5.42,130,7],
    [5.75,150,9]
]

let classes = [0,0,0,0,1,1,1,1]

let naive = NaiveBayes(data: data, classes: classes)
naive.train()
let result = naive.predictLikelihood(input: [6,130,8])
print(result)








