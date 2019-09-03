/// Performs the Insertion sort algorithm to a given array
///
/// - Parameters:
///   - array: the array of elements to be sorted
///   - isOrderedBefore: function that given to inputs returns whether should be order before or after.  Allows for different sorts (e.g. change in direction).
/// - Returns: a sorted array containing the same elements
func insertionSort<T>(_ array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
    guard array.count > 1 else { return array }
    var sortedArray = array
    for index in 1..<sortedArray.count {
        if isOrderedBefore(sortedArray[index-1], sortedArray[index]) { continue }
        for currentIndex in (0..<index).reversed() {
            if isOrderedBefore(sortedArray[currentIndex], sortedArray[index]) {
                sortedArray.move(from: index, to: currentIndex + 1)
                break
            } else if currentIndex == 0 {
                sortedArray.move(from: index, to: 0)
            }
        }
    }
    return sortedArray
}

/// Performs the Insertion sort algorithm to a given array
///
/// - Parameter array: the array to be sorted, containing elements that conform to the Comparable protocol
/// - Returns: a sorted array containing the same elements ordered from lowest to highest
func insertionSort<T: Comparable>(_ array: [T]) -> [T] {
    return insertionSort(array, <)
}

fileprivate extension Array {
    mutating func move(from: Int, to: Int) {
        let removed = self[from]
        self.remove(at: from)
        self.insert(removed, at: to)
    }
}

let list = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
print(insertionSort(list))
print(insertionSort(list, <))
print(insertionSort(list, >))
