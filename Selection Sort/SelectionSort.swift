public func selectionSort<T: Comparable>(_ array: inout [T], _ isOrderedBefore: (T, T) -> Bool) {
    guard array.count > 1 else { return array }

    for x in 0 ..< array.count - 1 {

        // Find the lowest value in the rest of the array.
        var lowest = x
        for y in x + 1 ..< array.count {
            if isOrderedBefore(array[y], array[lowest]) {
                lowest = y
            }
        }

        // Swap the lowest value with the current array index.
        if x != lowest {
            array.swapAt(x, lowest)
        }
    }
}
