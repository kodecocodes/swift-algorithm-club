# Deque

A double-ended queue. For some reason this is pronounced as "deck".

A regular [queue](../Queue/) adds elements to the back and removes from the front. The deque also allows enqueuing at the front and dequeuing from the back, and peeking at both ends.

Here is a very basic implementation of a deque in Swift:

```swift
public struct Deque<T> {
  private var array = [T]()
  
  public var isEmpty: Bool {
    return array.isEmpty
  }
  
  public var count: Int {
    return array.count
  }
  
  public mutating func enqueue(_ element: T) {
    array.append(element)
  }
  
  public mutating func enqueueFront(_ element: T) {
    array.insert(element, atIndex: 0)
  }
  
  public mutating func dequeue() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeFirst()
    }
  }
  
  public mutating func dequeueBack() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeLast()
    }
  }
  
  public func peekFront() -> T? {
    return array.first
  }
  
  public func peekBack() -> T? {
    return array.last
  }
}
```

This uses an array internally. Enqueuing and dequeuing are simply a matter of adding and removing items from the front or back of the array.

An example of how to use it in a playground:

```swift
var deque = Deque<Int>()
deque.enqueue(1)
deque.enqueue(2)
deque.enqueue(3)
deque.enqueue(4)

deque.dequeue()       // 1
deque.dequeueBack()   // 4

deque.enqueueFront(5)
deque.dequeue()       // 5
```

This particular implementation of `Deque` is simple but not very efficient. Several operations are **O(n)**, notably `enqueueFront()` and `dequeue()`. I've included it only to show the principle of what a deque does.

## A more efficient version
  
The reason that `dequeue()` and `enqueueFront()` are **O(n)** is that they work on the front of the array. If you remove an element at the front of an array, what happens is that all the remaining elements need to be shifted in memory.

Let's say the deque's array contains the following items:

	[ 1, 2, 3, 4 ]

Then `dequeue()` will remove `1` from the array and the elements `2`, `3`, and `4`, are shifted one position to the front:

	[ 2, 3, 4 ]

This is an **O(n)** operation because all array elements need to be moved by one position in the computer's memory.

Likewise, inserting an element at the front of the array is expensive because it requires that all other elements must be shifted one position to the back. So `enqueueFront(5)` will change the array to be:

	[ 5, 2, 3, 4 ]

First, the elements `2`, `3`, and `4` are moved up by one position in the computer's memory, and then the new element `5` is inserted at the position where `2` used to be.

Why is this not an issue at for `enqueue()` and `dequeueBack()`? Well, these operations are performed at the end of the array. The way resizable arrays are implemented in Swift is by reserving a certain amount of free space at the back. 

Our initial array `[ 1, 2, 3, 4]` actually looks like this in memory:

	[ 1, 2, 3, 4, x, x, x ]

where the `x`s denote additional positions in the array that are not being used yet. Calling `enqueue(6)` simply copies the new item into the next unused spot:

	[ 1, 2, 3, 4, 6, x, x ]

The `dequeueBack()` function uses `array.removeLast()` to delete that item. This does not shrink the array's memory but only decrements `array.count` by one. There are no expensive memory copies involved here. So operations at the back of the array are fast, **O(1)**.

It is possible the array runs out of free spots at the back. In that case, Swift will allocate a new, larger array and copy over all the data. This is an **O(n)** operation but because it only happens once in a while, adding new elements at the end of an array is still **O(1)** on average.

Of course, we can use this same trick at the *beginning* of the array. That will make our deque efficient too for operations at the front of the queue. Our array will look like this:

	[ x, x, x, 1, 2, 3, 4, x, x, x ]

There is now also a chunk of free space at the start of the array, which allows adding or removing elements at the front of the queue to be **O(1)** as well.

Here is the new version of `Deque`:

```swift
public struct Deque<T> {
  private var array: [T?]
  private var head: Int
  private var capacity: Int
  
  public init(_ capacity: Int = 10) {
    self.capacity = max(capacity, 1)
    array = .init(count: capacity, repeatedValue: nil)
    head = capacity
  }
  
  public var isEmpty: Bool {
    return count == 0
  }
  
  public var count: Int {
    return array.count - head
  }
  
  public mutating func enqueue(_ element: T) {
    array.append(element)
  }
  
  public mutating func enqueueFront(_ element: T) {
    // this is explained below
  }

  public mutating func dequeue() -> T? {
    // this is explained below
  }

  public mutating func dequeueBack() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeLast()
    }
  }
  
  public func peekFront() -> T? {
    if isEmpty {
      return nil
    } else {
      return array[head]
    }
  }
  
  public func peekBack() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.last!
    }
  }  
}
```

It still largely looks the same -- `enqueue()` and `dequeueBack()` haven't changed -- but there are also a few important differences. The array now stores objects of type `T?` instead of just `T` because we need some way to mark array elements as being empty.

