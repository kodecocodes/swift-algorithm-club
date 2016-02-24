//
//  K-NearestNeighbors.swift
//
//  Created by John Gill on 2/23/16.

import Foundation

// Need a container to easily hold 2 Dimensional Vector2Ds
struct Vector2D {
    var x:Float = 0.0 // x-Coordinate of Vector2D
    var y:Float = 0.0 // y-Coordinate of Vector2D
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
}

// Ability to use std operators on Vector2D struct
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
func euclidean(p1:Vector2D, p2:Vector2D) -> Float {
    return sqrt(pow((p1.x - p2.x), 2.0) + pow((p1.y - p2.y), 2.0))
}

// Get the INDEX of nearest Center to X
func nearestCenter(x: Vector2D, Centers: [Vector2D]) -> Int {
    var near_dist = FLT_MAX
    var min_idx:Int = 0;
    // Calculate the distance from Vector2D X to all the centers
    for (idx, c) in Centers.enumerate() {
        let dist = euclidean(x, p2: c)
        if dist < near_dist {
            min_idx = idx
            near_dist = dist
        }
    }
    return min_idx
}

func kNN(k: Int, c_dist: Float, Vector2Ds: [Vector2D]) -> [Vector2D] {
    var cent_move_dist:Float = 0.0
    var iter = 0
    
    // 1. Choose k Random Vector2Ds as the initial centers
    var kCenters:[Vector2D] = Vector2Ds.choose(k)
    
    // do following steps until convergence
    repeat {
        var cnts = [Float](count: k, repeatedValue: 0.0)
        var nCenters = [Vector2D](count:k, repeatedValue: Vector2D(x:0, y:0))
        // 2. Assign Vector2Ds to centers
        //    a. Determine which center each Vector2D is closest to
        //    b. Record how many Vector2Ds are assigned to each center
        for p in Vector2Ds {
            let c = nearestCenter(p, Centers: kCenters)
            cnts[c]++
            nCenters[c] += p
        }
        // 3. Calculate a new centers
        for idx in 0..<k {
            nCenters[idx] /= cnts[idx]
        }
        // 4. Determine how far centers moved
        cent_move_dist = 0.0
        for idx in 0..<k {
            cent_move_dist += euclidean(kCenters[idx], p2: nCenters[idx])
        }
        // 5. Update centers to the newly calculated ones
        kCenters = nCenters
        iter++
        print("Complete iteration("+String(iter)+") C-Move("+String(cent_move_dist)+") <? "+String(c_dist))
    } while(cent_move_dist > c_dist)
    return kCenters
}
var points = [Vector2D]()
let lim = 500000
for _ in 0..<lim {
    let x = Float(arc4random_uniform(UInt32(lim)))
    let y = Float(arc4random_uniform(UInt32(lim)))
    points.append(Vector2D(x: Float(x), y: y))
}
//print("Points:")
//for p in points {
//    print(p)
//}

print("\nCenters")
for c in kNN(10, c_dist: 0.1, Vector2Ds: points) {
    print(c)
}
