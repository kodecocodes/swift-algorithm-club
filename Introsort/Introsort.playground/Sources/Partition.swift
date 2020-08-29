import Foundation

public func partitionIndex<T>(for elements: inout [T], subRange range: Range<Int>, by areInIncreasingOrder: (T, T) -> Bool) -> Int {
    var lo = range.lowerBound
    var hi = elements.index(before: range.upperBound)
    
    // Sort the first, middle, and last elements, then use the middle value
    // as the pivot for the partition.
    let half = elements.distance(from: lo, to: hi) / 2
    let mid = elements.index(lo, offsetBy: half)
    
    sort3(in: &elements, a: lo, b: mid, c: hi, by: areInIncreasingOrder)
    let pivot = elements[mid]
    
    while true {
        elements.formIndex(after: &lo)
        guard findLo(in: elements, pivot: pivot, from: &lo, to: hi, by: areInIncreasingOrder) else { break }
        elements.formIndex(before: &hi)
        guard findHi(in: elements, pivot: pivot, from: lo, to: &hi, by: areInIncreasingOrder) else { break }
        elements.swapAt(lo, hi)
    }

    
    return lo
}

private func findLo<T>(in array: [T], pivot: T, from lo: inout Int, to hi: Int, by areInIncreasingOrder: (T, T)->Bool) -> Bool {
    while lo != hi {
        if !areInIncreasingOrder(array[lo], pivot) {
            return true
        }
        array.formIndex(after: &lo)
    }
    return false
}

private func findHi<T>(in array: [T], pivot: T, from lo: Int, to hi: inout Int, by areInIncreasingOrder: (T, T)->Bool) -> Bool {
    while hi != lo {
        if areInIncreasingOrder(array[hi], pivot) { return true }
        array.formIndex(before: &hi)
    }
    return false
}
