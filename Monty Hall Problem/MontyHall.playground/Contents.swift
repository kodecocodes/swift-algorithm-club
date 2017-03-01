//: Playground - noun: a place where people can play

import Foundation

func random(_ n: Int) -> Int {
  return Int(arc4random_uniform(UInt32(n)))
}

let numberOfDoors = 3

var rounds = 0
var winOriginalChoice = 0
var winChangedMind = 0

func playRound() {
  // The door with the prize.
  let prizeDoor = random(numberOfDoors)

  // The door the player chooses.
  let chooseDoor = random(numberOfDoors)

  // The door that Monty opens. This must be empty and not the one the player chose.
  var openDoor = -1
  repeat {
    openDoor = random(numberOfDoors)
  } while openDoor == prizeDoor || openDoor == chooseDoor

  // What happens when the player changes his mind and picks the other door.
  var changeMind = -1
  repeat {
    changeMind = random(numberOfDoors)
  } while changeMind == openDoor || changeMind == chooseDoor

  // Figure out which choice was the winner.
  if chooseDoor == prizeDoor {
    winOriginalChoice += 1
  }
  if changeMind == prizeDoor {
    winChangedMind += 1
  }

  rounds += 1
}

// Run the simulation a large number of times.
for i in 1...5000 {
  playRound()
}

let stubbornPct = Double(winOriginalChoice)/Double(rounds)
let changedMindPct = Double(winChangedMind)/Double(rounds)

print(String(format: "Played %d rounds, stubborn: %g%% vs changed mind: %g%%", rounds, stubbornPct, changedMindPct))
