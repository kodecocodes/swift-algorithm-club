/*

Queue

A queue is a list where you can only insert new items at the back and remove items from the front. This ensures that the first item you enqueue is also the first item you dequeue. First come, first serve!

A queue gives you a FIFO or first-in, first-out order. The element you inserted first is also the first one to come out again. It's only fair! (A very similar data structure, the stack, is LIFO or last-in first-out.)

Insertion - O(1)
Deletion - O(n)


*/


import UIKit


public struct Queue<T> {
    private var array = [T]()
    
    public var count: Int {
        return array.count
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public mutating func enqueue(element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        if count == 0 {
            return nil
        } else {
            return array.removeFirst()
        }
    }
    
    public func peek() -> T? {
        return array.first
    }
}


var queueOfNames = Queue(array: ["Carl", "Lisa", "Stephanie", "Jeff", "Wade"]) // Initialized queue

queueOfNames.enqueue("Mike") // Adds element to the end of the queue. Queue is now ["Carl", "Lisa", "Stephanie", "Jeff", "Wade", "Mike"]

queueOfNames.dequeue() // Removes and returns the first element in the queue. Returns "Carl" and then removes it from the queue

queueOfNames.peek() // Returns the first element in the queue. Returns "Lisa" since "Carl" was dequeued on the previous line

queueOfNames.isEmpty // Checks to see if the queue is empty. Returns "False" since the queue still has elements in it.

