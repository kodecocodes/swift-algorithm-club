/*
 Finds the maximum value in an array in O(n) time.
 */

func maximum<T: Comparable>(_ array: [T]) -> T? {
    guard !array.isEmpty else {
        return nil
    }

    var maximum = array.first!
    for element in array.dropFirst() {
        maximum = element > maximum ? element : maximum
    }
    return maximum
}
