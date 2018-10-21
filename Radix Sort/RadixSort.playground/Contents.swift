//: Playground - noun: a place where people can play

// Test Radix Sort with small array of ten values
var array: [Int] = [19, 4242, 2, 9, 912, 101, 55, 67, 89, 32]
radixSort(&array)

// Test Radix Sort with large array of 1000 random values
var bigArray = (0..<1000).map { _ in Int.random(in: 1...1000) }
bigArray
radixSort(&bigArray)
