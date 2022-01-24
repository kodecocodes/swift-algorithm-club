/**
    Data structure that can efficiently update elements and calculate prefix sums in a table of numbers
 */
public class BinaryIndexedTree<T: Numeric> {
    
    private var values: [T]
    private var tree: [T]
    
    public init(array: [T]) {
        self.values = Array(repeating: 0, count: array.count)
        
        // first element (ie index 0) is root
        self.tree = Array(repeating: 0, count: array.count + 1)
        
        for (index, value) in array.enumerated() {
            update(at: index, with: value)
        }
    }
    
    // Updates value at given index with a new value
    // Complexity: O(ln(n))
    public func update(at index: Int, with value: T) {
        updateInternally(at: index, with: value - values[index])
    }
    
    // Calculates sum of the given interval.
    // Inteval given by [from - to] inclusive
    // Complexity: O(ln(n))
    public func query(from lowerIndex: Int, to upperIndex: Int) -> T {
        return queryInternally(to: upperIndex) - queryInternally(to: lowerIndex - 1)
    }
    
    private func updateInternally(at index: Int, with diff: T) {
        self.values[index] += diff
        
        var treeIndex = index + 1
        while isValid(index: treeIndex) {
            tree[treeIndex] += diff
            treeIndex = sibling(for: treeIndex)
        }
    }
    
    private func queryInternally(to upperIndex: Int) -> T {
        var sum: T = 0
        
        var treeIndex = upperIndex + 1
        
        while isValid(index: treeIndex) {
            sum += tree[treeIndex]
            treeIndex = parent(for: treeIndex)
        }
        
        return sum
    }
    
    private func isValid(index: Int) -> Bool {
        return index > 0 && index < tree.count
    }
    
    private func parent(for index: Int) -> Int {
        return index - index & (~index + 1);
    }
    
    private func sibling(for index: Int) -> Int {
        return index + index & (~index + 1);
    }
    
}
