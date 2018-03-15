/*
 First-in first-out queue (FIFO)
 Implemented using LinkedList

 New elements are added to the end of the queue. Dequeuing pulls elements from
 the front of the queue.
 
  Enqueuing and dequeuing are O(1) operations.
 */

protocol QueueProtocol {
    associatedtype T
    var isEmpty: Bool { get }
    func enqueue(item: T)
    func dequeue() -> T?
}

class LinkedList<T>: QueueProtocol {
    
    public class LinkedListNode<T> {
        var value: T
        var next: LinkedListNode?
        
        init(value: T) {
            self.value = value
        }
    }
    
    private var first: LinkedListNode<T>?
    private var last: LinkedListNode<T>?
    
    var isEmpty: Bool {
        return first == nil
    }
    
    private var counter = 0
    
    var count: Int {
        return counter
    }
    
    func enqueue(item: T) {
        let oldLast = last
        last = LinkedListNode(value: item)
        last?.next = nil
        
        if isEmpty {
            first = last
        } else {
            oldLast?.next = last
        }
        
        counter += 1
    }
    
    func dequeue() -> T? {
        if let item = first?.value {
            first = first?.next
            if isEmpty {
                last = nil
            }
            
            counter -= 1
            return item
        }
        
        return nil
    }
    
    public var front: T? {
        return isEmpty ? nil : first?.value
    }
}
