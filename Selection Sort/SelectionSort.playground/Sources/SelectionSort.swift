public func selectionSort<T: Comparable>(_ array: [T]) -> [T] {
  guard array.count > 1 else { return array }

  var a = array
  for x in 0 ..< a.count - 1 {

    // Find the lowest value in the rest of the array.
    var lowest = x
    for y in x + 1 ..< a.count {
      if a[y] < a[lowest] {
        lowest = y
      }
    }

    // Swap the lowest value with the current array index.
    if x != lowest {
      a.swapAt(x, lowest)
    }
  }
  return a
}

public func selectionSort<T>(_ array: [T], _ isLowerThan: (T, T) -> Bool) -> [T] {
    guard array.count > 1 else { return array }
    
    var a = array
    for x in 0 ..< a.count - 1 {
        
        // Find the lowest value in the rest of the array.
        var lowest = x
        for y in x + 1 ..< a.count {
            if isLowerThan(a[y], a[lowest]) {
                lowest = y
            }
        }
        
        // Swap the lowest value with the current array index.
        if x != lowest {
            a.swapAt(x, lowest)
        }
    }
    return a
}
