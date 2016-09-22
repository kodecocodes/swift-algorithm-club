//: # Example 1 with type Int

var mySet = OrderedSet<Int>()

// Insert random numbers into the set
for _ in 0..<50 {
  mySet.insert(random(min: 50, max: 500))
}

print(mySet)

print("\nMaximum:")
print(mySet.max())

print("\nMinimum:")
print(mySet.min())

// Print the 5 largest values
print("\n5 Largest:")
for k in 1...5 {
  print(mySet.kLargest(k))
}

// Print the 5 lowest values
print("\n5 Smallest:")
for k in 1...5 {
  print(mySet.kSmallest(k))
}

//: [Next](@next)
