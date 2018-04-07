//
//  Closestpair.swift
//  
//
//  Created by Ahmed Nader on 4/4/18.
//

import Foundation

struct Point {
    var x: Double
    var y: Double
}

// Distance between two points.
func dist(a: Point, b: Point) -> Double {
    let equation = (((a.x-b.x)*(a.x-b.x))) + (((a.y-b.y)*(a.y-b.y)))
    return equation.squareRoot()
}


func ClosestPair(_ p : inout [Point],_ n : Int) -> Double {
    // Brute force if only 3 points (Base case to the recursion)
    if n <= 3 {
        var i=0, j = i+1
        var minDist = Double.infinity
        while i<n {
            j = i+1
            while j < n {
                if dist(a: p[i], b: p[j]) < minDist {
                    minDist = dist(a: p[i], b: p[j])
                }
                j+=1
            }
            i+=1
        }
        return minDist
    }
    
    
    
    let mid:Int = n/2
    let line:Double = (p[mid].x + p[mid+1].x)/2
    
    // Split the array.
    var leftSide = [Point]()
    var rightSide = [Point]()
    for s in 0..<mid {
        leftSide.append(p[s])
    }
    for s in mid..<p.count {
        rightSide.append(p[s])
    }
    
    
    // Recurse on the left and right part of the array.
    let minLeft:Double = ClosestPair(&leftSide, mid)
    let minRight:Double = ClosestPair(&rightSide, n-mid)
    
    // Starting current min must be the largest possible to not affect the real calculations.
    var min = Double.infinity
    
    // Get the minimum between the left and the right.
    if minLeft < minRight {
        min = minLeft
        
    } else {
        min = minRight
    }
    
    // Sort the array according to Y.
    p = mergeSort(p, false)
    
    
    var strip = [Point]()
    
    // If the value is less than the min distance away in X from the line then take it into consideration.
    var i=0, j = 0
    while i<n {
        if (p[i].x - line) < min {
            strip.append(p[i])
            j+=1
        }
        i+=1
    }

    
    i=0
    var x:Int
    var temp = min
    
    // Get the values between the point in the strip but only if it is less min dist in Y.
    while i<n {
        x = i+1
        while x < j && ((strip[x].y - strip[i].y) < min) {
            if dist(a: strip[i], b: strip[x]) < temp {
                temp = dist(a: strip[i], b: strip[x])
            }
            x+=1
        }
        i+=1
    }
    
    if temp < min {
        min = temp;
    }
    return min
}








