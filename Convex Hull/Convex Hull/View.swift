//
//  View.swift
//  Convex Hull
//
//  Created by Jaap Wijnen on 19/02/2017.
//  Copyright © 2017 Workmoose. All rights reserved.
//

import UIKit

class View: UIView {

  let MAX_POINTS = 100
  var points = [CGPoint]()
  var convexHull = [CGPoint]()

  override init(frame: CGRect) {
    super.init(frame: frame)
    generateRandomPoints()
    quickHull(points: points)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func generateRandomPoints() {
    for _ in 0..<MAX_POINTS {
      let offset: CGFloat = 50
      let xrand = CGFloat(arc4random()) / CGFloat(UInt32.max) * (self.frame.width - offset) + 0.5 * offset
      let yrand = CGFloat(arc4random()) / CGFloat(UInt32.max) * (self.frame.height - offset) + 0.5 * offset
      let point = CGPoint(x: xrand, y: yrand)
      points.append(point)
    }

    points.sort { (a: CGPoint, b: CGPoint) -> Bool in
      return a.x < b.x
    }
  }

  func quickHull(points: [CGPoint]) {
    var pts = points

    // Assume points has at least 2 points
    // Assume list is ordered on x

    // left most point
    let p1 = pts.removeFirst()
    // right most point
    let p2 = pts.removeLast()

    // p1 and p2 are outer most points and thus are part of the hull
    convexHull.append(p1)
    convexHull.append(p2)

    // points to the right of oriented line from p1 to p2
    var s1 = [CGPoint]()

    // points to the right of oriented line from p2 to p1
    var s2 = [CGPoint]()

    // p1 to p2 line
    let lineVec1 = CGPoint(x: p2.x - p1.x, y: p2.y - p1.y)

    for p in pts { // per point check if point is to right or left of p1 to p2 line
      let pVec1 = CGPoint(x: p.x - p1.x, y: p.y - p1.y)
      let sign1 = lineVec1.x * pVec1.y - pVec1.x * lineVec1.y // cross product to check on which side of the line point p is.

      if sign1 > 0 { // right of p1 p2 line (in a normal xy coordinate system this would be < 0 but due to the weird iPhone screen coordinates this is > 0
        s1.append(p)
      } else { // right of p2 p1 line
        s2.append(p)
      }
    }

    // find new hull points
    findHull(s1, p1, p2)
    findHull(s2, p2, p1)
  }

  func findHull(_ points: [CGPoint], _ p1: CGPoint, _ p2: CGPoint) {
    // if set of points is empty there are no points to the right of this line so this line is part of the hull.
    if points.isEmpty {
      return
    }

    var pts = points
    var maxDist: CGFloat = -1
    var maxPoint: CGPoint = pts.first!

    for p in pts { // for every point check the distance from our line
      let dist = distance(from: p, to: (p1, p2))
      if dist > maxDist { // if distance is larger than current maxDist remember new point p
        maxDist = dist
        maxPoint = p
      }
    }

    convexHull.insert(maxPoint, at: convexHull.index(of: p1)! + 1) // insert point with max distance from line in the convexHull after p1

    pts.remove(at: pts.index(of: maxPoint)!) // remove maxPoint from points array as we are going to split this array in points left and right of the line

    // points to the right of oriented line from p1 to maxPoint
    var s1 = [CGPoint]()

    // points to the right of oriented line from maxPoint to p2
    var s2 = [CGPoint]()

    // p1 to maxPoint line
    let lineVec1 = CGPoint(x: maxPoint.x - p1.x, y: maxPoint.y - p1.y)
    // maxPoint to p2 line
    let lineVec2 = CGPoint(x: p2.x - maxPoint.x, y: p2.y - maxPoint.y)

    for p in pts {
      let pVec1 = CGPoint(x: p.x - p1.x, y: p.y - p1.y) // vector from p1 to p
      let sign1 = lineVec1.x * pVec1.y - pVec1.x * lineVec1.y // sign to check is p is to the right or left of lineVec1

      let pVec2 = CGPoint(x: p.x - maxPoint.x, y: p.y - maxPoint.y) // vector from p2 to p
      let sign2 = lineVec2.x * pVec2.y - pVec2.x * lineVec2.y // sign to check is p is to the right or left of lineVec2

      if sign1 > 0 { // right of p1 maxPoint line
        s1.append(p)
      } else if sign2 > 0 { // right of maxPoint p2 line
        s2.append(p)
      }
    }

    // find new hull points
    findHull(s1, p1, maxPoint)
    findHull(s2, maxPoint, p2)
  }

  func distance(from p: CGPoint, to line: (CGPoint, CGPoint)) -> CGFloat {
    // If line.0 and line.1 are the same point, they don't define a line (and, besides,
    // would cause division by zero in the distance formula). Return the distance between
    // line.0 and point p instead.
    if line.0 == line.1 {
      return sqrt(pow(p.x - line.0.x, 2) + pow(p.y - line.0.y, 2))
    }

    // from Deza, Michel Marie; Deza, Elena (2013), Encyclopedia of Distances (2nd ed.), Springer, p. 86, ISBN 9783642309588
    return abs((line.1.y - line.0.y) * p.x
      - (line.1.x - line.0.x) * p.y
      + line.1.x * line.0.y
      - line.1.y * line.0.x)
      / sqrt(pow(line.1.y - line.0.y, 2) + pow(line.1.x - line.0.x, 2))
  }

  override func draw(_ rect: CGRect) {

    let context = UIGraphicsGetCurrentContext()

    // Draw hull
    let lineWidth: CGFloat = 2.0

    context!.setFillColor(UIColor.black.cgColor)
    context!.setLineWidth(lineWidth)
    context!.setStrokeColor(UIColor.red.cgColor)
    context!.setFillColor(UIColor.black.cgColor)

    let firstPoint = convexHull.first!
    context!.move(to: firstPoint)

    for p in convexHull.dropFirst() {
      context!.addLine(to: p)
    }
    context!.addLine(to: firstPoint)

    context!.strokePath()

    // Draw points
    for p in points {
      let radius: CGFloat = 5
      let circleRect = CGRect(x: p.x - radius, y: p.y - radius, width: 2 * radius, height: 2 * radius)
      context!.fillEllipse(in: circleRect)
    }
  }
}
