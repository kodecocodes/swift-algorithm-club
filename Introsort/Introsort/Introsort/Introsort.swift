//
//  Introsort.swift
//  Introsort
//
//  Created by Richard Ash on 7/18/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Foundation

func insertionSort(_ array: inout [Int], left: Int, right: Int) {
  for i in left+1...right {
    let element = array[i]
    var j = i-1
    
    while j >= left && array[j] > element {
      array[j+1] = array[j]
      j -= 1
    }
    array[j+1] = element
  }
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
  if a > b && a <= c {
    return a
  } else if a > c && a <= b {
    return a
  } else if b > a && b <= c {
    return b
  } else if b > c && b <= a {
    return b
  } else if c > a && c <= b {
    return c
  } else {
    return c
  }
}

func introsortUtil(_ array: inout [Int], begin: Int, end: Int, depthLimit: Int) {
  let size = end - begin
  
  guard size >= 16 else {
    insertionSort(&array, left: begin, right: end)
    return
  }
  
  guard depthLimit > 0 else {
    // TODO: Implement Heap Sort
    return
  }
  
  let pivot = medianOfThree(begin, begin + size/2, end)
  array.swapAt(pivot, end)
  let partitionPoint = partition(array: &array, low: begin, high: end)
  introsortUtil(&array, begin: begin, end: partitionPoint-1, depthLimit: depthLimit-1)
  introsortUtil(&array, begin: partitionPoint, end: end, depthLimit: depthLimit-1)
}

func introsort(array: inout [Int]) {
  let begin = 0, end = array.count - 1
  let depthLimit = 2 * Int(log(Double(end - begin)))
  introsortUtil(&array, begin: begin, end: end, depthLimit: depthLimit)
}
