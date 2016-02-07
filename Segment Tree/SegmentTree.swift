/*
  Segment tree
  build is O(n)
  query is O(log n)
  replace item is O(log n)
*/

public class SegmentTree<T> {
  
  private var value: T
  private var function: (T, T) -> T
  private var leftBound: Int
  private var rightBound: Int
  private var leftChild: SegmentTree<T>?
  private var rightChild: SegmentTree<T>?
  
  
  init(array: [T], leftBound: Int, rightBound: Int, function: (T, T) -> T) {
    self.leftBound = leftBound
    self.rightBound = rightBound
    self.function = function
    if leftBound == rightBound {
      value = array[leftBound]
    } else {
      let middle = (leftBound + rightBound) / 2
      leftChild = SegmentTree<T>(array: array, leftBound: leftBound, rightBound: middle, function: function)
      rightChild = SegmentTree<T>(array: array, leftBound: middle+1, rightBound: rightBound, function: function)
      value = function(leftChild!.value, rightChild!.value)
    }
  }
  
  convenience init(array: [T], function: (T, T) -> T) {
    self.init(array: array, leftBound: 0, rightBound: array.count-1, function: function)
  }
  
  public func queryWithLeftBound(leftBound: Int, rightBound: Int) -> T {
    if self.leftBound == self.rightBound {
      return self.value
    } else if leftChild!.rightBound < leftBound {
      return rightChild!.queryWithLeftBound(leftBound, rightBound: rightBound)
    } else if rightChild!.leftBound > rightBound {
      return leftChild!.queryWithLeftBound(leftBound, rightBound: rightBound)
    } else {
      let leftResult = leftChild!.queryWithLeftBound(leftBound, rightBound: leftChild!.rightBound)
      let rightResult = rightChild!.queryWithLeftBound(rightChild!.leftBound, rightBound: rightBound)
      return function(leftResult, rightResult)
    }
  }
  
  public func replaceItemAtIndex(index: Int, withItem item: T) {
    if leftBound == rightBound {
      value = item
    } else {
      if leftChild!.rightBound >= index {
        leftChild!.replaceItemAtIndex(index, withItem: item)
      } else {
        rightChild!.replaceItemAtIndex(index, withItem: item)
      }
      value = function(leftChild!.value, rightChild!.value)
    }
  }
}
