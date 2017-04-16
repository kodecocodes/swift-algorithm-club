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

enum NBType {
    
    case gaussian(data: [[Double]], classes: [Int])
    case multinomial(data: [[Int]], classes: [Int])
    //case bernoulli(data: [[Bool]], classes: [Int]) --> TODO
    
    var classes: [Int] {
        if case .gaussian(_, let classes) = self {
            return classes
        } else if case .multinomial(_, let classes) = self {
            return classes
        }
        
        return []
    }
    
    var data: [[Any]] {
        if case .gaussian(let data, _) = self {
            return data
        } else if case .multinomial(let data, _) = self {
            return data
        }
        
        return []
    }
    
    func calcLikelihood(variables: [Any], input: Any) -> Double? {
        
        if case .gaussian = self {
            
            guard let input = input as? Double else {
                return nil
            }
            
            guard let mean = variables[0] as? Double else {
                return nil
            }
            
            guard let stDev = variables[1] as? Double else {
                return nil
            }
            
            let eulerPart = pow(M_E, -1 * pow(input - mean, 2) / (2 * pow(stDev, 2)))
            let distribution = eulerPart / sqrt(2 * .pi) / stDev
            
            return distribution
            
        } else if case .multinomial = self {
            
            guard let variables = variables as? [(category: Int, probability: Double)] else {
                return nil
            }
            
            guard let input = input as? Double else {
                return nil
            }
            
            return variables.first { variable in
                return variable.category == Int(input)
                }?.probability
            
        }
        
        return nil
    }
    
    func train(values: [Any]) -> [Any]? {
        
        if case .gaussian = self {
            
            guard let values = values as? [Double] else {
                return nil
            }
            
            return [values.mean(), values.standardDeviation()]
            
        } else if case .multinomial = self {
            
            guard let values = values as? [Int] else {
                return nil
            }
            
            let count = values.count
            let categoryProba = values.uniques().map { value -> (Int, Double) in
                return (value, Double(values.filter { $0 == value }.count) / Double(count))
            }
            return categoryProba
        }
        
        return nil
    }
}

class NaiveBayes {
    
    private var variables: [Int: [(feature: Int, variables: [Any])]]
    private var type: NBType
    
    init(type: NBType) {
        self.type = type
        self.variables = [Int: [(Int, [Any])]]()
    }
    
    static func convert<T: Any>(dataAndClasses: [[T]], rowOfClasses: Int) -> (data: [[T]], classes: [Int]) {
        let classes = dataAndClasses.map { Int($0[rowOfClasses] as! Double) } //TODO
        
        let data = dataAndClasses.map { row in
            return row.enumerated().filter { $0.offset != rowOfClasses }.map { $0.element }
        }
        
        return (data, classes)
    }
    
    //TODO remake pliss, i dont like this at all
    func train() {
        
        var classes = type.classes
        
        for `class` in classes.uniques() {
            
            variables[`class`] = [(Int, [Any])]()
            
            for feature in 0..<type.data[0].count {
                
                let values = type.data.map { $0[feature] }.enumerated().filter { (offset, _) in
                    return classes[offset] == `class`
                    }.map { $0.element }
                
                let trained = type.train(values: values) ?? [Any]()
                
                variables[`class`]?.append((feature, trained))
            }
        }
    }
    
    func classify(with input: [Double]) -> Int {
        let likelihoods = classifyProba(with: input).max { (first, second) -> Bool in
            return first.1 < second.1
        }
        
        guard let `class` = likelihoods?.0 else {
            return -1
        }
        
        return `class`
    }
    
    //TODO fix this doesnt have to be a double
    func classifyProba(with input: [Double]) -> [(Int, Double)] {
        
        let classes = type.classes
        var probaClass = [Int: Double]()
        let amount = classes.count
        
        classes.forEach { `class` in
            let individual = classes.filter { $0 == `class` }.count
            probaClass[`class`] = Double(individual) / Double(amount)
        }
        
        let classesAndFeatures = variables.map { (`class`, value) -> (Int, [Double]) in
            let distribution = value.map { (feature, variables) -> Double in
                return type.calcLikelihood(variables: variables, input: input[feature]) ?? 0.0
            }
            return (`class`, distribution)
        }
        
        let likelihoods = classesAndFeatures.map { (`class`, distribution) in
            return (`class`, distribution.reduce(1, *) * (probaClass[`class`] ?? 1.0))
        }
        
        let sum = likelihoods.map { $0.1 }.reduce(0, +)
        let normalized = likelihoods.map { (`class`, likelihood) in
            return (`class`, likelihood / sum)
        }
        
        return normalized
    }
}

guard let csv = try? String(contentsOfFile: "/Users/ph1ps/Desktop/wine.csv") else {
    print("file not found")
    exit(0)
}

let rows = csv.characters.split(separator: "\r\n").map { String($0) }
let wineData = rows.map { row -> [Double] in
    let split = row.characters.split(separator: ";")
    return split.map { Double(String($0))! }
}

let convertedWine = NaiveBayes.convert(dataAndClasses: wineData, rowOfClasses: 0)
let wineNaive = NaiveBayes(type: .gaussian(data: convertedWine.data, classes: convertedWine.classes))
wineNaive.train()
print(wineNaive.classifyProba(with: [12.85, 1.6, 2.52, 17.8, 95, 2.48, 2.37, 0.26, 1.46, 3.93, 1.09, 3.63, 1015]))

let golfData = [
    [0, 0, 0, 0],
    [0, 0, 0, 1],
    [1, 0, 0, 0],
    [2, 1, 0, 0],
    [2, 2, 1, 0],
    [2, 2, 1, 1],
    [1, 2, 1, 1],
    [0, 1, 0, 0],
    [0, 2, 1, 0],
    [2, 1, 1, 0],
    [0, 1, 1, 1],
    [1, 1, 0, 1],
    [1, 0, 1, 0],
    [2, 1, 0, 1]
]
let golfClasses =  [0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 0]
let golfNaive = NaiveBayes(type: .multinomial(data: golfData, classes: golfClasses))
golfNaive.train()
print(golfNaive.classifyProba(with: [0, 2, 0, 1]))
