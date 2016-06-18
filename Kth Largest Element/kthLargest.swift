import Foundation

/*
  Returns the k-th largest value inside of an array a.
  This is an O(n log n) solution since we sort the array.
*/
func kthLargest(a: [Int], k: Int) -> Int? {
  let len = a.count
  if k > 0 && k <= len {
    let sorted = a.sort()
    return sorted[len - k]
  } else {
    return nil
  }
}


// MARK: - Randomized selection

/* Returns a random integer in the range min...max, inclusive. */
public func random(min min: Int, max: Int) -> Int {
  assert(min < max)
  return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

/*
  Swift's swap() doesn't like it if the items you're trying to swap refer to
  the same memory location. This little wrapper simply ignores such swaps.
*/
public func swap<T>(inout a: [T], _ i: Int, _ j: Int) {
  if i != j {
    swap(&a[i], &a[j])
  }
}

/*
  Returns the i-th smallest element from the array.

  This works a bit like quicksort and a bit like binary search.

  The partitioning step picks a random pivot and uses Lomuto's scheme to
  rearrange the array; afterwards, this pivot is in its final sorted position.

  If this pivot index equals i, we're done. If i is smaller, then we continue
  with the left side, otherwise we continue with the right side.

  Expected running time: O(n) if the elements are distinct.
*/
public func randomizedSelect<T: Comparable>(array: [T], order k: Int) -> T {
  var a = array

  func randomPivot<T: Comparable>(inout a: [T], _ low: Int, _ high: Int) -> T {
    let pivotIndex = random(min: low, max: high)
    swap(&a, pivotIndex, high)
    return a[high]
  }

  func randomizedPartition<T: Comparable>(inout a: [T], _ low: Int, _ high: Int) -> Int {
    let pivot = randomPivot(&a, low, high)
    var i = low
    for j in low..<high {
      if a[j] <= pivot {
        swap(&a, i, j)
        i += 1
      }
    }
    swap(&a, i, high)
    return i
  }

  func randomizedSelect<T: Comparable>(inout a: [T], _ low: Int, _ high: Int, _ k: Int) -> T {
    if low < high {
      let p = randomizedPartition(&a, low, high)
      if k == p {
        return a[p]
      } else if k < p {
        return randomizedSelect(&a, low, p - 1, k)
      } else {
        return randomizedSelect(&a, p + 1, high, k)
      }
    } else {
      return a[low]
    }
  }

  precondition(a.count > 0)
  return randomizedSelect(&a, 0, a.count - 1, k)
}
