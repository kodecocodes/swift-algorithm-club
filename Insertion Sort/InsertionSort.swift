func insertionSort<T>(inout array: [T], _ isOrderedBefore: (T, T) -> Bool) {
  guard array.count > 1 else { return }

  for x in 1..<array.count {
    var y = x
    let temp = array[y]
    while y > 0 && isOrderedBefore(temp, array[y - 1]) {
      array[y] = array[y - 1]
      y -= 1
    }
    array[y] = temp
  }
}
