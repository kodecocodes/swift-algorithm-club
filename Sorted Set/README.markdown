# Sorted Set

## Sorted Array Version

An Sorted Set is a collection of unique items in sorted order. Items are usually sorted from least to greatest.

The Sorted Set data type is a hybrid of:

- a [Set](https://en.wikipedia.org/wiki/Set_%28mathematics%29), a collection of unique items where the order does not matter, and
- a [Sequence](https://en.wikipedia.org/wiki/Sequence), an sorted list of items where each item may appear more than once.

It's important to keep in mind that two items can have the same *value* but still may not be equal. For example, we could define "a" and "z" to have the same value (their lengths), but clearly "a" != "z".

## Why use an sorted set?

Sorted Sets should be considered when you need to keep your collection sorted at all times, and you do lookups on the collection much more frequently than inserting or deleting items. Many of the lookup operations for an Sorted Set are **O(1)**.

A good example would be keeping track of the rankings of players in a scoreboard (see example 2 below).

#### These are sorted sets

A set of integers:

	[1, 2, 3, 6, 8, 10, 1000]

A set of strings:

	["a", "is", "set", "this"]

The "value" of these strings could be their text content, but also for example their length.

#### These are not sorted sets

This set violates the property of uniqueness:

	[1, 1, 2, 3, 5, 8]

This set violates the sorted property:

	[1, 11, 2, 3]

## The code

We'll start by creating our internal representation for the Sorted Set. Since the idea of a set is similar to that of an array, we will use an array to represent our set. Furthermore, since we'll need to keep the set sorted, we need to be able to compare the individual elements. Thus, any type must conform to the [Comparable Protocol](https://developer.apple.com/library/watchos/documentation/Swift/Reference/Swift_Comparable_Protocol/index.html).

```swift
public struct SortedSet<T: Comparable> {
  private var internalSet = [T]()

  // Returns the number of elements in the SortedSet.
  public var count: Int {
    return internalSet.count
  }
  ...
```

Lets take a look at the `insert()` function first. This first checks if the item already exists in the collection. If so, it returns and does not insert the item.  Otherwise, it will insert the item through straightforward iteration.

```swift
  public mutating func insert(_ item: T){
    if exists(item) {
      return  // don't add an item if it already exists
    }

    // Insert new the item just before the one that is larger.
    for i in 0..<count {
      if internalSet[i] > item {
        internalSet.insert(item, at: i)
        return
      }
    }

    // Append to the back if the new item is greater than any other in the set.
    internalSet.append(item)
  }
```

As we'll see later on, checking if the item is already in the set has an efficiency of **O(log(n) + k)** where **k** is the number of items with the same value as the item we are inserting.

To insert the new item, the `for` loop starts from the beginning of the array, and checks to see if each item is larger than the item we want to insert. Once we find such an item, we insert the new one into its place. This shifts the rest of the array over to the right by 1 position. This loop is at worst **O(n)**.

The total performance of the `insert()` function is therefore **O(n)**.

Next up is the `remove()` function:

```swift
  public mutating func remove(_ item: T) {
    if let index = index(of: item) {
      internalSet.remove(at: index)
    }
  }
```

First this checks if the item exists and then removes it from the array. Because of the `removeAtIndex()` function, the efficiency for remove is **O(n)**.

The next function is `indexOf()`, which takes in an object of type `T` and returns the index of the corresponding item if it is in the set, or `nil` if it is not. Since our set is sorted, we can use a binary search to quickly search for the item.

```swift
  public func index(of item: T) -> Int? {
    var leftBound = 0
    var rightBound = count - 1

    while leftBound <= rightBound {
      let mid = leftBound + ((rightBound - leftBound) / 2)

      if internalSet[mid] > item {
        rightBound = mid - 1
      } else if internalSet[mid] < item {
        leftBound = mid + 1
      } else if internalSet[mid] == item {
        return mid
      } else {
      	// see below
      }
    }
    return nil
  }
```

> **Note:** If you are not familiar with the concept of binary search, we have an [article that explains all about it](../Binary%20Search).

However, there is an important issue to deal with here. Recall that two objects can be unequal yet still have the same "value" for the purposes of comparing them. Since a set can contain multiple items with the same value, it is important to check that the binary search has landed on the correct item.

For example, consider this sorted set of `Player` objects. Each `Player` has a name and a number of points:

	[ ("Bill", 50), ("Ada", 50), ("Jony", 50), ("Steve", 200), ("Jean-Louis", 500), ("Woz", 1000) ]

We want the set to be sorted by points, from low to high. Multiple players can have the same number of points. The name of the player is not important for this ordering. However, the name *is* important for retrieving the correct item.

Let's say we do `indexOf(bill)` where `bill` is player object `("Bill", 50)`. If we did a traditional binary search we'd land on index 2, which is the object `("Jony", 50)`. The value 50 matches, but it's not the object we're looking for!

Therefore, we also need to check the items with the same value to the right and left of the midpoint. The code to check the left and right side looks like this:

```swift
        // Check to the right.
        for j in mid.stride(to: count - 1, by: 1) {
          if internalSet[j + 1] == item {
            return j + 1
          } else if internalSet[j] < internalSet[j + 1] {
            break
          }
        }

        // Check to the left.
        for j in mid.stride(to: 0, by: -1) {
          if internalSet[j - 1] == item {
            return j - 1
          } else if internalSet[j] > internalSet[j - 1] {
            break
          }
        }

        return nil
```

These loops start at the current `mid` value and then look at the neighboring values until we've found the correct object.

The combined runtime for `indexOf()` is **O(log(n) + k)** where **n** is the length of the set, and **k** is the number of items with the same *value* as the one that is being searched for.

Since the set is sorted, the following operations are all **O(1)**:

```swift
  // Returns the 'maximum' or 'largest' value in the set.
  public func max() -> T? {
    return count == 0 ? nil : internalSet[count - 1]
  }

  // Returns the 'minimum' or 'smallest' value in the set.
  public func min() -> T? {
    return count == 0 ? nil : internalSet[0]
  }

  // Returns the k-th largest element in the set, if k is in the range
  // [1, count]. Returns nil otherwise.
  public func kLargest(_ k: Int) -> T? {
    return k > count || k <= 0 ? nil : internalSet[count - k]
  }

  // Returns the k-th smallest element in the set, if k is in the range
  // [1, count]. Returns nil otherwise.
  public func kSmallest(_ k: Int) -> T? {
    return k > count || k <= 0 ? nil : internalSet[k - 1]
  }
```

## Examples

Below are a few examples that can be found in the playground file.

### Example 1

Here we create a set with random Integers. Printing the largest/smallest 5 numbers in the set is fairly easy.

```swift
// Example 1 with type Int
var mySet = SortedSet<Int>()

// Insert random numbers into the set
for _ in 0..<50 {
  mySet.insert(randomNum(50, max: 500))
}

print(mySet)

print(mySet.max())
print(mySet.min())

// Print the 5 largest values
for k in 1...5 {
  print(mySet.kLargest(k))
}

// Print the 5 lowest values
for k in 1...5 {
  print(mySet.kSmallest(k))
}
```

### Example 2

In this example we take a look at something a bit more interesting. We define a `Player` struct as follows:

```swift
public struct Player: Comparable {
  public var name: String
  public var points: Int
}
```

The `Player` also gets its own `==` and `<` operators. The `<` operator is used to determine the sort order of the set, while `==` determines whether two objects are really equal.

Note that `==` compares both the name and the points:  

```swifr
func ==(x: Player, y: Player) -> Bool {
  return x.name == y.name && x.points == y.points
}
```

But `<` only compares the points:

```swift
func <(x: Player, y: Player) -> Bool {
  return x.points < y.points
}
```

Therefore, two `Player`s can each have the same value (the number of points), but are not guaranteed to be equal (they can have different names).

We create a new set and insert 20 random players. The `Player()` constructor gives each player a random name and score:

```swift
var playerSet = SortedSet<Player>()

// Populate the set with random players.
for _ in 0..<20 {
  playerSet.insert(Player())
}
```

Insert another player:

```swift
var anotherPlayer = Player()
playerSet.insert(anotherPlayer)
```

Now we use the `indexOf()` function to find out what rank `anotherPlayer` is.

```swift
let level = playerSet.count - playerSet.indexOf(anotherPlayer)!
print("\(anotherPlayer.name) is ranked at level \(level) with \(anotherPlayer.points) points")
```

### Example 3

The final example demonstrates the need to look for the right item even after the binary search has completed.

We insert 9 players into the set:

```swift
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
```

Notice how several of these players have the same value of 100 points.

The set looks something like this:

	[Player 9, Player 6, Player 1, Player 2, Player 3, Player 4, Player 5, Player 7, Player 8]

The next line looks for `Player 2`:

```swift
print(repeatedSet.index(of: Player(name: "Player 2", points: 100)))
```

After the binary search finishes, the value of `mid` is at index 5:

	[Player 9, Player 6, Player 1, Player 2, Player 3, Player 4, Player 5, Player 7, Player 8]
	                                                      mid

However, this is not `Player 2`. Both `Player 4` and `Player 2` have the same points, but a different name. The binary search only looked at the points, not the name.

But we do know that `Player 2` must be either to the immediate left or the right of `Player 4`, so we check both sides of `mid`. We only need to look at the objects with the same value as `Player 4`. The others are replaced by `X`:

	[X, X, Player 1, Player 2, Player 3, Player 4, Player 5, X, X]
	                                       mid

The code then first checks on the right of `mid` (where the `*` is):

	[X, X, Player 1, Player 2, Player 3, Player 4, Player 5, X, X]
	                                       mid        *

The right side did not contain the item, so we look at the left side:

	[X, X, Player 1, Player 2, Player 3, Player 4, Player 5, X, X]
	                              *        mid        
	
	[X, X, Player 1, Player 2, Player 3, Player 4, Player 5, X, X]
	                    *                  mid        

Finally, we've found `Player 2`, and return index 3.

*Written By Zain Humayun*
