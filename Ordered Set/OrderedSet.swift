// An Ordered Set is a collection where all items in the set follow an ordering, usually ordered from
// 'least' to 'most'. The way you value, and compare items can be user defined.
public struct OrderedSet<T: Comparable> {
    private var internalSet: [T]! = nil
    
    // returns size of Set
    public var count: Int {
        return internalSet!.count
    }
    
    public init(){
        internalSet = [T]() // create the internal array on init
    }
    
    // inserts an item into the set if it doesn't exist
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
    
    // removes an item if it exists
    public mutating func remove(item: T) {
        if !exists(item) {
            return
        }
        
        internalSet.removeAtIndex(findIndex(item))
    }
    
    // returns true if and only if the item exists somewhere in the set
    public func exists(item: T) -> Bool {
        let index = findIndex(item)
        return index != -1 && internalSet[index] == item
    }
    
    // returns the index of an item if it exists, otherwise returns -1.
    public func findIndex(item: T) -> Int {
        var leftBound = 0
        var rightBound = count - 1
        
        while leftBound <= rightBound {
            let mid = leftBound + ((rightBound - leftBound) / 2)
            
            if internalSet[mid] > item {
                rightBound = mid - 1
            } else if internalSet[mid] < item {
                leftBound = mid + 1
            } else {
                return mid
            }
        }
        
        return -1
    }
    
    // returns the item at the given index. assertion fails if the index is out of the range
    // of [0, count)
    public subscript(index: Int) -> T {
        assert(index >= 0 && index < count)
        return internalSet[index]
    }
    
    // returns the 'maximum' or 'largest' value in the set
    public func max() -> T! {
        return count == 0 ? nil : internalSet[count - 1]
    }
    
    // returns the 'minimum' or 'smallest' value in the set
    public func min() -> T! {
        return count == 0 ? nil : internalSet[0]
    }
    
    // returns the k largest element in the set, if k is in the range [1, count]
    // returns nil otherwise
    public func kLargest(k: Int) -> T! {
        return k > count || k <= 0 ? nil : internalSet[count - k]
    }
    
    // returns the k smallest element in the set, if k is in the range [1, count]
    // returns nil otherwise
    public func kSmallest(k: Int) -> T! {
        return k > count || k <= 0 ? nil : internalSet[k - 1]
    }
}
