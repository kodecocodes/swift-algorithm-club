//: Playground - noun: a place where people can play

// An unsorted array of numbers
let numbers = [11, 59, 3, 2, 53, 17, 31, 7, 19, 67, 47, 13, 37, 61, 29, 43, 5, 41, 23]

// Binary search requires that the array is sorted from low to high
let sorted = numbers.sorted()

// Using recursive solution
sorted.binarySearchRecursive(key: 2) // gives 0
sorted.binarySearchRecursive(key: 67) // gives 18
sorted.binarySearchRecursive(key: 43) // gives 13
sorted.binarySearchRecursive(key: 42) // gives nil

// Using iterative solution
sorted.binarySearchIterative(key: 2) // gives 0
sorted.binarySearchIterative(key: 67) // gives 18
sorted.binarySearchIterative(key: 43) // gives 13
sorted.binarySearchIterative(key: 42) // gives nil
