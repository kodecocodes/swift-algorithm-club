/*

Stack

A stack is like an array but with limited functionality. You can only push to add a new element to the top of the stack, pop to remove the element from the top, and peek at the top element without popping it off.

A stack gives you a LIFO or last-in first-out order. The element you pushed last is the first one to come off with the next pop. (A very similar data structure, the queue, is FIFO or first-in first-out.)

Insertion - O(1)
Deletion - O(1)


*/

import UIKit

public struct Stack<T> {
    private var array = [T]()
    
    public var count: Int {
        return array.count
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public mutating func push(element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        if count == 0 {
            return nil
        } else {
            return array.removeLast()
        }
    }
    
    public func peek() -> T? {
        return array.last
    }
    
}


var stackOfNames = Stack(array: ["Carl", "Lisa", "Stephanie", "Jeff", "Wade"]) // Initialized queue

stackOfNames.push("Mike") // Adds element to the end of the stack. Stack is now ["Carl", "Lisa", "Stephanie", "Jeff", "Wade", "Mike"]

stackOfNames.pop() // Removes and returns the last element in the stack. Returns "Mike" and then removes it from the stack

stackOfNames.peek() // Returns the first element in the stack. Returns "Wade" since "Mike" was popped on the previous line

stackOfNames.isEmpty // Checks to see if the stack is empty. Returns "False" since the stack still has elements in it


