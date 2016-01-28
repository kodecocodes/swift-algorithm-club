//
//  Heap.swift
//  Written for the Swift Algorithm Club by Kevin Randrup
//

/**
 * A heap is a type of tree data structure with 2 charactersitics:
 * 1. Parent nodes are either greater or less than each one of their children (called max heaps and min heaps respectively)
 * 2. Only the top item is accessible (greatest or smallest)
 *
 * This results in a data structure that stores n items in O(n) space. Both insertion and deletion take O(log(n)) time (amortized).
 */
protocol Heap {
    typealias Value
    mutating func insert(value: Value)
    mutating func remove() -> Value?
    var count: Int { get }
    var isEmpty: Bool { get }
}

/**
 * A MaxHeap stores the highest items at the top. Calling remove() will return the highest item in the heap.
 */
public struct MaxHeap<T : Comparable> : Heap {
    
    typealias Value = T
    
    /**   10
     *  7    5
     * 1 2  3
     * Will be represented as [10, 7, 5, 1, 2, 3]
     */
    private var mem: [T]
    
    init() {
        mem = [T]()
    }

    init(array: [T]) {
        self.init()
        mem.reserveCapacity(array.count)
        for value in array {
            insert(value)
        }
    }
    
    public var isEmpty: Bool {
        return mem.isEmpty
    }
    
    public var count: Int {
        return mem.count
    }
    
    /**
     * Inserts the value into the Heap in O(log(n)) time
     */
    public mutating func insert(value: T) {
        mem.append(value)
        upShift(index: mem.count - 1)
    }
    
    public mutating func insert<S : SequenceType where S.Generator.Element == T>(sequence: S) {
        for value in sequence {
            insert(value)
        }
    }
    
    /**
     * Removes the max value from the heap in O(logn)
     */
    public mutating func remove() -> T? {
        //Handle empty/1 element cases.
        if mem.isEmpty {
            return nil
        }
        else if mem.count == 1 {
            return mem.removeLast()
        }
        
        
        // Pull the last element up to replace the first one
        let value = mem[0]
        let last = mem.removeLast()
        mem[0] = last
        
        //Downshift the new top value
        downShift()
        
        return value
    }

    //MARK: Private implmentation
    
    /**
     * Returns the parent's index given the child's index.
     * 1,2 -> 0
     * 3,4 -> 1
     * 5,6 -> 2
     * 7,8 -> 3
     */
    private func parentIndex(childIndex childIndex: Int) -> Int {
        return (childIndex - 1) / 2
    }
    
    private func firstChildIndex(index: Int) -> Int {
        return index * 2 + 1
    }
    
    @inline(__always) private func validIndex(index: Int) -> Bool {
        return index < mem.endIndex
    }
    
    /**
     * Restore the heap property above a given index.
     */
    private mutating func upShift(index index: Int) {
        var childIndex = index
        let child = mem[childIndex]
        while childIndex != 0 {
            let parentIdx = parentIndex(childIndex: childIndex)
            let parent = mem[parentIdx]
            //If the child doesn't need to be swapped up, return
            if child <= parent {
                return
            }
            //Otherwise, swap the child up the tree
            mem[parentIdx] = child
            mem[childIndex] = parent
            
            //Update childIdx
            childIndex = parentIdx
        }
    }
    
    /**
     * Maintains the heap property of parents > both children
     */
    private mutating func downShift(index index: Int = 0) {
        var parentIndex = index
        var leftChildIndex = firstChildIndex(parentIndex)
        
        //Loop preconditions: parentIndex and left child index are set
        while (validIndex(leftChildIndex)) {
            let rightChildIndex = leftChildIndex + 1
            let highestIndex: Int
            
            //If we have valid right and left indexes, choose the highest one
            if (validIndex(rightChildIndex)) {
                let left = mem[leftChildIndex]
                let right = mem[rightChildIndex]
                highestIndex = (left > right) ? leftChildIndex : rightChildIndex
            } else {
                highestIndex = leftChildIndex
            }
            
            //If the child > parent, swap them
            let parent = mem[parentIndex]
            let highestChild = mem[highestIndex]
            if highestChild <= parent { return }

            mem[parentIndex] = highestChild
            mem[highestIndex] = parent
            
            //Set the loop preconditions
            parentIndex = highestIndex
            leftChildIndex = firstChildIndex(parentIndex)
        }
    }
}
