// Written by Alejandro Isaza. Adapted from heap implementation written by Kevin Randrup and Matthijs Hollemans.

/// Heap with an index hash map (dictionary) to speed up lookups by value.
///
/// A heap keeps elements ordered in a binary tree without the use of pointers. A hashed heap does that as well as
/// having amortized constant lookups by value. This is used in the A* and other heuristic search algorithms to achieve
/// optimal performance.
public struct HashedHeap<T: Hashable> {
  /// The array that stores the heap's nodes.
  private(set) var elements = [T]()
  
  /// Hash mapping from elements to indices in the `elements` array.
  private(set) var indices = [T: Int]()
  
  /// Determines whether this is a max-heap (>) or min-heap (<).
  fileprivate var isOrderedBefore: (T, T) -> Bool
  
  /// Creates an empty hashed heap.
  ///
  /// The sort function determines whether this is a min-heap or max-heap. For integers, > makes a max-heap, < makes
  /// a min-heap.
  public init(sort: @escaping (T, T) -> Bool) {
    isOrderedBefore = sort
  }
  
  /// Creates a hashed heap from an array.
  ///
  /// The order of the array does not matter; the elements are inserted into the heap in the order determined by the
  /// sort function.
  ///
  /// - Complexity: O(n)
  public init(array: [T], sort: @escaping (T, T) -> Bool) {
    isOrderedBefore = sort
    build(from: array)
  }
  
  /// Converts an array to a max-heap or min-heap in a bottom-up manner.
  ///
  /// - Complexity: O(n)
  private mutating func build(from array: [T]) {
    elements = array
    for index in elements.indices {
      indices[elements[index]] = index
    }
    
    for i in stride(from: (elements.count/2 - 1), through: 0, by: -1) {
      shiftDown(i, heapSize: elements.count)
    }
  }
  
  /// Whether the heap is empty.
  public var isEmpty: Bool {
    return elements.isEmpty
  }
  
  /// The number of elements in the heap.
  public var count: Int {
    return elements.count
  }

  /// Accesses an element by its index.
  public subscript(index: Int) -> T {
    return elements[index]
  }

  /// Returns the index of the given element.
  ///
  /// This is the operation that a hashed heap optimizes in compassion with a normal heap. In a normal heap this
  /// would take O(n), but for the hashed heap this takes amortized constatn time.
  ///
  /// - Complexity: Amortized constant
  public func index(of element: T) -> Int? {
    return indices[element]
  }
  
  /// Returns the maximum value in the heap (for a max-heap) or the minimum value (for a min-heap).
  ///
  /// - Complexity: O(1)
  public func peek() -> T? {
    return elements.first
  }
  
  /// Adds a new value to the heap.
  ///
  /// This reorders the heap so that the max-heap or min-heap property still holds.
  ///
  /// - Complexity: O(log n)
  public mutating func insert(_ value: T) {
    elements.append(value)
    indices[value] = elements.count - 1
    shiftUp(elements.count - 1)
  }
  