The `init` method allocates a new array that contains a certain number of `nil` values. This is the free room we have to work with at the beginning of the array. By default this creates 10 empty spots. 

The `head` variable is the index in the array of the front-most object. Since the queue is currently empty, `head` points at an index beyond the end of the array.

	[ x, x, x, x, x, x, x, x, x, x ]
	                                 |
	                                 head

To enqueue an object at the front, we move `head` one position to the left and then copy the new object into the array at index `head`. For example, `enqueueFront(5)` gives:

	[ x, x, x, x, x, x, x, x, x, 5 ]
	                             |
	                             head

Followed by `enqueueFront(7)`:

	[ x, x, x, x, x, x, x, x, 7, 5 ]
	                          |
	                          head

And so on... the `head` keeps moving to the left and always points at the first item in the queue. `enqueueFront()` is now **O(1)** because it only involves copying a value into the array, a constant-time operation.

Here is the code:

```swift
  public mutating func enqueueFront(element: T) {
    head -= 1
    array[head] = element
  }
```

Appending to the back of the queue has not changed (it's the exact same code as before). For example, `enqueue(1)` gives:

	[ x, x, x, x, x, x, x, x, 7, 5, 1, x, x, x, x, x, x, x, x, x ]
	                          |
	                          head

Notice how the array has resized itself. There was no room to add the `1`, so Swift decided to make the array larger and add a number of empty spots to the end. If you enqueue another object, it gets added to the next empty spot in the back. For example, `enqueue(2)`:

	[ x, x, x, x, x, x, x, x, 7, 5, 1, 2, x, x, x, x, x, x, x, x ]
	                          |
	                          head

> **Note:** You won't see those empty spots at the back of the array when you `print(deque.array)`. This is because Swift hides them from you. Only the ones at the front of the array show up. 

The `dequeue()` method does the opposite of `enqueueFront()`, it reads the value at `head`, sets the array element back to `nil`, and then moves `head` one position to the right:

```swift
  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    return element
  }
```

There is one tiny problem... If you enqueue a lot of objects at the front, you're going to run out of empty spots at the front at some point. When this happens at the back of the array, Swift automatically resizes it. But at the front of the array we have to handle this situation ourselves, with some extra logic in `enqueueFront()`:

```swift
  public mutating func enqueueFront(element: T) {
    if head == 0 {
      capacity *= 2
      let emptySpace = [T?](count: capacity, repeatedValue: nil)
      array.insertContentsOf(emptySpace, at: 0)
      head = capacity
    }

    head -= 1
    array[head] = element
  }
```

If `head` equals 0, there is no room left at the front. When that happens, we add a whole bunch of new `nil` elements to the array. This is an **O(n)** operation but since this cost gets divided over all the `enqueueFront()`s, each individual call to `enqueueFront()` is still **O(1)** on average. 

> **Note:** We also multiply the capacity by 2 each time this happens, so if your queue grows bigger and bigger, the resizing happens less often. This is also what Swift arrays automatically do at the back.

We have to do something similar for `dequeue()`. If you mostly enqueue a lot of elements at the back and mostly dequeue from the front, then you may end up with an array that looks as follows:

	[ x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, 1, 2, 3 ]
	                                                              |
	                                                              head

Those empty spots at the front only get used when you call `enqueueFront()`. But if enqueuing objects at the front happens only rarely, this leaves a lot of wasted space. So let's add some code to `dequeue()` to clean this up:

```swift
  public mutating func dequeue() -> T? {
    guard head < array.count, let element = array[head] else { return nil }

    array[head] = nil
    head += 1

    if capacity > 10 && head >= capacity*2 {
      let amountToRemove = capacity + capacity/2
      array.removeFirst(amountToRemove)
      head -= amountToRemove
      capacity /= 2
    }
    return element
  }
```

Recall that `capacity` is the original number of empty places at the front of the queue. If the `head` has advanced more to the right than twice the capacity, then it's time to trim off a bunch of these empty spots. We reduce it to about 25%.

For example, this:

	[ x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, x, 1, 2, 3 ]
	                                |                             |
	                                capacity                      head

becomes after trimming:

	[ x, x, x, x, x, 1, 2, 3 ]
	              |
	              head
	              capacity

This way we can strike a balance between fast enqueuing and dequeuing at the front and keeping the memory requirements reasonable.

> **Note:** We don't perform trimming on very small arrays. It's not worth it for saving just a few bytes of memory.

## See also

Other ways to implement deque are by using a [doubly linked list](../Linked List/), a [circular buffer](../Ring Buffer/), or two [stacks](../Stack/) facing opposite directions.

[A fully-featured deque implementation in Swift](https://github.com/lorentey/Deque)

*Written for Swift Algorithm Club by Matthijs Hollemans*
