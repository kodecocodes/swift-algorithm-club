//: Playground - noun: a place where people can play

// An unsorted array of numbers
let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]

// Binary search requires that the array is sorted from low to high
let sorted = numbers.sorted()

// Using recursive solution
binarySearch(sorted, key: 2, range: 0 ..< sorted.count)   // gives 0
binarySearch(sorted, key: 67, range: 0 ..< sorted.count)  // gives 18
binarySearch(sorted, key: 43, range: 0 ..< sorted.count)  // gives 13
binarySearch(sorted, key: 42, range: 0 ..< sorted.count)  // nil

// Using iterative solution
binarySearch(sorted, key: 2)   // gives 0
binarySearch(sorted, key: 67)  // gives 18
binarySearch(sorted, key: 43)  // gives 13
binarySearch(sorted, key: 42)  // nil
