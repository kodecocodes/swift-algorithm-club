# Stack

> This topic has been tutorialized [here](https://www.raywenderlich.com/149213/swift-algorithm-club-swift-stack-data-structure)

A stack is like an array but with limited functionality. You can only *push* to add a new element to the top of the stack, *pop* to remove the element from the top, and *peek* at the top element without popping it off.

Why would you want to do this? Well, in many algorithms you want to add objects to a temporary list at some point and then pull them off this list again at a later time. Often the order in which you add and remove these objects matters.

A stack gives you a LIFO or last-in first-out order. The element you pushed last is the first one to come off with the next pop. (A very similar data structure, the [queue](../Queue/), is FIFO or first-in first-out.)

For example, let's push a number on the stack:

```swift
stack.push(10)
```

The stack is now `[ 10 ]`. Push the next number:

```swift
stack.push(3)
```

The stack is now `[ 10, 3 ]`. Push one more number:

```swift
stack.push(57)
```

The stack is now `[ 10, 3, 57 ]`. Let's pop the top number off the stack:

```swift
stack.pop()
```

This returns `57`, because that was the most recent number we pushed. The stack is `[ 10, 3 ]` again.

```swift
stack.pop()
```

This returns `3`, and so on. If the stack is empty, popping returns `nil` or in some implementations it gives an error message ("stack underflow").

A stack is easy to create in Swift. It's just a wrapper around an array that just lets you push, pop, and look at the top element of the stack:

```swift
public struct Stack<T> {
  fileprivate var array = [T]()

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var count: Int {
    return array.count
  }

  public mutating func push(_ element: T) {
    array.append(element)
  }

  public mutating func pop() -> T? {
    return array.popLast()
  }

  public var top: T? {
    return array.last
  }
}
```

Notice that a push puts the new element at the end of the array, not the beginning. Inserting at the beginning of an array is expensive, an **O(n)** operation, because it requires all existing array elements to be shifted in memory. Adding at the end is **O(1)**; it always takes the same amount of time, regardless of the size of the array.

Fun fact about stacks: Each time you call a function or a method, the CPU places the return address on a stack. When the function ends, the CPU uses that return address to jump back to the caller. That's why if you call too many functions -- for example in a recursive function that never ends -- you get a so-called "stack overflow" as the CPU stack has run out of space.

*Written for Swift Algorithm Club by Matthijs Hollemans*
