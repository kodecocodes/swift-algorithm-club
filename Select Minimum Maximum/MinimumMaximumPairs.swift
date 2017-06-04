/*
 Finds the maximum and minimum value in an array in O(n) time.
 */

func minimumMaximum<T: Comparable>(_ array: [T]) -> (minimum: T, maximum: T)? {
    guard var minimum = array.first else { return nil }
    var maximum = minimum

    // if 'array' has an odd number of items, let 'minimum' or 'maximum' deal with the leftover
    let start = array.count % 2 // 1 if odd, skipping the first element
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
