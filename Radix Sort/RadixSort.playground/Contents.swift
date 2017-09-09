//: Playground - noun: a place where people can play

import Cocoa

// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

// Test Radix Sort with small array of ten values
var array: [Int] = [19, 4242, 2, 9, 912, 101, 55, 67, 89, 32]
radixSort(&array)

// Test Radix Sort with large array of 1000 random values
var bigArray = [Int](repeating: 0, count: 1000)
var i = 0
while i < 1000 {
  bigArray[i] = Int(arc4random_uniform(1000) + 1)
  i += 1
}
radixSort(&bigArray)
