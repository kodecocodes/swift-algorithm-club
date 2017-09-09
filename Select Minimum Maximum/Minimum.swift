/*
 Finds the minimum value in an array in O(n) time.
 */

func minimum<T: Comparable>(_ array: [T]) -> T? {
    guard var minimum = array.first else { return nil }
 
    for element in array.dropFirst() {
        minimum = element < minimum ? element : minimum
    }
    return minimum
}
