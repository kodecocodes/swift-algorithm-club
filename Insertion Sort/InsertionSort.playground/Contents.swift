//: Playground - noun: a place where people can play

func insertionSort<T>(_ array: [T], _ isOrderedBefore: (T, T) -> Bool) -> [T] {
  var a = array
  for x in 1..<a.count {
    var y = x
    let temp = a[y]
    while y > 0 && isOrderedBefore(temp, a[y - 1]) {
      a[y] = a[y - 1]
      y -= 1
    }
    a[y] = temp
  }
  return a
}

let list = [ 10, -1, 3, 9, 2, 27, 8, 5, 1, 3, 0, 26 ]
insertionSort(list, <)
insertionSort(list, >)