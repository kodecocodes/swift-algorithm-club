//
//  Introsort.swift
//  Introsort
//
//  Created by Richard Ash on 7/18/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Foundation

func insertionSort(_ array: inout [Int], start: Int, end: Int) {
  for i in start+1...end {
    let element = array[i]
    var j = i-1
    
    while j >= start && array[j] > element {
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

func heapSort(_ array: inout [Int], start: Int, end: Int) {
  let n = end - start
  
  for i in stride(from: n/2 - 1, through: 0, by: -1) {
    makeHeap(&array, n: n, i: i)
  }
  
  for i in stride(from: n-1, through: 0, by: -1) {
    array.swapAt(0, i)
    makeHeap(&array, n: i, i: 0)
  }
}

func makeHeap(_ array: inout [Int], n: Int, i: Int) {
  var largest = i
  let l = 2*i + 1, r = 2*i + 2
  
  if l < n && array[l] > array[largest] {
    largest = l
  }
  
  if r < n && array[r] > array[largest] {
    largest = r
  }
  
  if largest != i {
    array.swapAt(i, largest)
    makeHeap(&array, n: n, i: largest)
  }
}

func introsortUtil(_ array: inout [Int], start: Int, end: Int, size: Int, depthLimit: Int) {
  let length = end - start
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
  introsortUtil(&array, start: start, end: partitionPoint-1, size: size, depthLimit: depthLimit-1)
  introsortUtil(&array, start: partitionPoint, end: end, size: size, depthLimit: depthLimit-1)
}

func introsort(array: inout [Int], size: Int = 16, depthLimit: Int? = nil) {
  guard array.count > 1 else { return }
  let start = 0, end = array.count - 1
  let depthLimit = depthLimit ?? 2 * Int(log(Double(end - start)))
  introsortUtil(&array, start: start, end: end, size: size, depthLimit: depthLimit)
}
