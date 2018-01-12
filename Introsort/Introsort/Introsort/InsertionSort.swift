//
//  InsertionSort.swift
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
