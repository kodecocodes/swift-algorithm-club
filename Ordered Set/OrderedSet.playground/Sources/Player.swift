// The Player data type stores a random name, and a random number of
// points from 0 - 5000.
public struct Player: Comparable {
  public var name: String
  public var points: Int

  public init() {
    self.name = String.random()
    self.points = random(min: 0, max: 5000)
  }

  public init(name: String, points: Int) {
    self.name = name
    self.points = points
  }
}

// Player x is equal to Player y if and only if both players have the
// same name and number of points.
public func == (x: Player, y: Player) -> Bool {
  return x.name == y.name && x.points == y.points
}

// Player x is less than Player y if x has less points than y.
public func < (x: Player, y: Player) -> Bool {
  return x.points < y.points
}

// Prints a Player formatted with their name and number of points.
public func print(player: Player) {
  print("Player: \(player.name) | Points: \(player.points)")
}

public func print(set: OrderedSet<Player>) {
  for i in 0..<set.count {
    print(set[set.count - i - 1])
  }
}
