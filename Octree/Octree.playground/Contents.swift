//: Playground - noun: a place where people can play

import UIKit
import simd

let boxMin = vector_double3(0, 2, 6)
let boxMax = vector_double3(5, 10, 9)
let box = Box(boxMin: boxMin, boxMax: boxMax)
var octree = Octree<Int>(boundingBox: box, minimumCellSize: 5.0)
var five = octree.add(5, at: vector_double3(3,4,8))
octree.add(8, at: vector_double3(3,4,8.2))
octree.add(10, at: vector_double3(3,4,8.2))
octree.add(7, at: vector_double3(2,5,8))
octree.add(2, at: vector_double3(1,6,7))

var cont = octree.elements(at: vector_double3(3,4,8.2))
octree.remove(8)
octree.elements(at: vector_double3(3,4,8))

let boxMin2 = vector_double3(1,3,7)
let boxMax2 = vector_double3(4,9,8)
let box2 = Box(boxMin: boxMin2, boxMax: boxMax2)
box.isContained(in: box2)
box.intersects(box2)

let boxMin3 = vector_double3(3,8,8)
let boxMax3 = vector_double3(10,12,20)
let box3 = Box(boxMin: boxMin3, boxMax: boxMax3)
box3.intersects(box3)

octree.elements(in: box)
octree.elements(in: box2)
print(octree)
