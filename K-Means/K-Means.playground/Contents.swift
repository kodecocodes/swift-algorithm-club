//
//  K-Means.swift
//
//  Created by John Gill on 2/25/16.

import Foundation

// Need a container to easily hold 2 Dimensional Vector2Ds
class Vector2D: CustomStringConvertible {
    var x:Float = 0.0 // x-Coordinate of Vector2D
    var y:Float = 0.0 // y-Coordinate of Vector2D
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    var description: String {
        return "Vector2D (\(self.x), \(self.y))"
    }
}

// Ability to use std operators on Vector2D object
func +(left: Vector2D, right: Vector2D) -> Vector2D {
    return Vector2D(x: left.x + right.x, y: left.y + right.y)
}
func +=(inout left: Vector2D, right: Vector2D) {
    left = left + right
}
func /(left:Vector2D, right: Float) -> Vector2D {
    return Vector2D(x: left.x / right, y: left.y / right)
}
func /=(inout left: Vector2D, right: Float) {
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

// Calculates the Euclidean distance between two Vector2Ds
func euclidean(v1:Vector2D, v2:Vector2D) -> Float {
    return sqrt(pow((v1.x - v2.x), 2.0) + pow((v1.y - v2.y), 2.0))
}

// Get the INDEX of nearest Center to X
func nearestCenter(x: Vector2D, Centers: [Vector2D]) -> Int {
    var nearestDist = FLT_MAX
    var minIndex:Int = 0;
    // Calculate the distance from Vector2D X to all the centers
    for (idx, c) in Centers.enumerate() {
        let dist = euclidean(x, v2: c)
        if dist < nearestDist {
            minIndex = idx
            nearestDist = dist
        }
    }
    return minIndex
}

func kNN(numCenters: Int, convergeDist: Float, points: [Vector2D]) -> [Vector2D] {
    var centerMoveDist:Float = 0.0
    
    // 1. Choose k Random Vector2Ds as the initial centers
    var kCenters:[Vector2D] = points.choose(numCenters)
    
    // do following steps until convergence
    repeat {
        var cnts = [Float](count: numCenters, repeatedValue: 0.0)
        var nCenters = [Vector2D](count:numCenters, repeatedValue: Vector2D(x:0, y:0))
        // 2. Assign Vector2Ds to centers
        //    a. Determine which center each Vector2D is closest to
        //    b. Record how many Vector2Ds are assigned to each center
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
var points = [Vector2D]()
let lim = 50
for _ in 0..<lim {
    let x = Float(arc4random_uniform(UInt32(lim)))
    let y = Float(arc4random_uniform(UInt32(lim)))
    points.append(Vector2D(x: Float(x), y: y))
}

print("\nCenters")
for c in kNN(10, convergeDist: 0.1, points: points) {
    print(c)
}
