//
//  K-Means.swift
//
//  Created by John Gill on 2/25/16.

import Foundation

// Need a container to easily hold N Dimensional Vectors
class VectorND: CustomStringConvertible {
    private var length:Int = 0
    private var data:[Float] = [Float]()
    
    init(d:[Float]) {
        self.data = d
        self.length = d.count
    }
    
    var description: String { return "VectorND (\(self.data)" }
    func getData() -> [Float] { return data }
    func getLength() -> Int { return length }
}

// Ability to use std operators on VectorND object
func +(left: VectorND, right: VectorND) -> VectorND {
    var results = [Float](count: left.getLength(), repeatedValue: 0.0)
    for idx in 0..<left.getLength() {
        results[idx] = left.getData()[idx] + right.getData()[idx]
    }
    return VectorND(d: results)
}
func +=(inout left: VectorND, right: VectorND) {
    left = left + right
}
func /(left:VectorND, right: Float) -> VectorND  {
    var results = [Float](count: left.getLength(), repeatedValue: 0.0)
    for (idx, value) in left.getData().enumerate() {
        results[idx] = value / right
    }
    return VectorND(d: results)
}
func /=(inout left: VectorND, right: Float) {
    left = left / right
}

// TODO: Explain/Replace/Cleanup
extension Array {
    var shuffle: [Element] {
        var elements = self
        for index in indices {
            let anotherIndex = Int(arc4random_uniform(UInt32(elements.count - index))) + index
            anotherIndex != index ? swap(&elements[index], &elements[anotherIndex]) : ()
        }
        return elements
    }
    func choose(n: Int) -> [Element] {
        return Array(shuffle.prefix(n))
    }
}

// Calculates the Euclidean distance between two VectorNDs
func euclidean(v1:VectorND, v2:VectorND) -> Float {
    var result:Float = 0.0
    for idx in 0..<v1.getLength() {
        result += pow(v1.getData()[idx] - v2.getData()[idx], 2.0)
    }
    return sqrt(result)
}

// Get the INDEX of nearest Center to X
func nearestCenter(x: VectorND, Centers: [VectorND]) -> Int {
    var nearestDist = FLT_MAX
    var minIndex:Int = 0;
    // Calculate the distance from VectorND X to all the centers
    for (idx, c) in Centers.enumerate() {
        let dist = euclidean(x, v2: c)
        if dist < nearestDist {
            minIndex = idx
            nearestDist = dist
        }
    }
    return minIndex
}

func kNN(numCenters: Int, convergeDist: Float, points: [VectorND]) -> [VectorND] {
    var centerMoveDist:Float = 0.0
    let zeros = [Float](count: points[0].getLength(), repeatedValue: 0.0)
    
    // 1. Choose k Random VectorNDs as the initial centers
    var kCenters:[VectorND] = points.choose(numCenters)
    
    // do following steps until convergence
    repeat {
        var cnts = [Float](count: numCenters, repeatedValue: 0.0)
        var nCenters = [VectorND](count:numCenters, repeatedValue: VectorND(d:zeros))
        // 2. Assign VectorNDs to centers
        //    a. Determine which center each VectorND is closest to
        //    b. Record how many VectorNDs are assigned to each center
        for p in points {
            let c = nearestCenter(p, Centers: kCenters)
            cnts[c]++
            nCenters[c] += p
        }
        // 3. Calculate a new centers
        for idx in 0..<numCenters {
            nCenters[idx] /= cnts[idx]
        }
        // 4. Determine how far centers moved
        centerMoveDist = 0.0
        for idx in 0..<numCenters {
            centerMoveDist += euclidean(kCenters[idx], v2: nCenters[idx])
        }
        // 5. Update centers to the newly calculated ones
        kCenters = nCenters
        print("Complete iteration coverge(\(centerMoveDist) <? \(convergeDist))")
    } while(centerMoveDist > convergeDist)
    return kCenters
}

var points = [VectorND]()
let lim = 10
for _ in 0..<lim {
    let x = Float(arc4random_uniform(UInt32(lim)))
    let y = Float(arc4random_uniform(UInt32(lim)))
    points.append(VectorND(d: [x, y]))
}

print("\nCenters")
for c in kNN(3, convergeDist: 0.1, points: points) {
    print(c)
}