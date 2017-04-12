/*
 Finds the minimum value in an array in O(n) time.
 */

func minimum<T: Comparable>(_ array: [T]) -> T? {
    var array = array
    guard !array.isEmpty else {
        return nil
    }

    var minimum = array.removeFirst()
    for element in array {
        minimum = element < minimum ? element : minimum
    }
    return minimum
}
