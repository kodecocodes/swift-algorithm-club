/**
  Stack

  A stack is like an array but with limited functionality. You can only push
  to add a new element to the top of the stack, pop to remove the element from
  the top, and peek at the top element without popping it off.

  A stack gives you a LIFO or last-in first-out order. The element you pushed
  last is the first one to come off with the next pop.

  Push and pop are O(1) operations.
 
  ## Usage
  ```
  var myStack = Stack(array: [])
  myStack.push(10)
  myStack.push(3)
  myStack.push(57)
  myStack.pop() // 57
  myStack.pop() // 3
 ```
*/
public struct Stack<T> {
    
  /// Datastructure consisting of a generic item.
  fileprivate var array = [T]()

  /// The number of items in the stack.
  public var count: Int {
    return array.count
  }

  /// Verifies if the stack is empty.
  public var isEmpty: Bool {
    return array.isEmpty
  }

  /**
     Pushes an item to the top of the stack.
     
     - Parameter element: The item being pushed.
  */
  public mutating func push(_ element: T) {
    array.append(element)
  }

  /**
     Removes and returns the item at the top of the sack.
     
     - Returns: The item at the top of the stack.
  */
  public mutating func pop() -> T? {
    return array.popLast()
  }

  /// Returns the item at the top of the stack.
  public var top: T? {
    return array.last
  }
}

// Create a stack and put some elements on it already.
var stackOfNames = Stack(array: ["Carl", "Lisa", "Stephanie", "Jeff", "Wade"])

// Add an element to the top of the stack.
stackOfNames.push("Mike")

// The stack is now ["Carl", "Lisa", "Stephanie", "Jeff", "Wade", "Mike"]
print(stackOfNames.array)

// Remove and return the first element from the stack. This returns "Mike".
stackOfNames.pop()

// Look at the first element from the stack.
// Returns "Wade" since "Mike" was popped on the previous line.
stackOfNames.top

// Check to see if the stack is empty.
// Returns "false" since the stack still has elements in it.
stackOfNames.isEmpty
