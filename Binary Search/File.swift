
// Binary search

import Foundation
import UIKit



var primes = [ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]


func binarySearch(inputArray:[Int], searchItem:Int) -> Int {

  var min = 0  // lowerIndex
  var max = inputArray.count - 1 // upperIndex which is 24


  while (max >= min) {
    let currentIndex = (min + max)/2 // midpoint
    if(inputArray[currentIndex] == searchItem) { // check if our target item is in the middle
      return currentIndex
    } else if (min > max) {
      return -1
    } else {
      if (inputArray[currentIndex] > searchItem) { // search the left part of the array
        max = currentIndex - 1
      } else {
        min = currentIndex + 1 // otherwise search right part of the array
      }
    }
  }
  return -1 // dindn't find it
}

// we are searching for the value 43
binarySearch(primes, searchItem: 43)  // result is 13 ( index 13 )




