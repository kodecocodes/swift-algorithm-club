//: [Previous](@previous)

//: # Example 2 with Player objects

var limitedArray = ArrayLimitedQueue<Player>()

limitedArray.maxStoredItems = 0
limitedArray.positiveValues = false
limitedArray.deleteExisting = false

let player1 = Player()
let player2 = Player()
let player3 = Player()
let player4 = Player()
let player5 = Player()

limitedArray.add(item: player1)
limitedArray.add(item: player2)
limitedArray.add(item: player3)
limitedArray.add(item: player4)
limitedArray.add(item: player5)
limitedArray.add(item: player2)
limitedArray.add(item: player3)

print(limitedArray.array)
limitedArray.maxStoredItems = 6
limitedArray.zeroValue = Player(name: "Any", points: 0)
limitedArray.positiveValues = true
limitedArray.deleteExisting = true
print(limitedArray.array)
