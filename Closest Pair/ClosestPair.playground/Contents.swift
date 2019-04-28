//Created by Ahmed Nader (github: AhmedNader42) on 4/4/18.

func closestPairOf(points: [Point]) -> (minimum:Double, firstPoint:Point, secondPoint:Point) {
  var innerPoints = mergeSort(points, sortAccording : true)
  let result = closestPair(&innerPoints, innerPoints.count)
  return (result.minValue, result.firstPoint, result.secondPoint)
}

func closestPair(_ p : inout [Point],_ n : Int) -> (minValue: Double,firstPoint: Point,secondPoint: Point) {
  // Brute force if only 3 points (To end recursion)
  if n <= 3 {
    var i = 0, j = i + 1
    var minDist = Double.infinity
    var newFirst: Point? = nil
    var newSecond: Point? = nil
    while i < n {
      j = i + 1
      while j < n {
        if dist(p[i], p[j]) <= minDist {
          minDist = dist(p[i], p[j])
          newFirst = p[i]
          newSecond = p[j]
        }
        j += 1
      }
      i += 1
    }
    return (minDist, newFirst ?? Point(0, 0), newSecond ?? Point(0, 0))
  }
  
  
  
  let mid = n / 2
  let line = (p[mid].x + p[mid+1].x) / 2
  
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
  let valueFromLeft = closestPair(&leftSide, mid)
  let minLeft = valueFromLeft.minValue
  let valueFromRight = closestPair(&rightSide, n-mid)
  let minRight = valueFromRight.minValue
  
  // Starting current min must be the largest possible to not affect the real calculations.
  var min = Double.infinity
  
  var first: Point
  var second: Point
  
  // Get the minimum between the left and the right.
  if minLeft < minRight {
    min = minLeft
    first = valueFromLeft.firstPoint
    second = valueFromLeft.secondPoint
  } else {
    min = minRight
    first = valueFromRight.firstPoint
    second = valueFromRight.secondPoint
  }
  
  // Sort the array according to Y.
  p = mergeSort(p, sortAccording: false)
  
  
  var strip = [Point]()
  
  // If the value is less than the min distance away in X from the line then take it into consideration.
  var i = 0, j = 0
  while i < n {
    if abs(p[i].x - line) < min {
      strip.append(p[i])
      j += 1
    }
    i += 1
  }
  
  
  i = 0
  var x = i + 1
  var temp = min
  var tempFirst = Point(0,0)
  var tempSecond = Point(0,0)
  // Get the values between the points in the strip but only if it is less min dist in Y.
  while i < j {
    x = i + 1
    while x < j {
      if (abs(strip[x].y - strip[i].y)) > min { break }
      if dist(strip[i], strip[x]) < temp {
        temp = dist(strip[i], strip[x])
        tempFirst = strip[i]
        tempSecond = strip[x]
      }
      x += 1
    }
    i += 1
  }
  
  if temp < min {
    min = temp;
    first = tempFirst
    second = tempSecond
  }
  return (min, first, second)
}

// Get the distance between two points a, b.
func dist(_ a: Point,_ b: Point) -> Double {
  let equation: Double = (((a.x-b.x)*(a.x-b.x))) + (((a.y-b.y)*(a.y-b.y)))
  return equation.squareRoot()
}


var a = Point(0,2)
var b = Point(6,67)
var c = Point(43,71)
var d = Point(1000,1000)
var e = Point(39,107)
var f = Point(2000,2000)
var g = Point(3000,3000)
var h = Point(4000,4000)


var points = [a,b,c,d,e,f,g,h]
let endResult = closestPairOf(points: points)
print("Minimum Distance : \(endResult.minimum), The two points : (\(endResult.firstPoint.x ),\(endResult.firstPoint.y)), (\(endResult.secondPoint.x),\(endResult.secondPoint.y))")
