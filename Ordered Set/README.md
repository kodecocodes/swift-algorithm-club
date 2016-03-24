# Ordered Set
An Ordered Set is a collection of unique items in sorted order. Items are usually sorted from least to greatest. The Ordered Set data type is a representation of a [Set in Mathematics](https://en.wikipedia.org/wiki/Set_(mathematics)). It's important to keep in mind that two items can have the same *value* but still may not be equal. 
For example, we could define "a" and "z" to have the same value (their lengths), but clearly "a" != "z".

### Examples of Ordered Sets
```
{1, 2, 3, 6, 8, 10, 1000}
Where each item (Integers) has it's normal definition of value and equality
```
```
{"a", "is", "set", "this"}
Where each item (String) has it's value equal to it's length
```

### These are not Ordered Sets
```
{1, 1, 2, 3, 5, 8}
This Set violates the property of uniqueness
```
```
{1, 11, 2, 3}
This Set violates the sorted property
```

## The Code
We'll start by creating our internal representation for the Ordered Set. Since the idea of a set is similar to that of an array, we will use an array to represent our set. Furthermore, since we'll need to keep our set sorted, we need to compare the individual elemants. Thus, any type must conform to the [Comparable Protocol](https://developer.apple.com/library/watchos/documentation/Swift/Reference/Swift_Comparable_Protocol/index.html).

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
```
The first part of the function checks if the item is already in the set.As we'll see later on, this has an efficiency of **O(nlog n + k)**. The second part iterates through the interal array so that it can find a spot for our given item. This is at worse **O(n)**. The insert function for arrays has an efficiency of **O(nlog(n))**, thus making the insert function for our Ordered Set **O(nlog(n) + k)** where k is the number of items with the same value as the item we are inserting.


Next we have the remove function. First check if the item exists. If not, then return and no nothing. If it does exist, remove it.

``` swift
    // removes an item if it exists
    public mutating func remove(item: T) {
        if !exists(item) {
            return
        }
        
        internalSet.removeAtIndex(findIndex(item))
    }
```
Again, because of the `exists` function, the efficiency for remove is **O(nlog(n) + k)**


*Written By Zain Humayun*
