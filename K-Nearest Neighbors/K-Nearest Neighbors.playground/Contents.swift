//
//  K-NearestNeighbors.swift
//
//  Created by John Gill on 2/23/16.
import Foundation

// Container to easily hold N Dimensional Vectors
class VectorND: CustomStringConvertible {
    private var length = 0
    private var data = [Double]()
    
    init(d:[Double]) {
        data = d
        length = d.count
    }
    
    var description: String { return "VectorND (\(data)" }
    func getData() -> [Double] { return data }
    func getLength() -> Int { return length }
    
    // Calculates the Euclidean distance from 
    // this point to another VectorND
    func getDist(v:VectorND) -> Double {
        var result = 0.0
        for idx in 0..<length {
            result += pow(data[idx] - v.getData()[idx], 2.0)
        }
        return sqrt(result)
    }
}

class kNearestNeighbrs {
    var k:Int // Number of Neighbors
    
    init(k:Int) {
        self.k = k
    }
    
    func train (data:[VectorND], labels:[Int]) {
        
    }
    
    func predict (data: [VectorND]) -> [Int] {
        
        return []
    }
}