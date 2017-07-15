//: # Example 1 with type Int

var intArray = ArrayLimitedQueue<Int>()

intArray.maxStoredItems = 0
intArray.zeroValue = 0
intArray.positiveValues = false
intArray.deleteExisting = false

intArray.add(item: 2)
intArray.add(item: 5)
intArray.add(item: 3)
intArray.add(item: -5)
intArray.add(item: 1)
intArray.add(item: 3)
intArray.add(item: -5)
intArray.add(item: 8)

print("IntArray: \(intArray)")
print("Removable: \(intArray.removableItems(forMaxSize: 5))")

intArray.maxStoredItems = 6
intArray.positiveValues = true
intArray.deleteExisting = true
print("IntArray: \(intArray)")
