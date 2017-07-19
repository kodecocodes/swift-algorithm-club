//
//  HeapSort.swift
//  Introsort
//
//  Created by Richard Ash on 7/18/17.
//  Copyright © 2017 Richard. All rights reserved.
//

import Foundation

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
