//: [Previous](@previous)

//: # Example 3: multiple entries with the same value

var repeatedSet = SortedSet<Player>()

repeatedSet.insert(Player(name: "Player 1", points: 100))
repeatedSet.insert(Player(name: "Player 2", points: 100))
repeatedSet.insert(Player(name: "Player 3", points: 100))
repeatedSet.insert(Player(name: "Player 4", points: 100))
repeatedSet.insert(Player(name: "Player 5", points: 100))
repeatedSet.insert(Player(name: "Player 6", points: 50))
repeatedSet.insert(Player(name: "Player 7", points: 200))
repeatedSet.insert(Player(name: "Player 8", points: 250))
repeatedSet.insert(Player(name: "Player 9", points: 25))

print(repeatedSet)
//debugPrint(repeatedSet)

print(repeatedSet.index(of: Player(name: "Player 5", points: 100)))
print(repeatedSet.index(of: Player(name: "Random Player", points: 100)))
print(repeatedSet.index(of: Player(name: "Player 5", points: 1000)))