  /// Adds new values to the heap.
  public mutating func insert<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
    for value in sequence {
      insert(value)
    }
  }
  
  /// Replaces an element in the hash.
  ///
  /// In a max-heap, the new element should be larger than the old one; in a min-heap it should be smaller.
  public mutating func replace(_ value: T, at index: Int) {
    guard index < elements.count else { return }
    
    assert(isOrderedBefore(value, elements[index]))
    set(value, at: index)
    shiftUp(index)
  }
  
  /// Removes the root node from the heap.
  ///
  /// For a max-heap, this is the maximum value; for a min-heap it is the minimum value.
  ///
  /// - Complexity: O(log n)
  @discardableResult
  public mutating func remove() -> T? {
    if elements.isEmpty {
      return nil
    } else if elements.count == 1 {
      return removeLast()
    } else {
      // Use the last node to replace the first one, then fix the heap by
      // shifting this new first node into its proper position.
      let value = elements[0]
      set(removeLast(), at: 0)
      shiftDown()
      return value
    }
  }
  
  /// Removes an arbitrary node from the heap.
  ///
  /// You need to know the node's index, which may actually take O(n) steps to find.
  ///
  /// - Complexity: O(log n).
  public mutating func remove(at index: Int) -> T? {
    guard index < elements.count else { return nil }
    
    let size = elements.count - 1
    if index != size {
      swapAt(index, size)
      shiftDown(index, heapSize: size)
      shiftUp(index)
    }
    return removeLast()
  }

  /// Removes all elements from the heap.
  public mutating func removeAll() {
    elements.removeAll()
    indices.removeAll()
  }
  
  /// Removes the last element from the heap.
  ///
  /// - Complexity: O(1)
  public mutating func removeLast() -> T {
    guard let value = elements.last else {
      preconditionFailure("Trying to remove element from empty heap")
    }
    indices[value] = nil
    return elements.removeLast()
  }
  
  /// Takes a child node and looks at its parents; if a parent is not larger (max-heap) or not smaller (min-heap)
  /// than the child, we exchange them.
  mutating func shiftUp(_ index: Int) {
    var childIndex = index
    let child = elements[childIndex]
    var parentIndex = self.parentIndex(of: childIndex)
    
    while childIndex > 0 && isOrderedBefore(child, elements[parentIndex]) {
      set(elements[parentIndex], at: childIndex)
      childIndex = parentIndex
      parentIndex = self.parentIndex(of: childIndex)
    }
    
    set(child, at: childIndex)
  }
  
  mutating func shiftDown() {
    shiftDown(0, heapSize: elements.count)
  }
  
  /// Looks at a parent node and makes sure it is still larger (max-heap) or smaller (min-heap) than its childeren.
  mutating func shiftDown(_ index: Int, heapSize: Int) {
    var parentIndex = index
    
    while true {
      let leftChildIndex = self.leftChildIndex(of: parentIndex)
      let rightChildIndex = leftChildIndex + 1
      
      // Figure out which comes first if we order them by the sort function:
      // the parent, the left child, or the right child. If the parent comes
      // first, we're done. If not, that element is out-of-place and we make
      // it "float down" the tree until the heap property is restored.
      var first = parentIndex
      if leftChildIndex < heapSize && isOrderedBefore(elements[leftChildIndex], elements[first]) {
        first = leftChildIndex
      }
      if rightChildIndex < heapSize && isOrderedBefore(elements[rightChildIndex], elements[first]) {
        first = rightChildIndex
      }
      if first == parentIndex { return }
      
      swapAt(parentIndex, first)
      parentIndex = first
    }
  }
  
  /// Replaces an element in the heap and updates the indices hash.
  private mutating func set(_ newValue: T, at index: Int) {
    indices[elements[index]] = nil
    elements[index] = newValue
    indices[newValue] = index
  }
  
  /// Swap two elements in the heap and update the indices hash.
  private mutating func swapAt(_ i: Int, _ j: Int) {
    elements.swapAt(i, j)
    indices[elements[i]] = i
    indices[elements[j]] = j
  }
  
  /// Returns the index of the parent of the element at index i.
  ///
  /// - Note: The element at index 0 is the root of the tree and has no parent.
  @inline(__always)
  func parentIndex(of index: Int) -> Int {
    return (index - 1) / 2
  }
  
  /// Returns the index of the left child of the element at index i.
  ///
  /// - Note: this index can be greater than the heap size, in which case there is no left child.
  @inline(__always)
  func leftChildIndex(of index: Int) -> Int {
    return 2*index + 1
  }
  
  /// Returns the index of the right child of the element at index i.
  ///
  /// - Note: this index can be greater than the heap size, in which case there is no right child.
  @inline(__always)
  func rightChildIndex(of index: Int) -> Int {
    return 2*index + 2
  }
}
