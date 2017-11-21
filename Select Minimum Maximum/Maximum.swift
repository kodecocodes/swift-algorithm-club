/*
 Finds the maximum value in an array in O(n) time.
 */

func maximum<T: Comparable>(_ array: [T]) -> T? {
    guard var maximum = array.first else { return nil }
    
    for element in array.dropFirst() {
        maximum = element > maximum ? element : maximum
    }
    return maximum
}
