// Comb Sort Function
// Created by Stephen Rutstein
// 7-16-2016

import Cocoa

func combSort (input: [Int]) -> [Int] {
  var copy = input
  var gap = copy.count
  let shrink = 1.3

  while gap > 1 {
    gap = Int(Double(gap) / shrink)
    if gap < 1 {
      gap = 1
    }

    var index = 0
    while index + gap < copy.count {
      if copy[index] > copy[index + gap] {
        swap(&copy[index], &copy[index + gap])
      }
      index += 1
    }
  }
  return copy
}

// Test Comb Sort with small array of ten values
let array = [2, 32, 9, -1, 89, 101, 55, -10, -12, 67]
combSort(array)

// Test Comb Sort with large array of 1000 random values
var bigArray = [Int](count: 1000, repeatedValue: 0)
var i = 0
while i < 1000 {
  bigArray[i] = Int(arc4random_uniform(1000) + 1)
  i += 1
}
combSort(bigArray)


