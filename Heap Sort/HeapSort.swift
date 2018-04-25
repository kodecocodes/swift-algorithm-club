extension Heap {
  public mutating func sort() -> [T] {
    for i in stride(from: (nodes.count - 1), through: 1, by: -1) {
      nodes.swapAt(0, i)
      shiftDown(from: 0, until: i)
    }
    return nodes
  }
}

/*
 Sorts an array using a heap.
 Heapsort can be performed in-place, but it is not a stable sort.
 */
public func heapsort<T>(_ a: [T], _ sort: @escaping (T, T) -> Bool) -> [T] {
  let reverseOrder = { i1, i2 in sort(i2, i1) }
  var h = Heap(array: a, sort: reverseOrder)
  return h.sort()
}
