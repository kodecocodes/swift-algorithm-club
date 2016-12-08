/*
 An ordered array. When you add a new item to this array, it is inserted in
 sorted position.
 */
public struct OrderedArray<T: Comparable> {
    fileprivate var array = [T]()
    
    public init(array: [T]) {
        self.array = array.sorted()
    }
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public subscript(index: Int) -> T {
        return array[index]
    }
    
    public mutating func remove(at index: Int) -> T {
        return array.remove(at: index)
    }
    
    public mutating func removeAll() {
        array.removeAll()
    }
    
    public mutating func insert(_ newElement: T) -> Int {
        let i = findInsertionPoint(newElement: newElement)
        array.insert(newElement, at: i)
        return i
    }
    
    private func findInsertionPoint(newElement: T) -> Int {
        let range = 0..<array.count
        var start = range.startIndex
        var end = range.endIndex
        while start < end {
            let midIndex = start + (end - start) / 2
            if array[midIndex] == newElement {
                return midIndex
            } else if array[midIndex] < newElement {
                start = midIndex + 1
            } else {
                end = midIndex
            }
        }
        return start
    }
}

extension OrderedArray: CustomStringConvertible {
    public var description: String {
        return array.description
    }
}
