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
#elseif os(Linux)
  import Glibc
#endif

public extension Double {  
  public static func random(_ lower: Double, _ upper: Double) -> Double {
    #if os(OSX)
      return (Double(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    #elseif os(Linux)
      return (Double(random()) / 0xFFFFFFFF) * (upper - lower) + lower
    #endif
  }
}

protocol Clonable {
  init(current: Self)
}

// MARK: - create a clone from instance

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

typealias AcceptanceFunc = (Double, Double, Double) -> Double

func SimulatedAnnealing<T: SAObject>(initial: T, temperature: Double, coolingRate: Double, acceptance: AcceptanceFunc) -> T {
  // Step 1:
  //  Calculate the initial feasible solution based on a random permutation.
  //  Set best and current solutions to initial solution
  
  var temp: Double = temperature
  var currentSolution = initial.clone()
  currentSolution.shuffle()
  var bestSolution = currentSolution.clone()

  // Step 2:
  //  Repeat while the system is still hot
  //   Randomly modify the current solution by swapping its elements
  //   Randomly decide if the new solution ( neighbor ) is acceptable and set current solution accordingly
  //   Update the best solution *iff* it had improved ( lower energy = improvement )
  //   Reduce temperature
  
  while temp > 1 {    
    let newSolution: T = currentSolution.clone()
    let pos1: Int = Int(arc4random_uniform(UInt32(newSolution.count)))
    let pos2: Int = Int(arc4random_uniform(UInt32(newSolution.count)))
    newSolution.randSwap(a: pos1, b: pos2)
    let currentEnergy: Double  = currentSolution.currentEnergy()
    let newEnergy: Double = newSolution.currentEnergy()
    
    if acceptance(currentEnergy, newEnergy, temp) > Double.random(0, 1) {
      currentSolution = newSolution.clone()
    }
    if currentSolution.currentEnergy() < bestSolution.currentEnergy() {
      bestSolution = currentSolution.clone()
    }
    
    temp *= 1-coolingRate
  }
  
  return bestSolution
}
