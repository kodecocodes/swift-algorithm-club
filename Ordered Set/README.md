# Ordered Set
An Ordered Set is a collection of unique items in sorted order. Items are usually sorted from least to greatest. The Ordered Set data type is a hybrid of a [Set](https://en.wikipedia.org/wiki/Set_(mathematics)), and a [Sequence](https://en.wikipedia.org/wiki/Sequence). It's important to keep in mind that two items can have the same *value* but still may not be equal. 
For example, we could define "a" and "z" to have the same value (their lengths), but clearly "a" != "z".

## Why use an Ordered Set?
Ordered Sets should be considered for use when you require keeping your collection sorted at all times, and do lookups on the collection much more freuqently than inserting or deleting items. A good example would be keeping track of the rankings of players in a scoreboard (see example 2 below). Many of the lookup operations for an Ordered Set are **O(1)**. 

### These are Ordered Sets
```
[1, 2, 3, 6, 8, 10, 1000]
Where each item (Integers) has it's normal definition of value and equality
```
```
["a", "is", "set", "this"]
Where each item (String) has it's value equal to it's length
```

### These are not Ordered Sets
```
[1, 1, 2, 3, 5, 8]
This Set violates the property of uniqueness
```
```
[1, 11, 2, 3]
This Set violates the sorted property
```

## The Code
We'll start by creating our internal representation for the Ordered Set. Since the idea of a set is similar to that of an array, we will use an array to represent our set. Furthermore, since we'll need to keep our set sorted, we need to compare the individual elements. Thus, any type must conform to the [Comparable Protocol](https://developer.apple.com/library/watchos/documentation/Swift/Reference/Swift_Comparable_Protocol/index.html).

``` swift
public struct OrderedSet<T: Comparable> {
    private var internalSet: [T]! = nil
    
    // returns size of Set
    public var count: Int {
        return internalSet!.count
    }
    
    public init(){
        internalSet = [T]() // create the internal array on init
    }
    ...
```

Lets take a look at the insert function first. The insert function first checks if the item already exists, and if so returns and does not insert the item. Otherwise, it will insert the item through straight forward iteration. It starts from the first item, and checks to see if this item is larger than the item we want to insert. Once we find such an item, we insert the given item into it's place, and shift the array over to the right by 1.

``` swift
  // inserts an item
  public mutating func insert(item: T){
      if exists(item) {
          return // don't add an item if it already exists
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
```
The first part of the function checks if the item is already in the set. As we'll see later on, this has an efficiency of **O(log(n) + k)** where k is the number of items with the same value as the item we are inserting. The second part iterates through the interal array so that it can find a spot for our given item. This is at worse **O(n)**. The insert function for arrays has an efficiency of **O(nlog(n))**, thus making the insert function for our Ordered Set **O(nlog(n))**.


Next we have the `remove` function. First check if the item exists. If not, then return and no nothing. If it does exist, remove it.

``` swift
    // removes an item if it exists
    public mutating func remove(item: T) {
        if !exists(item) {
            return
        }
        
        internalSet.removeAtIndex(findIndex(item))
    }
```
Again, because of the `removeAtIndex` function, the efficiency for remove is **O(nlog(n))**

The next function is the `findIndex` function which takes in an item of type `T` and returns the index of the item if it is in the set, otherwise returns -1. 

``` swift
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
```
Since our set is sorted, we can use a binary search to quickly search for the item. If you are not familiar with the concept of binary search, we have an article all about it [here](../Binary\ Search). 

Since a set can contain multiple items with the same *value*, it is important to check to see if we have the correct item.

For example, consider this Ordered  Set
```
["a", "b", "c", "longer string", "even longer string"]
Where the value of each String is equal to it's length.
```
The call `findIndex("a")` with the traditional implementation of Binary Search would give us the value of 2, however we know that "a" is located at index 0. Thus, we need to check the items with the same *value* to the right and left of the mid value.

The code to check the left and right side are similar so we will only look at the code that checks the left side.
``` swift
    j = mid

    // check left side of mid
    while j > 0 && !(internalSet[j] < internalSet[j - 1]) {
        if internalSet[j - 1] == item {
            return j - 1
        }
                    
        j -= 1
    }
    return -1
```
First, `j` starts at the mid value. Above, we've already checked to see that the item at index `j` is not equal to the item we are looking for. Then, we keep looping until we either reach the end of the array, or hit an element which has a lower value than the current item at index `j`. If the item at value `j - 1` is equal to the one we are looking for, we return that index, otherwise we keep decreasing `j`. Once the loop terminates, we were unable to find the item and so we return -1. 

The combined runtime for this function is **O(log(n) + k)** where `n` is the length of the set, and `k` is the number of 
items with the same *value* as the one that is being searched for. 

Since the set is sorted, the following operations are all **O(1)**:

```swift
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
```

## Examples
Below are a few examples that can be found in the playground file.

### Example 1
Here we create a set with random Integers. Printing the largest/smallest 5 numbers in the set is fairly easy.
``` swift
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
```

### Exmaple 2
In this example we take a look at something a bit more interesting. We define a `Player` struct as follows:
``` swift
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
```
The set we create will hold players. One thing to note is that two `Player`s can each have the same value, but are not guaranteed to be equal. 

Inserting 20 random players and one player we will track of.
``` swift
// Example 2 with type Player
var playerSet = OrderedSet<Player>()

// populate with random players.
var anotherPlayer = Player()
for _ in 0..<20 {
    playerSet.insert(Player())
}

// we'll look for this player later
playerSet.insert(anotherPlayer)
```

Next, we can find the players with the most and least amount of points very quickly.
``` swift
// highest and lowest players:
print(playerSet.max())
print(playerSet.min())
```

Next we use the findIndex function to find out what rank `anotherPlayer` is.
``` swift
// we'll find our player now
print("'Another Player (\(anotherPlayer.name))' is ranked at level: \(playerSet.count - playerSet.findIndex(anotherPlayer)) with \(anotherPlayer.points) points")
```

### Example 3
The final example demonstrates the need to look for the right item even after the Binary Search has completed. 9 Players are inserted into the set.
``` swift

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
```

The set looks something like this:
```
[Player 9, Player 6, Player 1, Player 2, Player 3, Player 4, Player 5, Player 7, Player 8]
```

The next line looks for `Player 2`:
``` swift
print(repeatedSet.findIndex(Player(name: "Player 2", points: 100)))
```

After the Binary Search finishes, the value of `mid` is at index 5
```
[Player 9, Player 6, Player 1, Player 2, Player 3, Player 4, Player 5, Player 7, Player 8]
                                                      mid
```
However, we know this may not be where `Player 2` is, so we check both sides of `mid`. The shown Players below are the ones with the same value as `Player 4`, and are the ones we check after the Binary Search.

```
[X, X, Player 1, Player 2, Player 3, Player 4, Player 5, X, X]
                                       mid 
```

The code then checks the right of `mid` (Every `Player` with an * below it)
```
[X, X, Player 1, Player 2, Player 3, Player 4, Player 5, X, X]
                                       mid        *
```

The right side did not contain the item, so we look at the left side.
```
[X, X, Player 1, Player 2, Player 3, Player 4, Player 5, X, X]
                              *        mid        
```
```
[X, X, Player 1, Player 2, Player 3, Player 4, Player 5, X, X]
                    *                  mid        
```
We've found `Player 2`! Index 3 is then returned. 

*Written By Zain Humayun*
