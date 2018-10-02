//: Playground - noun: a place where people can play

// last checked with Xcode 9.0b4
#if swift(>=4.0)
print("Hello, Swift 4!")
#endif

/// Performs the Insertion sort algorithm to a given array
///
/// - Parameters:
///   - array: the array of elements to be sorted
///   - isOrderedBefore: returns true if the elements provided are in the corect order
/// - Returns: a sorted array containing the same elements
func insertionSort<T>(_ array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
    guard array.count > 1 else { return array }
    
    var a = array
    for x in 1..<a.count {
        var y = x
        let temp = a[y]
        while y > 0 && isOrderedBefore(temp, a[y - 1]) {
            a[y] = a[y - 1]
            y -= 1
        }
        a[y] = temp
    }
    return a
}

/// Performs the Insertion sort algorithm to a given array
///
/// - Parameter array: the array to be sorted, conatining elements that conform to the Comparable protocol
/// - Returns: a sorted array containing the same elements
func insertionSort<T: Comparable>(_ array: [T]) -> [T] {
    var a = array
    for x in 1..<a.count {
        var y = x
        let temp = a[y]
        while y > 0 && temp < a[y - 1] {
            a[y] = a[y - 1]
            y -= 1
        }
        a[y] = temp
    }
    return a
}

let list = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
print(insertionSort(list))
print(insertionSort(list, <))
print(insertionSort(list, >))
