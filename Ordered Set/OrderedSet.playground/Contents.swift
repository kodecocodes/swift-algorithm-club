// random function returns a random number between the given range
func randomNum(min: Int, max: Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

// extension for String generates a random alphanumeric string of length 8
extension String {
    static func random(length: Int = 8) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.startIndex.advancedBy(Int(randomValue))])"
        }
        
        return randomString
    }
}

// Player data type stores a random name, and a random number of points from 0 - 5000
struct Player : Comparable {
    var name: String! = String.random()
    var points = randomNum(0, max: 5000)
    
    init(name: String, points: Int){
        self.name = name
        self.points = points
    }
    
    init(){}
}

// == operator for struct Player
// Player x is equal to Player y if and only if both players have the same name and number of points
func ==(x: Player, y: Player) -> Bool {
    return x.name == y.name && x.points == y.points
}

// < operator for struct Player
// Player x is less than Player y if and only if x has less points than y
func <(x: Player, y: Player) -> Bool {
    return x.points < y.points
}

// prints a Player formatted with their name and number of points
func print(player: Player){
    print("Player: \(player.name) | Points: \(player.points)")
}

func print(set: OrderedSet<Player>){
    for i in 0..<set.count {
        print(set[set.count - i - 1])
    }
}

import Foundation

// An Ordered Set is a collection where all items in the set follow an ordering, usually ordered from
// 'least' to 'most'. The way you value, and compare items can be user defined.
public struct OrderedSet<T: Comparable> {
    private var internalSet: [T]! = nil
    
    // returns size of Set
    public var count: Int {
        return internalSet!.count
    }
    
    public init(){
        internalSet = [T]() // create the internal array on init
    }
    
    // inserts an item
    // O(n log n)
    public mutating func insert(item: T){
        if exists(item) {
            return // don't add an item if it already exists
        }
        
        // if the set is initially empty, we need to simply append the item to internalSet
        if count == 0 {
            internalSet.append(item)
            return
        }
        
        for i in 0..<count {
            if internalSet[i] > item {
                internalSet.insert(item, atIndex: i)
                return
            }
        }
        
        // if an item is larger than any item in the current set, append it to the back.
        internalSet.append(item)
    }
    
    // removes an item if it exists
    public mutating func remove(item: T) {
        if !exists(item) {
            return
        }
        
        internalSet.removeAtIndex(findIndex(item))
    }
    
    // returns true if and only if the item exists somewhere in the set
    public func exists(item: T) -> Bool {
        let index = findIndex(item)
        return index != -1
    }
    
    // returns the index of an item if it exists, otherwise returns -1.
    public func findIndex(item: T) -> Int {
        var leftBound = 0
        var rightBound = count - 1
        
        while leftBound <= rightBound {
            let mid = leftBound + ((rightBound - leftBound) / 2)
            
            if internalSet[mid] > item {
                rightBound = mid - 1
            } else if internalSet[mid] < item {
                leftBound = mid + 1
            } else {
                // check the mid value to see if it is the item we are looking for
                if internalSet[mid] == item {
                    return mid
                }
                
                var j = mid
                
                // check right side of mid
                while j < internalSet.count - 1 && !(internalSet[j] < internalSet[j + 1]) {
                    if internalSet[j + 1] == item {
                        return j + 1
                    }
                    
                    j += 1
                }
                
                j = mid
                
                // check left side of mid
                while j > 0 && !(internalSet[j] < internalSet[j - 1]) {
                    if internalSet[j - 1] == item {
                        return j - 1
                    }
                    
                    j -= 1
                }
                return -1
            }
        }
        
        return -1
    }
    
    // returns the item at the given index. assertion fails if the index is out of the range
    // of [0, count)
    public subscript(index: Int) -> T {
        assert(index >= 0 && index < count)
        return internalSet[index]
    }
    
    // returns the 'maximum' or 'largest' value in the set
    public func max() -> T! {
        return count == 0 ? nil : internalSet[count - 1]
    }
    
    // returns the 'minimum' or 'smallest' value in the set
    public func min() -> T! {
        return count == 0 ? nil : internalSet[0]
    }
    
    // returns the k largest element in the set, if k is in the range [1, count]
    // returns nil otherwise
    public func kLargest(k: Int) -> T! {
        return k > count || k <= 0 ? nil : internalSet[count - k]
    }
    
    // returns the k smallest element in the set, if k is in the range [1, count]
    // returns nil otherwise
    public func kSmallest(k: Int) -> T! {
        return k > count || k <= 0 ? nil : internalSet[k - 1]
    }
}

// Example 1 with type Int
var mySet = OrderedSet<Int>()

// insert random ints into the set

for _ in 0..<50 {
    mySet.insert(randomNum(50, max: 500))
}

print(mySet)

print(mySet.max())
print(mySet.min())

// print the 5 largest values
for k in 1..<6 {
    print(mySet.kLargest(k))
}

// print the 5 lowest values
for k in 1..<6 {
    print(mySet.kSmallest(k))
}


// Example 2 with type Player
var playerSet = OrderedSet<Player>()

// populate with random players.
var anotherPlayer = Player()
for _ in 0..<20 {
    playerSet.insert(Player())
}

// we'll look for this player later
playerSet.insert(anotherPlayer)

// print all players in order
print(playerSet)


// highest and lowest players:
print(playerSet.max())
print(playerSet.min())

// we'll find our player now
print("'Another Player (\(anotherPlayer.name))' is ranked at level: \(playerSet.count - playerSet.findIndex(anotherPlayer)) with \(anotherPlayer.points) points")



// Example with multiple entries with the same value

var repeatedSet = OrderedSet<Player>()

repeatedSet.insert(Player(name:"Player 1", points: 100))
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

// find player 5
print(repeatedSet.findIndex(Player(name: "Player 5", points: 100)))
print(repeatedSet.findIndex(Player(name: "Random Player", points: 100)))
print(repeatedSet.findIndex(Player(name: "Player 5", points: 1000)))






