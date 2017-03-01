//: [Previous](@previous)

//: # Example 2 with Player objects

var playerSet = OrderedSet<Player>()

// Populate the set with random players.
for _ in 0..<20 {
  playerSet.insert(Player())
}

// We'll look for this player later.
var anotherPlayer = Player()
playerSet.insert(anotherPlayer)

// Print all players in order from highest points to lowest points.
// (Note: this is the reverse order of how they are stored in the set!)
print(playerSet)
//debugPrint(playerSet)

// Highest and lowest players:
print(playerSet.max())
print(playerSet.min())

// We'll find our player now:
let level = playerSet.count - playerSet.index(of: anotherPlayer)!
print("\(anotherPlayer.name) is ranked at level \(level) with \(anotherPlayer.points) points")

//: [Next](@next)
