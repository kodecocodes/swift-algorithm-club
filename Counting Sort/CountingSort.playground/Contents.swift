//: Playground - noun: a place where people can play

enum CountingSortError: Error {
  case arrayEmpty
}

func countingSort(array: [Int]) throws -> [Int] {
  guard array.count > 0 else {
    throw CountingSortError.arrayEmpty
  }

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
  var sortedArray = [Int](repeating: 0, count: array.count)
  for element in array {
    countArray[element] -= 1
    sortedArray[countArray[element]] = element
  }
  return sortedArray
}

try countingSort(array: [10, 9, 8, 7, 1, 2, 7, 3])
