//
//  NaiveBayes.swift
//  NaiveBayes
//
//  Created by Philipp Gabriel on 14.04.17.
//  Copyright © 2017 ph1ps. All rights reserved.
//

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
    
    func uniques() -> Set<Element> {
        return Set(self)
    }
    
}

class NaiveBayes {
    
    private var data: [[Double]]
    private var classes: [Int]
    private var variables: [Int: [(feature: Int, mean: Double, stDev: Double)]]
    
    init(data: [[Double]], classes: [Int]) {
        self.data = data
        self.classes = classes
        self.variables = [Int: [(feature: Int, mean: Double, stDev: Double)]]()
    }
    
    convenience init(dataAndClasses: [[Double]], rowOfClass: Int) {
        let classes = dataAndClasses.map { Int($0[rowOfClass]) }
        let data = dataAndClasses.map { row in
            return row.enumerated().filter { $0.offset != rowOfClass }.map { $0.element }
        }
        
        self.init(data: data, classes: classes)
    }
    
    func train() {
        
        for `class` in classes.uniques() {
            
            variables[`class`] = [(feature: Int, mean: Double, stDev: Double)]()
            
            for feature in 0..<data[0].count {
                
                let values = data.map { $0[feature] }.enumerated().filter { (offset, _) in
                    return classes[offset] == `class`
                    }.map { $0.element }
                
                variables[`class`]?.append((feature, values.mean(), values.standardDeviation()))
            }
        }
        
        //This is just for the sake of clearing RAM
        data.removeAll(keepingCapacity: false)
    }
    
    func classify(with input: [Double]) -> Int {
        let likelihoods = calcLikelihoods(with: input).max { (first, second) -> Bool in
            return first.1 < second.1
        }
        
        guard let `class` = likelihoods?.0 else {
            return -1
        }
        
        return `class`
    }
    
    func calcLikelihoods(with input: [Double]) -> [(Int, Double)] {
        
        var probaClass = [Int: Double]()
        let amount = classes.count
        
        classes.forEach { `class` in
            let individual = classes.filter { $0 == `class` }.count
            probaClass[`class`] = Double(individual) / Double(amount)
        }
        
        let classesAndFeatures = variables.map { (key, value) -> (Int, [Double]) in
            let distributions = value.map { (feature, mean, stDev) -> Double in
                let featureValue = input[feature]
                let eulerPart = pow(M_E, -1 * pow(featureValue - mean, 2) / (2 * pow(stDev, 2)))
                let distribution = eulerPart / sqrt(2 * .pi) / stDev
                return distribution
            }
            return (key, distributions)
        }
        
        let likelihoods = classesAndFeatures.map { (key, probaFeature) in
            return (key, probaFeature.reduce(1, *) * (probaClass[key] ?? 1.0))
        }
        
        let sum = likelihoods.map { $0.1 }.reduce(0, +)
        let normalized = likelihoods.map { (`class`, likelihood) in
            return (`class`, likelihood / sum)
        }
        
        return normalized
    }
}

let data: [[Double]] = [
    [6, 180, 12],
    [5.92, 190, 11],
    [5.58, 170, 12],
    [5.92, 165, 10],
    [5, 100, 6],
    [5.5, 150, 8],
    [5.42, 130, 7],
    [5.75, 150, 9]
]

let classes = [0, 0, 0, 0, 1, 1, 1, 1]

let naive = NaiveBayes(data: data, classes: classes)
naive.train()
print(naive.classify(with: [6, 130, 8]))

let otherData: [[Double]] = [
    [6, 180, 12, 0],
    [5.92, 190, 11, 0],
    [5.58, 170, 12, 0],
    [5.92, 165, 10, 0],
    [5, 100, 6, 1],
    [5.5, 150, 8, 1],
    [5.42, 130, 7, 1],
    [5.75, 150, 9, 1]
]

let otherNaive = NaiveBayes(dataAndClasses: otherData, rowOfClass: 3)
otherNaive.train()
print(otherNaive.calcLikelihoods(with: [6, 130, 8]))

guard let csv = try? String(contentsOfFile: "/Users/ph1ps/Desktop/wine.csv") else {
    print("file not found")
    exit(0)
}

let rows = csv.characters.split(separator: "\r\n").map { String($0) }
let wineData = rows.map { row -> [Double] in
    let split = row.characters.split(separator: ";")
    return split.map { Double(String($0))! }
}

let wineNaive = NaiveBayes(dataAndClasses: wineData, rowOfClass: 0)
wineNaive.train()
print(wineNaive.calcLikelihoods(with: [12.85, 1.6, 2.52, 17.8, 95, 2.48, 2.37, 0.26, 1.46, 3.93, 1.09, 3.63, 1015]))
