/*
 Finds the minimum value in an array in O(n) time.
 */

func minimum<T: Comparable>(_ array: [T]) -> T? {
    guard !array.isEmpty else {
        return nil
    }

    var minimum = array.first!
    for element in array.dropFirst() {
        minimum = element < minimum ? element : minimum
    }
    return minimum
}
