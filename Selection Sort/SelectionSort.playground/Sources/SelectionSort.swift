/// Performs the Selection sort algorithm on a array
///
/// - Parameter array: array of elements that conform to the Comparable protocol
/// - Returns: an array in ascending order
public func selectionSort<T: Comparable>(_ array: [T]) -> [T] {
  return insertionSort(array, <)
}

/// Performs the Selection sort algorithm on a array using the provided comparisson method
///
/// - Parameters:
///   - array: array of elements that conform to the Comparable protocol
///   - isLowerThan: returns true if the two provided elements are in the correct order
/// - Returns: a sorted array
public func selectionSort<T>(_ array: [T], _ isLowerThan: (T, T) -> Bool) -> [T] {
    guard array.count > 1 else { return array }
    
    var a = array
    for x in 0 ..< a.count - 1 {
        
        // Find the lowest value in the rest of the array.
        var lowest = x
        for y in x + 1 ..< a.count {
            if isLowerThan(a[y], a[lowest]) {
                lowest = y
            }
        }
        
        // Swap the lowest value with the current array index.
        if x != lowest {
            a.swapAt(x, lowest)
        }
    }
    return a
}
