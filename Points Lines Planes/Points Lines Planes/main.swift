//
//  main.swift
//  Points Lines Planes
//
//  Created by Jaap Wijnen on 23-10-17.
//

let p0 = Point2D(x: 0, y: 2)
let p1 = Point2D(x: 1, y: 1)
let p2 = Point2D(x: 1, y: 3)
let p3 = Point2D(x: 3, y: 1)
let p4 = Point2D(x: 3, y: 3)

let horLine = Line2D(from: p1, to: p3)
let verLine = Line2D(from: p1, to: p2)
let line45 = Line2D(from: p1, to: p4)

print(horLine.intersect(with: verLine))
print(p0.isRight(of: line45))
print(p0.isRight(of: horLine))
print(p0.isRight(of: verLine))
let lineperp = horLine.perpendicularLineAt(x: 2)
print(lineperp)

