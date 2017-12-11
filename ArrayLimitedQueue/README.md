# ArrayLimitedQueue

Array Limited Queue is a collection that has the features of a regular array (only get + limited size), queues and sets. The way you evaluate and compare items can be determined by the user.

The ArrayLimitedQueue data type is a hybrid of:
- a [Queue](https://en.wikipedia.org/wiki/Queue_(abstract_data_type)), is a list where you can only insert new items at the back and remove items from the front. This ensures that the first item you enqueue is also the first item you dequeue. First come, first serve!
- a [Set](https://en.wikipedia.org/wiki/Set_%28mathematics%29), a collection of unique items where the order does not matter.
- a [Sequence](https://en.wikipedia.org/wiki/Sequence), an list of items where each item may appear more than once.
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

## Why use an ArrayLimitedQueue?

This collection is convenient because it combines the functionality of other data structures. It also has a user-friendly interface and dynamic properties. The best example to use is the table(UITableView) with the "opening" sections(Will be added later).

## The code

We'll start by creating our internal representation for the ArrayLimitedQueue. Since the idea of a set is similar to that of an array, we will use an array to represent our set. We need to be able to compare the individual elements. Thus, any type must conform to the [Comparable Protocol](https://developer.apple.com/library/watchos/documentation/Swift/Reference/Swift_Comparable_Protocol/index.html).

```swift
public struct ArrayLimitedQueue<T: Comparable> {
    private var internalArray = [T]()
    //...
}
```

It is also possible to configure additional properties that support the change after creating or inserting elements:

```swift
    public var maxSize: Int = 1 {
        didSet {
            let sizeDiff = internalArray.count - maxSize
            if 0 < sizeDiff && sizeDiff <= internalArray.count {
                internalArray.removeFirst(sizeDiff)
            }
        }
    }

    public var zeroValue:T?
    public var positiveValues: Bool = false {
        didSet {
            if positiveValues {
                
                if let zero = zeroValue {
                    internalArray = internalArray.filter{$0 > zero}.map{ $0 }
                    
                } else if let defaultZero = 0 as? T {
                    internalArray = internalArray.filter{$0 > defaultZero}.map{ $0 }
                    
                } else {
                    fatalError("A zeroValue is not setted")
                }
            }
        }
    }
    
    public var deleteExisting = true {
        didSet {
            if deleteExisting {
                internalArray = internalArray.reversed().reduce([]){$0.contains($1) ? $0 : $0 + [$1]}.reversed()
            }
        }
    }
```
> **Note:** When using custom types, you need to set the zeroValue.

Lets take a look at the `add()` function first. This first checks if the item already exists in the collection and the property(deleteExisting) is set to a true value.

```swift
    public mutating func add(item: T) -> T? {

        if let index = indexOf(item: item), deleteExisting {
            return internalArray.remove(at: index)
        }
        
        if positiveValues {
            
            guard let zero = zeroValue, zero < item else {
                return nil
            }
        }
        
        internalArray.append(item)
        
        return self.checkSize()
    }
```

After `add()` a new element, the size of the array is checked. And if it exceeds a `maxSize`, the first element of the collection will be deleted:

```swift
    private mutating func checkSize() -> T? {
        
        guard
            0 < maxSize && maxSize < internalArray.count,
            let first = internalArray.first
        else {
            return nil
        }
        
        internalArray.removeFirst()
        return first
    }
```

Next up is the `removableItems()` function:

```swift
    public func removableItems(forMaxSize size: Int) -> [T] {
        
        var deletingArray = [T]()
        var removingIndex = 0
        
        var sizeDiff = internalArray.count - size
        
        while sizeDiff > 0 {
            
            deletingArray.append(internalArray[removingIndex])
            removingIndex += 1
            sizeDiff -= 1
        }
        
        return deletingArray
    }
```
This function is necessary for those situations when you need to know what elements will be deleted after setting a new value `maxSize`.

## Examples

Below are a few examples that can be found in the playground file.

### Example 1

Here we create a collection with several values.

```swift
var limitedArray = ArrayLimitedQueue<Int>()

//Unlimited size
limitedArray.maxSize = 0
limitedArray.positiveValues = false
limitedArray.deleteExisting = false

limitedArray.add(item: 2)
limitedArray.add(item: 5)
limitedArray.add(item: 3)
limitedArray.add(item: -5)
limitedArray.add(item: 1)
limitedArray.add(item: 3)
limitedArray.add(item: 8)

//IntArray: [2, 5, 3, -5, 1, 3, 8]
```
Now let's check what elements will be deleted at a possible new maximum size.
```swift
print("Removable: \(intArray.removableItems(forMaxSize: 5))")
//Removable: [2, 5]
```
Let's check it out:

```swift
limitedArray.maxSize = 5
//IntArray: [3, -5, 1, 3, 8]
```
We can get rid of negative values.
```swift
limitedArray.positiveValues = true
//IntArray: [3, 1, 3, 8]
```
And most importantly, at any time we can remove duplicates (In the collection remains the last added).
```swift
limitedArray.deleteExisting = true
//IntArray: [1, 3, 8]
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

```swift
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

We create a new collection and 5 random players. `add()` them to the collection, with two duplicates
```swift
var limitedArray = ArrayLimitedQueue<Player>()

limitedArray.maxSize = 0
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

/*
[
Player(name: "PwVBbmGz", points: -1487), #1
Player(name: "PTEsCzSa", points: 2608), #2
Player(name: "slRgehCg", points: -2026), #3
Player(name: "jHBMTMLb", points: -1318), #4
Player(name: "sIDqxbYU", points: -3243), #5
Player(name: "PTEsCzSa", points: 2608), #6
Player(name: "slRgehCg", points: -2026) #7
]
*/
```
We will do all the operations as in the previous example.

```swift
limitedArray.maxSize = 2
limitedArray.zeroValue = Player(name: "Any", points: 0)
limitedArray.positiveValues = true
limitedArray.deleteExisting = true

/*
[Player(name: "ehnx5gvL", points: 3797)] #6
*/
```
Let's run through our actions:
- a After installing a new maxSize(6), #1 one was deleted.
- a Then, the negative elements were removed(#3, #4, #5, #7).
- a Finally, we got rid of the duplicate(#2).

*Written By Sergey Pugach*






