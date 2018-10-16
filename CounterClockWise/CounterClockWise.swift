/*
 CounterClockWise(CCW) Algorithm
 The user cross-multiplies corresponding coordinates to find the area encompassing the polygon,
 and subtracts it from the surrounding polygon to find the area of the polygon within.
 This code is based on the "Shoelace formula" by Carl Friedrich Gauss
 https://en.wikipedia.org/wiki/Shoelace_formula
 */


import Foundation

// MARK : Point struct for defining 2-D coordinate(x,y)
public struct Point{
  // Coordinate(x,y)
  var x: Int
  var y: Int
  
  public init(x: Int ,y: Int){
    self.x = x
    self.y = y
  }
}

// MARK : Function that determine the area of a simple polygon whose vertices are described
//        by their Cartesian coordinates in the plane.
func ccw(points: [Point]) -> Int{
  let polygon = points.count
  var orientation = 0
  
  // Take the first x-coordinate and multiply it by the second y-value,
  // then take the second x-coordinate and multiply it by the third y-value,
  // and repeat as many times until it is done for all wanted points.
  for i in 0..<polygon{
    orientation += (points[i%polygon].x*points[(i+1)%polygon].y
      - points[(i+1)%polygon].x*points[i%polygon].y)
  }
  
  // If the points are labeled sequentially in the counterclockwise direction,
  // then the sum of the above determinants is positive and the absolute value signs can be omitted
  // if they are labeled in the clockwise direction, the sum of the determinants will be negative.
  // This is because the formula can be viewed as a special case of Green's Theorem.
  switch orientation {
  case Int.min..<0:
    return -1 // if operation < 0 : ClockWise
  case 0:
    return 0 // if operation == 0 : Parallel
  default:
    return 1 // if operation > 0 : CounterClockWise
  }
}
