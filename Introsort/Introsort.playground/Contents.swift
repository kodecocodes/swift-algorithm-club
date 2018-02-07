//: Playground - noun: a place where people can play

import Foundation

func introsort<T>(_ array: inout [T],  by areInIncreasingOrder: (T, T) -> Bool) {
    //The depth limit is as best practice 2 * log( n )
    let depthLimit = 2 * floor(log2(Double(array.count)))
    
    introSortImplementation(for: &array, range: 0..<array.count, depthLimit: Int(depthLimit), by: areInIncreasingOrder)
}

///This method is recursively executed for each partition result of the quicksort part of the algorithm
private func introSortImplementation<T>(for array: inout [T], range: Range<Int>, depthLimit: Int, by areInIncreasingOrder: (T, T) -> Bool) {
    if array.distance(from: range.lowerBound, to: range.upperBound) < 20 {
        //if the partition count is less than 20 we can sort it using insertion sort. This algorithm in fact performs well on collections
        //of this size, plus, at this point is quite probable that the quisksort part of the algorithm produced a partition which is
        //nearly sorted. As we knoe insertion sort tends to O( n ) if this is the case.
        insertionSort(for: &array, range: range, by: areInIncreasingOrder)
    } else if depthLimit == 0 {
        //If we reached the depth limit for this recursion branch, it's possible that we are hitting quick sort's worst case.
        //Since quicksort degrades to O( n^2 ) in its worst case we stop using quicksort for this recursion branch and we switch to heapsort.
        //Our preference remains quicksort, and we hope to be rare to see this condition to be true
        heapsort(for: &array, range: range, by: areInIncreasingOrder)
    } else {
        //By default we use quicksort to sort our collection. The partition index method chose a pivot, and puts all the
        //elements less than pivot on the left, and the ones bigger than pivot on the right. At the end of the operation the
        //position of the pivot in the array is returned so that we can form the two partitions.
        let partIdx = partitionIndex(for: &array, subRange: range, by: areInIncreasingOrder)
        
        //We can recursively call introsort implementation, decreasing the depthLimit for the left partition and the right partition.
        introSortImplementation(for: &array, range: range.lowerBound..<partIdx, depthLimit: depthLimit &- 1, by: areInIncreasingOrder)
        introSortImplementation(for: &array, range: partIdx..<range.upperBound, depthLimit: depthLimit &- 1, by: areInIncreasingOrder)
    }
}

var unsorted = randomize(n: 1000)

let swiftSorted = unsorted.sorted()
introsort(&unsorted, by: <)

print("does it work? \(unsorted == swiftSorted)")
