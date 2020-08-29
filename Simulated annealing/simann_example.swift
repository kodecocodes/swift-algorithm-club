// The MIT License (MIT)
// Copyright (c) 2017 Mike Taghavi (mitghi[at]me.com)
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if os(OSX)
  import Foundation
  import Cocoa
#elseif os(Linux)
  import Glibc
#endif

protocol Clonable {
  init(current: Self)
}

extension Clonable {
  func clone() -> Self {
    return Self.init(current: self)
  }
}

protocol SAObject: Clonable {
  var count: Int { get }
  func randSwap(a: Int, b: Int)
  func currentEnergy() -> Double
  func shuffle()
}

// MARK: - create a new copy of elements

extension Array where Element: Clonable {
  func clone() -> Array {
    var newArray = Array<Element>()
    for elem in self {
      newArray.append(elem.clone())
    }
    
    return newArray
  }
}

typealias Points = [Point]
typealias AcceptanceFunc = (Double, Double, Double) -> Double

class Point: Clonable {
  var x: Int
  var y: Int
  
  init(x: Int, y: Int) {
    self.x = x
    self.y = y
  }
  
  required init(current: Point){
    self.x = current.x
    self.y = current.y
  }
}

// MARK: - string representation

extension Point: CustomStringConvertible {
  public var description: String {
    return "Point(\(x), \(y))"
  }
}

// MARK: - return distance between two points using operator '<->'

infix operator <->: AdditionPrecedence
extension Point {
  static func <-> (left: Point, right: Point) -> Double {
    let xDistance = (left.x - right.x)
    let yDistance = (left.y - right.y)

    return Double((xDistance * xDistance) + (yDistance * yDistance)).squareRoot()
  }
}


class Tour: SAObject {
  var tour: Points
  var energy: Double = 0.0
  var count: Int {
    get {
      return self.tour.count
    }
  }
  
  init(points: Points){
    self.tour = points.clone()
  }
  
  required init(current: Tour) {
    self.tour = current.tour.clone()
  }
}

// MARK: - calculate current tour distance ( energy ).

extension Tour {
  func randSwap(a: Int, b: Int) -> Void {
    let (cpos1, cpos2) = (self[a], self[b])
    self[a] = cpos2
    self[b] = cpos1
  }

  func currentEnergy() -> Double {
    if self.energy == 0 {
      var tourEnergy: Double = 0.0
      for i in 0..<self.count {
        let fromCity = self[i]
        var destCity = self[0]
        if i+1 < self.count {
          destCity = self[i+1]
        }
        let e = fromCity<->destCity
        tourEnergy = tourEnergy + e
        
      }
      self.energy = tourEnergy
    }
    return self.energy
  }

  func shuffle() {
    self.tour.shuffle()
  }
}

// MARK: - subscript to manipulate elements of Tour.

extension Tour {
  subscript(index: Int) -> Point {
    get {
      return self.tour[index]
    }
    set(newValue) {
      self.tour[index] = newValue
    }
  }
}

func SimulatedAnnealing<T: SAObject>(initial: T, temperature: Double, coolingRate: Double, acceptance: AcceptanceFunc) -> T {
  var temp: Double = temperature
  var currentSolution = initial.clone()
  currentSolution.shuffle()
  var bestSolution = currentSolution.clone()
  print("Initial solution: ", bestSolution.currentEnergy())
  
  while temp > 1 {
    let newSolution: T = currentSolution.clone()
    let pos1: Int = Int.random(in: 0 ..< newSolution.count)
    let pos2: Int = Int.random(in: 0 ..< newSolution.count)
    newSolution.randSwap(a: pos1, b: pos2)
    let currentEnergy: Double  = currentSolution.currentEnergy()
    let newEnergy: Double = newSolution.currentEnergy()
    
    if acceptance(currentEnergy, newEnergy, temp) > Double.random(in: 0 ..< 1) {
      currentSolution = newSolution.clone()
    }
    if currentSolution.currentEnergy() < bestSolution.currentEnergy() {
      bestSolution = currentSolution.clone()
    }
    
    temp *= 1-coolingRate
  }
  
  print("Best solution: ", bestSolution.currentEnergy())
  return bestSolution
}

let points: [Point] = [
  (60 , 200), (180, 200), (80 , 180), (140, 180),
  (20 , 160), (100, 160), (200, 160), (140, 140),
  (40 , 120), (100, 120), (180, 100), (60 , 80) ,
  (120, 80) , (180, 60) , (20 , 40) , (100, 40) ,
  (200, 40) , (20 , 20) , (60 , 20) , (160, 20) ,
  ].map{ Point(x: $0.0, y: $0.1) }

let acceptance : AcceptanceFunc = {
  (e: Double, ne: Double, te: Double) -> Double in
  if ne < e {
    return 1.0
  }
  return exp((e - ne) / te)
}

let result: Tour = SimulatedAnnealing(initial     : Tour(points: points),
                                      temperature : 100000.0,
                                      coolingRate : 0.003,
                                      acceptance  : acceptance)
