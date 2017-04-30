/*
 Finds the maximum and minimum value in an array in O(n) time.
 */

func minimumMaximum<T: Comparable>(_ array: [T]) -> (minimum: T, maximum: T)? {
    guard !array.isEmpty else {
        return nil
    }

    var minimum = array.first!
    var maximum = array.first!

    // if 'array' has an odd number of items, let 'minimum' or 'maximum' deal with the leftover
    let hasOddNumberOfItems = array.count % 2 != 0
    let start = hasOddNumberOfItems ? 1 : 0
    for i in stride(from: start, to: array.count, by: 2) {
        let pair = (array[i], array[i+1])

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
