extension Set {
  func cover(within array: Array<Set<Element>>) -> Array<Set<Element>>? {
    var result: [Set<Element>]? = [Set<Element>]()
    var remainingSet = self
    
    func largestIntersectingSet() -> Set<Element>? {
      var largestIntersectionLength = 0
      var largestSet: Set<Element>?
      
      for set in array {
        let intersectionLength = remainingSet.intersect(set).count
        if intersectionLength > largestIntersectionLength {
          largestIntersectionLength = intersectionLength
          largestSet = set
        }
      }
      
      return largestSet
    }
    
    while remainingSet.count != 0 {
      guard let largestSet = largestIntersectingSet() else { break }
      result!.append(largestSet)
      remainingSet = remainingSet.subtract(largestSet)
    }
    
    if remainingSet.count != 0 || self.count == 0 {
      result = nil
    }
    
    return result
  }
}