// Comb Sort Function
// Created by Stephen Rutstein
// 7-16-2016

import Cocoa
// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

// Test Comb Sort with small array of ten values
let array = [2, 32, 9, -1, 89, 101, 55, -10, -12, 67]
combSort(array)

// Test Comb Sort with large array of 1000 random values
var bigArray = [Int](repeating: 0, count: 1000)
var i = 0
while i < 1000 {
  bigArray[i] = Int(arc4random_uniform(1000) + 1)
  i += 1
}
combSort(bigArray)
