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
    var points = [Vector]()
    
    func genPoints(numPoints:Int, numDimmensions:Int) {
        for _ in 0..<numPoints {
            var data = [Double]()
            for _ in 0..<numDimmensions {
                data.append(Double(arc4random_uniform(UInt32(numPoints*numDimmensions))))
            }
            points.append(Vector(d: data))
        }

    }
    
    func testSmall_2D() {
        genPoints(10, numDimmensions: 2)
        
        print("\nCenters")
        let kmm = KMeans(numCenters: 3, convergeDist: 0.01)
        for c in kmm.findCenters(points) {
            print(c)
        }
    }
    
    func testSmall_10D() {
        genPoints(10, numDimmensions: 10)
        
        print("\nCenters")
        let kmm = KMeans(numCenters: 3, convergeDist: 0.01)
        for c in kmm.findCenters(points) {
            print(c)
        }
    }
    
    func testLarge_2D() {
        genPoints(10000, numDimmensions: 2)
        
        print("\nCenters")
        let kmm = KMeans(numCenters: 5, convergeDist: 0.01)
        for c in kmm.findCenters(points) {
            print(c)
        }
    }
    
    func testLarge_10D() {
        genPoints(10000, numDimmensions: 10)
        
        print("\nCenters")
        let kmm = KMeans(numCenters: 5, convergeDist: 0.01)
        for c in kmm.findCenters(points) {
            print(c)
        }
    }
}
