//
//  Sort.swift
//  test
//
//  Created by Kauserali on 11/04/16.
//  Copyright © 2016 Ali Hafizji. All rights reserved.
//

func countingSort(_ array: [Int])-> [Int] {
  guard array.count > 0 else {return []}

  // Step 1
  // Create an array to store the count of each element
  let maxElement = array.max() ?? 0

  var countArray = [Int](repeating: 0, count: Int(maxElement + 1))
  for element in array {
    countArray[element] += 1
  }

  // Step 2
  // Set each value to be the sum of the previous two values
  for index in 1 ..< countArray.count {
    let sum = countArray[index] + countArray[index - 1]
    countArray[index] = sum
  }

  print(countArray)

  // Step 3
  // Place the element in the final array as per the number of elements before it
  // Loop through the array in reverse to keep the stability of the new sorted array
  // (For Example: 7 is at index 3 and 6, thus in sortedArray the position of 7 at index 3 should be before 7 at index 6
  var sortedArray = [Int](repeating: 0, count: array.count)
  for index in stride(from: array.count - 1, through: 0, by: -1) {
    let element = array[index]
    countArray[element] -= 1
    sortedArray[countArray[element]] = element
  }
  return sortedArray
}
