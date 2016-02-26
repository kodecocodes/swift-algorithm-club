//
//  K-Means.swift
//
//  Created by John Gill on 2/25/16.

import Foundation

// Need a container to easily hold N Dimensional Vectors
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
}

// MARK: VectorND Operators
func +(left: VectorND, right: VectorND) -> VectorND {
    var results = [Double](count: left.getLength(), repeatedValue: 0.0)
    for idx in 0..<left.getLength() {
        results[idx] = left.getData()[idx] + right.getData()[idx]
    }
    return VectorND(d: results)
}
func +=(inout left: VectorND, right: VectorND) {
    left = left + right
}
func /(left:VectorND, right: Double) -> VectorND  {
    var results = [Double](count: left.getLength(), repeatedValue: 0.0)
    for (idx, value) in left.getData().enumerate() {
        results[idx] = value / right
    }
    return VectorND(d: results)
}
func /=(inout left: VectorND, right: Double) {
    left = left / right
}

// MARK: Assist Functions
// Pick a k random elements from samples
func reservoirSample(samples:[VectorND], k:Int) -> [VectorND] {
    var result = [VectorND]()
    
    // Fill the result array with first k elements
    for i in 0..<k {
        result.append(samples[i])
    }
    // randomly replace elements from remaining ones 
    for i in (k+1)..<samples.count {
        let j = Int(arc4random_uniform(UInt32(i+1)))
        if j < k {
            result[j] = samples[i]
        }
    }
    return result
}

// Calculates the Euclidean distance between two VectorNDs
func euclidean(v1:VectorND, v2:VectorND) -> Double {
    var result = 0.0
    for idx in 0..<v1.getLength() {
        result += pow(v1.getData()[idx] - v2.getData()[idx], 2.0)
    }
    return sqrt(result)
}

// Get the INDEX of nearest Center to X
func nearestCenter(x: VectorND, Centers: [VectorND]) -> Int {
    var nearestDist = DBL_MAX
    var minIndex = 0;
    
    for (idx, c) in Centers.enumerate() {
        let dist = euclidean(x, v2: c)
        if dist < nearestDist {
            minIndex = idx
            nearestDist = dist
        }
    }
    return minIndex
}

// MARK: Main Function
func kMeans(numCenters: Int, convergeDist: Double, points: [VectorND]) -> [VectorND] {
    var centerMoveDist = 0.0
    let zeros = [Double](count: points[0].getLength(), repeatedValue: 0.0)
    
    // 1. Choose k Random VectorNDs as the initial centers
    var kCenters = reservoirSample(points, k: numCenters)
    
    // do following steps until convergence
    repeat {
        var cnts = [Double](count: numCenters, repeatedValue: 0.0)
        var newCenters = [VectorND](count:numCenters, repeatedValue: VectorND(d:zeros))
        // 2. Assign VectorNDs to centers
        //    a. Determine which center each VectorND is closest to
        //    b. Record how many VectorNDs are assigned to each center
        for p in points {
            let c = nearestCenter(p, Centers: kCenters)
            cnts[c]++
            newCenters[c] += p
        }
        // 3. Calculate a new centers
        for idx in 0..<numCenters {
            newCenters[idx] /= cnts[idx]
        }
        // 4. Determine how far centers moved
        centerMoveDist = 0.0
        for idx in 0..<numCenters {
            centerMoveDist += euclidean(kCenters[idx], v2: newCenters[idx])
        }
        // 5. Update centers to the newly calculated ones
        kCenters = newCenters
        print("Complete iteration coverge(\(centerMoveDist) <? \(convergeDist))")
    } while(centerMoveDist > convergeDist)
    return kCenters
}

// MARK: Sample Data
var points = [VectorND]()
let numPoints = 10
let numDimmensions = 5
for _ in 0..<numPoints {
    var data = [Double]()
    for x in 0..<numDimmensions {
        data.append(Double(arc4random_uniform(UInt32(numPoints*numDimmensions))))
    }
    points.append(VectorND(d: data))
}

print("\nCenters")
for c in kMeans(3, convergeDist: 0.01, points: points) {
    print(c)
}

