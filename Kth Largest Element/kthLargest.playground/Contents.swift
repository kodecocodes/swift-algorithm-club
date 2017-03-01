//: Playground - noun: a place where people can play

func kthLargest(_ a: [Int], _ k: Int) -> Int? {
  let len = a.count
  if k > 0 && k <= len {
    let sorted = a.sorted()
    return sorted[len - k]
  } else {
    return nil
  }
}

let a = [5, 1, 3, 2, 7, 6, 4]

kthLargest(a, 0)
kthLargest(a, 1)
kthLargest(a, 2)
kthLargest(a, 3)
kthLargest(a, 4)
kthLargest(a, 5)
kthLargest(a, 6)
kthLargest(a, 7)
kthLargest(a, 8)




import Foundation

/* Returns a random integer in the range min...max, inclusive. */
public func random( min: Int, max: Int) -> Int {
  assert(min < max)
  return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

/*
  Swift's swap() doesn't like it if the items you're trying to swap refer to
  the same memory location. This little wrapper simply ignores such swaps.
*/
public func swap<T>(_ a:inout [T], _ i: Int, _ j: Int) {
  if i != j {
    swap(&a[i], &a[j])
  }
}

public func randomizedSelect<T: Comparable>(_ array: [T], order k: Int) -> T {
  var a = array

  func randomPivot<T: Comparable>(_ a: inout[T], _ low: Int, _ high: Int) -> T {
    let pivotIndex = random(min: low, max: high)
    swap(&a, pivotIndex, high)
    return a[high]
  }

  func randomizedPartition<T: Comparable>(_ a: inout[T], _ low: Int, _ high: Int) -> Int {
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

  func randomizedSelect<T: Comparable>(_ a: inout [T], _ low: Int, _ high: Int, _ k: Int) -> T {
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


randomizedSelect(a, order: 0)
randomizedSelect(a, order: 1)
randomizedSelect(a, order: 2)
randomizedSelect(a, order: 3)
randomizedSelect(a, order: 4)
randomizedSelect(a, order: 5)
randomizedSelect(a, order: 6)
