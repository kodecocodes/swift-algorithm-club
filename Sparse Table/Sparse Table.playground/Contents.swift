//
//  Swift Algorithm Club - Sparse Table
//  Author: James Lawson (github.com/jameslawson)
//

import Foundation

// Last checked with Xcode Version 9.2 (9C40b)
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

public class SparseTable<T> {
  private var defaultT: T
  private var table: [[T]]
  private var function: (T, T) -> T

  public init(array: [T], function: @escaping (T, T) -> T, defaultT: T) {
    let N = array.count
    let W = Int(ceil(log2(Double(N))))
    table = [[T]](repeating: [T](repeating: defaultT, count: N), count: W)
    self.function = function
    self.defaultT = defaultT

    for w in 0..<W {
      for l in 0..<N {
        if w == 0 {
          table[w][l] = array[l]
        } else {
          let first = self.table[w - 1][l]
          let secondIndex = l + (1 << (w - 1))
          let second = ((0..<N).contains(secondIndex)) ? table[w - 1][secondIndex] : defaultT
          table[w][l] = function(first, second)
        }
      }
    }
  }

  public func query(from l: Int, until r: Int) -> T {
    let width = r - l
    let N = table[0].count
    if width <= 0 || l >= N {
      return defaultT
    }
    let r = min(N, r)
    let W = Int(floor(log2(Double(width))))
    let lo = table[W][l]
    let hi = table[W][r - (1 << W)]
    return function(lo, hi)
  }
}

print("---------------------------- EXAMPLE 1 -------------------------------------")
// Here we have an array of integers and we're repeatedly
// finding the minimum over various ranges

let intArray = [1, -11, -7, 3, 2, 4]
let minIntTable = SparseTable<Int>(array: intArray, function: min, defaultT: Int.max)
print(minIntTable.query(from: 0, until: 6)) // min(1, 3, -11, 3, 2, 4) = -11
print(minIntTable.query(from: 3, until: 5)) // min(3, 2) = 2
print(minIntTable.query(from: 2, until: 6)) // min(-7, 3, 2, 4) = -7
print(minIntTable.query(from: 0, until: 1)) // min(1) = 1
print(minIntTable.query(from: 0, until: 0)) // min(<empty range>) = Int.max
print("----------------------------------------------------------------------------\n\n")


print("---------------------------- EXAMPLE 2 -------------------------------------")
// Now we have an array of doubles and we're repeatedly
// finding the maximum over various ranges

let doubleArray = [1.5, 20.0, 3.5, 15.0, 18.0, -10.0, 5.5]
let maxDoubleTable = SparseTable<Double>(array: doubleArray, function: max, defaultT: -.infinity)
print(maxDoubleTable.query(from: 0, until: 4)) // max(1.5, 20.0, 3.5, 15.0) = 20.0
print(maxDoubleTable.query(from: 3, until: 4)) // max(3.5, 15.0) = 15.0
print(maxDoubleTable.query(from: 4, until: 6)) // max(18.0, -10.0, 5.5) = 18.0
print(maxDoubleTable.query(from: 1, until: 2)) // max(20.0) = 20.0
print(maxDoubleTable.query(from: 0, until: 0)) // max(<empty range>) = -inf
print("----------------------------------------------------------------------------\n\n")


print("---------------------------- EXAMPLE 3 -------------------------------------")
// An array of booleans and we're repeatedly
// finding the boolean AND over various ranges

let boolArray = [true, false, true, true, true, false, false]
func and(_ x: Bool, _ y: Bool) -> Bool { return x && y }

let maxBoolTable = SparseTable<Bool>(array: boolArray, function: and, defaultT: false)
print(maxBoolTable.query(from: 0, until: 4)) // and(T, F, T, T) = F
print(maxBoolTable.query(from: 2, until: 5)) // and(T, T, T) = T
print(maxBoolTable.query(from: 2, until: 6)) // and(T, T, T, F) = F
print(maxBoolTable.query(from: 0, until: 1)) // and(T) = T
print(maxBoolTable.query(from: 1, until: 2)) // and(F) = F
print(maxBoolTable.query(from: 0, until: 0)) // and(<empty range>) = F
print("----------------------------------------------------------------------------\n\n")

print("---------------------------- EXAMPLE 4 -------------------------------------")
// An array of positive integers and we're repeatedly finding
// the gcd (greatest common divisor) over various ranges. The gcd operator is
// associative and idempotent so we can use it with sparse tables

let posIntArray = [7, 2, 3, 4, 6, 5, 25, 75, 100]
func gcd(_ m: Int, _ n: Int) -> Int {
  var a = 0
  var b = max(m, n)
  var r = min(m, n)

  while r != 0 {
    a = b
    b = r
    r = a % b
  }
  return b
}

let gcdTable = SparseTable<Int>(array: posIntArray, function: gcd, defaultT: 1)
print(gcdTable.query(from: 0, until: 4)) // gcd(7, 2, 3) = 1
print(gcdTable.query(from: 3, until: 5)) // gcd(4, 6) = 2
print(gcdTable.query(from: 5, until: 7)) // gcd(5, 25, 75) = 5
print(gcdTable.query(from: 6, until: 9)) // gcd(25, 75, 100) = 25
print(gcdTable.query(from: 3, until: 4)) // gcd(4) = 4
print(gcdTable.query(from: 0, until: 0)) // gcd(<empty range>) = 1
print("------------------------------------------------------------------------\n\n")



print("---------------------------- EXAMPLE 5 -------------------------------------")
// An array of nonnegative integers where for each integer we consider its binary representation.
// We're repeatedly finding the binary OR (|) over various ranges. The binary operator is
// associative and idempotent so we can use it with sparse tables

let binArray = [0b1001, 0b1100, 0b0000, 0b0001, 0b0010, 0b0100, 0b0000, 0b1111]


let orTable = SparseTable<Int>(array: binArray, function: |, defaultT: 0b0000)
print(String(orTable.query(from: 0, until: 2), radix: 2)) // binary_or(1001, 1100) = 1101
print(String(orTable.query(from: 3, until: 5), radix: 2)) // binary_or(0001, 0010) = 0011

print(String(orTable.query(from: 3, until: 6), radix: 2)) // binary_or(0001, 0010, 0100) = 0111
print(String(orTable.query(from: 6, until: 8), radix: 2)) // binary_or(0000, 1111) = 1111
print(String(orTable.query(from: 1, until: 5), radix: 2)) // binary_or(1100, 0000, 0001, 0010) = 1111
print(String(orTable.query(from: 0, until: 1), radix: 2)) // binary_or(1001) = 1001
print(String(orTable.query(from: 0, until: 0), radix: 2)) // binary_or(<empty range>) = 0000
print("----------------------------------------------------------------------------\n\n")
