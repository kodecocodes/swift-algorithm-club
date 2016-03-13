//
//  Tests.swift
//  Tests
//
//  Created by John Gill on 2/29/16.
//
//

import Foundation
import XCTest

class KMeansTests: XCTestCase {
    
    func genPoints(numPoints:Int, numDimmensions:Int) -> [Vector] {
        var points = [Vector]()
        
        for _ in 0..<numPoints {
            var data = [Double]()
            for _ in 0..<numDimmensions {
                data.append(Double(arc4random_uniform(UInt32(numPoints*numDimmensions))))
            }
            points.append(Vector(d: data))
        }
        return points
    }
    
    func testSmall_2D() {
        let points = genPoints(10, numDimmensions: 2)

        print("\nCenters")
        let kmm = KMeans<Character>(labels: ["A", "B", "C"])
        kmm.trainCenters(points, convergeDist: 0.01)
        
        for (label, centroid) in zip(kmm.labels, kmm.centroids) {
            print("\(label): \(centroid)")
        }
        
        print("\nClassifications")
        for (label, point) in zip(kmm.fit(points), points) {
            print("\(label): \(point)")
        }
    }
    
    func testSmall_10D() {
        let points = genPoints(10, numDimmensions: 10)
        
        print("\nCenters")
        let kmm = KMeans<Int>(labels: [1, 2, 3])
        kmm.trainCenters(points, convergeDist: 0.01)
        for c in kmm.centroids {
            print(c)
        }
    }
    
    func testLarge_2D() {
        let points = genPoints(10000, numDimmensions: 2)
        
        print("\nCenters")
        let kmm = KMeans<Character>(labels: ["A","B","C","D","E"])
        kmm.trainCenters(points, convergeDist: 0.01)
        for c in kmm.centroids {
            print(c)
        }
    }
    
    func testLarge_10D() {
        let points = genPoints(10000, numDimmensions: 10)
        
        print("\nCenters")
        let kmm = KMeans<Int>(labels: [1,2,3,4,5])
        kmm.trainCenters(points, convergeDist: 0.01)
        for c in kmm.centroids {
            print(c)
        }
    }
}
