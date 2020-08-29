import Foundation

private func shiftDown<T>(_ elements: inout [T], _ index: Int, _ range: Range<Int>, by areInIncreasingOrder: (T, T) -> Bool) {
    let countToIndex = elements.distance(from: range.lowerBound, to: index)
    let countFromIndex = elements.distance(from: index, to: range.upperBound)
    
    guard countToIndex + 1 < countFromIndex else { return }
    
    let left = elements.index(index, offsetBy: countToIndex + 1)
    var largest = index
    if areInIncreasingOrder(elements[largest], elements[left]) {
        largest = left
    }
    
    if countToIndex + 2 < countFromIndex {
        let right = elements.index(after: left)
        if areInIncreasingOrder(elements[largest], elements[right]) {
            largest = right
        }
    }

    if largest != index {
        elements.swapAt(index, largest)
        shiftDown(&elements, largest, range, by: areInIncreasingOrder)
    }
    
}

private func heapify<T>(_ list: inout [T], _ range: Range<Int>, by areInIncreasingOrder: (T, T) -> Bool) {
    let root = range.lowerBound
    var node = list.index(root, offsetBy: list.distance(from: range.lowerBound, to: range.upperBound)/2)
    
    while node != root {
        list.formIndex(before: &node)
        shiftDown(&list, node, range, by: areInIncreasingOrder)
    }
}

public func heapsort<T>(for array: inout [T], range: Range<Int>, by areInIncreasingOrder: (T, T) -> Bool) {
    var hi = range.upperBound
    let lo = range.lowerBound
    heapify(&array, range, by: areInIncreasingOrder)
    array.formIndex(before: &hi)
    
    while hi != lo {
        array.swapAt(lo, hi)
        shiftDown(&array, lo, lo..<hi, by: areInIncreasingOrder)
        array.formIndex(before: &hi)
    }
}
