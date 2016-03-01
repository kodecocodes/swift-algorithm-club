//
//  Vector.swift
//  Tests
//
//  Created by John Gill on 2/29/16.
//
//

import Foundation

// Container to easily hold N Dimensional Vectors
class Vector: CustomStringConvertible, Equatable {
    private(set) var length = 0
    private(set) var data = [Double]()
    
    init(d:[Double]) {
        data = d
        length = d.count
    }
    
    var description: String { return "Vector (\(data)" }
    
    func distTo(v2:Vector) -> Double {
        var result = 0.0
        for idx in 0..<self.length {
            result += pow(self.data[idx] - v2.data[idx], 2.0)
        }
        return sqrt(result)
    }
}

// MARK: Vector Operators
func ==(left: Vector, right: Vector) -> Bool {
    for idx in 0..<left.length {
        if left.data[idx] != right.data[idx] {
            return false
        }
    }
    return true
}

func +(left: Vector, right: Vector) -> Vector {
    var results = [Double]()
    for idx in 0..<left.length {
        results.append(left.data[idx] + right.data[idx])
    }
    return Vector(d: results)
}

func +=(inout left: Vector, right: Vector) {
    left = left + right
}

func -(left: Vector, right: Vector) -> Vector {
    var results = [Double]()
    for idx in 0..<left.length {
        results.append(left.data[idx] - right.data[idx])
    }
    return Vector(d: results)
}

func -=(inout left: Vector, right: Vector) {
    left = left - right
}

func /(left:Vector, right: Double) -> Vector  {
    var results = [Double](count: left.length, repeatedValue: 0.0)
    for (idx, value) in left.data.enumerate() {
        results[idx] = value / right
    }
    return Vector(d: results)
}

func /=(inout left: Vector, right: Double) {
    left = left / right
}