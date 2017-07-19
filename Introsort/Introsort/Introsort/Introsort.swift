//
//  Introsort.swift
//  Introsort
//
//  Created by Richard Ash on 7/18/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Foundation

func introsort(_ array: inout [Int], size: Int = 16, depthLimit: Int? = nil) {
  guard array.count > 1 else { return }
  let start = 0, end = array.count - 1
  let depthLimit = depthLimit ?? 2 * Int(log(Double(end - start)))
  introsortUtil(&array, start: start, end: end, size: size, depthLimit: depthLimit)
}

func introsortUtil(_ array: inout [Int], start: Int, end: Int, size: Int, depthLimit: Int) {
  guard start <= end else { return }
  let length = end - start + 1
  guard length >= size else {
    insertionSort(&array, start: start, end: end)
    return
  }
  
  guard depthLimit > 0 else {
    heapSort(&array, start: start, end: end)
    return
  }
  
  let pivot = medianOfThree(start, start + length/2, end)
  array.swapAt(pivot, end)
  let partitionPoint = partition(array: &array, low: start, high: end)
  introsortUtil(&array, start: start, end: partitionPoint, size: size, depthLimit: depthLimit-1)
  introsortUtil(&array, start: partitionPoint+1, end: end, size: size, depthLimit: depthLimit-1)
}

func partition(array: inout [Int], low: Int, high: Int) -> Int {
  let pivot = array[high]
  var i = low - 1
  
  for j in low..<high {
    if array[j] < pivot {
      i += 1
      array.swapAt(i, j)
    }
  }
  array.swapAt(i+1, high)
  
  return i + 1
}

func medianOfThree(_ a: Int, _ b: Int, _ c: Int) -> Int {
  if a.isBetween(b, and: c) {
    return a
  } else if b.isBetween(a, and: c) {
    return b
  } else {
    return c
  }
}

extension Int {
  func isBetween(_ one: Int, and two: Int) -> Bool {
    return (self > one && self <= two) || (self > two && self <= one)
  }
}
