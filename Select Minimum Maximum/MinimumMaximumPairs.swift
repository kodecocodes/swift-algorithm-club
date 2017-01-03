/*
 Finds the maximum and minimum value in an array in O(n) time.
 */

func minimumMaximum<T: Comparable>(_ array: [T]) -> (minimum: T, maximum: T)? {
    var array = array
    guard !array.isEmpty else {
        return nil
    }

    var minimum = array.first!
    var maximum = array.first!

    let hasOddNumberOfItems = array.count % 2 != 0
    if hasOddNumberOfItems {
        array.removeFirst()
    }

    while !array.isEmpty {
        let pair = (array.removeFirst(), array.removeFirst())

        if pair.0 > pair.1 {
            if pair.0 > maximum {
                maximum = pair.0
            }
            if pair.1 < minimum {
                minimum = pair.1
            }
        } else {
            if pair.1 > maximum {
                maximum = pair.1
            }
            if pair.0 < minimum {
                minimum = pair.0
            }
        }
    }
    
    return (minimum, maximum)
}
