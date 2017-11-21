//
//  Mergesort.swift
//
//
//  Created by Kelvin Lau on 2016-02-03.
//
//

func mergeSort<T: Comparable>(_ array: [T]) -> [T] {
  guard array.count > 1 else { return array }
  let middleIndex = array.count / 2
  let leftArray = mergeSort(Array(array[0..<middleIndex]))
  let rightArray = mergeSort(Array(array[middleIndex..<array.count]))
  return merge(leftPile: leftArray, rightPile: rightArray)
}

func merge<T: Comparable>(leftPile: [T], rightPile: [T]) -> [T] {
  var leftIndex = 0
  var rightIndex = 0
  var orderedPile: [T] = []
  if orderedPile.capacity < leftPile.count + rightPile.count {
    orderedPile.reserveCapacity(leftPile.count + rightPile.count)
  }

  while true {
      guard leftIndex < leftPile.endIndex else {
          orderedPile.append(contentsOf: rightPile[rightIndex..<rightPile.endIndex])
          break
      }
      guard rightIndex < rightPile.endIndex else {
          orderedPile.append(contentsOf: leftPile[leftIndex..<leftPile.endIndex])
          break
      }
      
      if leftPile[leftIndex] < rightPile[rightIndex] {
          orderedPile.append(leftPile[leftIndex])
          leftIndex += 1
      } else {
          orderedPile.append(rightPile[rightIndex])
          rightIndex += 1
      }
  }


  return orderedPile
}

/*
  This is an iterative bottom-up implementation. Instead of recursively splitting
  up the array into smaller sublists, it immediately starts merging the individual
  array elements.

  As the algorithm works its way up, it no longer merges individual elements but
  larger and larger subarrays, until eventually the entire array is merged and
  sorted.

  To avoid allocating many temporary array objects, it uses double-buffering with
  just two arrays.
*/
func mergeSortBottomUp<T>(_ a: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
  let n = a.count
  var z = [a, a]   // the two working arrays
  var d = 0        // z[d] is used for reading, z[1 - d] for writing

  var width = 1
  while width < n {

    var i = 0
    while i < n {

      var j = i
      var l = i
      var r = i + width

      let lmax = min(l + width, n)
      let rmax = min(r + width, n)

      while l < lmax && r < rmax {
        if isOrderedBefore(z[d][l], z[d][r]) {
          z[1 - d][j] = z[d][l]
          l += 1
        } else {
          z[1 - d][j] = z[d][r]
          r += 1
        }
        j += 1
      }
      while l < lmax {
        z[1 - d][j] = z[d][l]
        j += 1
        l += 1
      }
      while r < rmax {
        z[1 - d][j] = z[d][r]
        j += 1
        r += 1
      }

      i += width*2
    }

    width *= 2   // in each step, the subarray to merge becomes larger
    d = 1 - d    // swap active array
  }
  return z[d]
}
