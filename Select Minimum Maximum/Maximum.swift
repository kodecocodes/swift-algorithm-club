/*
 Finds the maximum value in an array in O(n) time.
 */

func maximum<T: Comparable>(_ array: [T]) -> T? {
    var array = array
    guard !array.isEmpty else {
        return nil
    }

    var maximum = array.removeFirst()
    for element in array {
        maximum = element > maximum ? element : maximum
    }
    return maximum
}
