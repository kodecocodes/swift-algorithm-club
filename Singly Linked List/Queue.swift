import Foundation


/// Data structure that provides FIFO access
protocol Queue
{
    associatedtype Item
    
    
    /// Adds an element to the queue
    ///
    /// - Parameter item: Item to be added
    /// - Throws: There are cases where the operation might fail. For example if there is not enough space.
    mutating func enqueue(item: Item) throws
    
    
    /// Returns the oldest element in the queue.
    ///
    /// - Returns: The oldest element in the queue. It does not dequeue it.
    func getFirst() -> Item?
    
    
    /// Dequeues the oldest element in the queue.
    ///
    /// - Returns: The oldest element in the queue, which gets removed from it.
    mutating func dequeue() -> Item?
    
}
