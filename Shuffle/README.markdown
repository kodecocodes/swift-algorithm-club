# Shuffle

Goal: Rearrange the contents of an array.

Imagine you're making a card game and you need to shuffle a deck of cards. You can represent the deck by an array of `Card` objects and shuffling the deck means to change the order of those objects in the array. (It's like the opposite of sorting.)

Here is a naive way to approach this in Swift:

```swift
extension Array {
  public mutating func shuffle() {
    var temp = [Element]()
    while !isEmpty {
      let i = random(count)
      let obj = remove(at: i)
      temp.append(obj)
    }
    self = temp
  }
}
```

To try it out, copy the code into a playground and then do:

```swift
var list = [ "a", "b", "c", "d", "e", "f", "g" ]
list.shuffle()
list.shuffle()
list.shuffle()
```

You should see three different arrangements -- or [permutations](../Combinatorics/) to use math-speak -- of the objects in the array.

This shuffle works *in place*, it modifies the contents of the original array. The algorithm works by creating a new array, `temp`, that is initially empty. Then we randomly choose an element from the original array and append it to `temp`, until the original array is empty. Finally, the temporary array is copied back into the original one.

This code works just fine but it's not very efficient. Removing an element from an array is an **O(n)** operation and we perform this **n** times, making the total algorithm **O(n^2)**. We can do better!

## The Fisher-Yates / Knuth shuffle

Here is a much improved version of the shuffle algorithm:

```swift
extension Array {
  public mutating func shuffle() {
    for i in stride(from: count - 1, through: 1, by: -1) {
      let j = Int.random(in: 0...i)
      if i != j {
        swap(&self[i], &self[j])
      }
    }
  }
}
```

Again, this picks objects at random. In the naive version we placed those objects into a new temporary array so we could keep track of which objects were already shuffled and which still remained to be done. In this improved algorithm, however, we'll move the shuffled objects to the end of the original array. 

Let's walk through the example. We have the array:

	[ "a", "b", "c", "d", "e", "f", "g" ]

The loop starts at the end of the array and works its way back to the beginning. The very first random number can be any element from the entire array. Let's say it returns 2, the index of `"c"`. We swap `"c"` with `"g"` to move it to the end:

	[ "a", "b", "g", "d", "e", "f" | "c" ]
	             *                    *

The array now consists of two regions, indicated by the `|` bar. Everything to the right of the bar is shuffled already. 

The next random number is chosen from the range 0...6, so only from the region `[ "a", "b", "g", "d", "e", "f" ]`. It will never choose `"c"` since that object is done and we'll no longer touch it.

Let's say the random number generator picks 0, the index of `"a"`. Then we swap `"a"` with `"f"`, which is the last element in the unshuffled portion, and the array looks like this:

	[ "f", "b", "g", "d", "e" | "a", "c" ]
	   *                         *

The next random number is somewhere in `[ "f", "b", "g", "d", "e" ]`, so let's say it is 3. We swap `"d"` with `"e"`:

	[ "f", "b", "g", "e" | "d", "a", "c" ]
	                  *     *

And so on... This continues until there is only one element remaining in the left portion. For example:

	[ "b" | "e", "f", "g", "d", "a", "c" ]

There's nothing left to swap that `"b"` with, so we're done.

Because we only look at each array element once, this algorithm has a guaranteed running time of **O(n)**. It's as fast as you could hope to get!

## Creating a new array that is shuffled

There is a slight variation on this algorithm that is useful for when you want to create a new array instance that contains the values `0` to `n-1` in random order.

Here is the code:

```swift
public func shuffledArray(_ n: Int) -> [Int] {
  var a = [Int](repeating: 0, count: n)
  for i in 0..<n {
    let j = Int.random(in: 0...i)
    // for the Fisher–Yates_shuffle's pseudo code implement in wiki, it will check if i != j
    a[i] = a[j]
    a[j] = i
  }
  return a
}
```

To use it:

```swift
let numbers = shuffledArray(10)
```

This returns something like `[3, 0, 9, 1, 8, 5, 2, 6, 7, 4]`. As you can see, every number between 0 and 10 is in that list, but shuffled around. Of course, when you try it for yourself the order of the numbers will be different. 

The `shuffledArray()` function first creates a new array with `n` zeros. Then it loops `n` times and in each step adds the next number from the sequence to a random position in the array. The trick is to make sure that none of these numbers gets overwritten with the next one, so it moves the previous number out of the way first!

For this function, `The condition that checks if j ≠ i may be omitted in languages that have no problems accessing uninitialized array values, and for which assigning is cheaper than comparing.`, you can check it in wiki. And also remove checking logic will optimise performance.

The algoritm is quite clever and I suggest you walk through an example yourself, either on paper or in the playground. (Hint: Again it splits the array into two regions.)

## See also

These Swift implementations are based on pseudocode from the [Wikipedia article](https://en.wikipedia.org/wiki/Fisher–Yates_shuffle).

Mike Bostock has a [great visualization](http://bost.ocks.org/mike/shuffle/) of the shuffle algorithm.

*Written for Swift Algorithm Club by Matthijs Hollemans*
