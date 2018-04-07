//
//  Closestpair.swift
//
//
//  Created by Ahmed Nader on 4/4/18.
//

import Foundation

// sortAccodrding : true -> x, false -> y.
func mergeSort(_ array: [Point],_ sortAccording : Bool) -> [Point] {
    guard array.count > 1 else { return array }
    let middleIndex = array.count / 2
    let leftArray = mergeSort(Array(array[0..<middleIndex]), sortAccording)
    let rightArray = mergeSort(Array(array[middleIndex..<array.count]), sortAccording)
    return merge(leftArray, rightArray, sortAccording)
}


func merge(_ leftPile: [Point],_ rightPile: [Point],_ sortAccording: Bool) -> [Point] {
    
    var compare : (Point, Point) -> Bool
    
    // Choose which one to compare with X or Y.
    if sortAccording {
        compare = { p1,p2 in
            return p1.x < p2.x
        }
    } else {
        compare = { p1, p2 in
            return p1.y < p2.y
        }
    }
    
    var leftIndex = 0
    var rightIndex = 0
    var orderedPile = [Point]()
    if orderedPile.capacity < leftPile.count + rightPile.count {
        orderedPile.reserveCapacity(leftPile.count + rightPile.count)
    }
    
    while true {
        guard leftIndex < leftPile.endIndex else {
            orderedPile.append(contentsOf: rightPile[rightIndex..<rightPile.endIndex])
            break
        }
        guard rightIndex < rightPile.endIndex else {
            orderedPile.append(contentsOf: leftPile[leftIndex..<leftPile.endIndex])
            break
        }
        
        if compare(leftPile[leftIndex], rightPile[rightIndex]) {
            orderedPile.append(leftPile[leftIndex])
            leftIndex += 1
        } else {
            orderedPile.append(rightPile[rightIndex])
            rightIndex += 1
        }
    }
    return orderedPile
}
