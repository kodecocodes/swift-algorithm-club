//
//  KMeans.swift
//
//  Created by John Gill on 2/25/16.

import Foundation

class KMeans {
    var numCenters:Int
    var convergeDist:Double
    
    init(numCenters:Int, convergeDist:Double) {
        self.numCenters = numCenters
        self.convergeDist = convergeDist
    }
    
    private func nearestCenter(x: Vector, Centers: [Vector]) -> Int {
        var nearestDist = DBL_MAX
        var minIndex = 0;
        
        for (idx, c) in Centers.enumerate() {
            let dist = x.distTo(c)
            if dist < nearestDist {
                minIndex = idx
                nearestDist = dist
            }
        }
        return minIndex
    }
    
    func findCenters(points: [Vector]) -> [Vector] {
        var centerMoveDist = 0.0
        let zeros = [Double](count: points[0].length, repeatedValue: 0.0)
        
        var kCenters = reservoirSample(points, k: numCenters)
        
        repeat {
            var cnts = [Double](count: numCenters, repeatedValue: 0.0)
            var newCenters = [Vector](count:numCenters, repeatedValue: Vector(d:zeros))
        
            for p in points {
                let c = nearestCenter(p, Centers: kCenters)
                cnts[c]++
                newCenters[c] += p
            }
            
            for idx in 0..<numCenters {
                newCenters[idx] /= cnts[idx]
            }
            
            centerMoveDist = 0.0
            for idx in 0..<numCenters {
                centerMoveDist += kCenters[idx].distTo(newCenters[idx])
            }
            
            kCenters = newCenters
        } while(centerMoveDist > convergeDist)
        return kCenters
    }
}

// Pick k random elements from samples
func reservoirSample<T>(samples:[T], k:Int) -> [T] {
    var result = [T]()

    // Fill the result array with first k elements
    for i in 0..<k {
        result.append(samples[i])
    }
    // randomly replace elements from remaining pool
    for i in (k+1)..<samples.count {
        let j = random()%(i+1)
        if j < k {
            result[j] = samples[i]
        }
    }
    return result
}

