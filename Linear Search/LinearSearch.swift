extension Array where Element: Equatable {
    func linearSearch(_ element: Element) -> Int? {
        for (index, candidate) in self.enumerated() {
            if candidate == element {
                return index
            }
        }
        return nil
    }
}

func linearSearch<T: Equatable>(_ array: [T], _ object: T) -> Int? {
  for (index, obj) in array.enumerated() where obj == object {
    return index
  }
  return nil
}

func linearSearch1<T: Equatable>(_ array: [T], _ object: T) -> Array<T>.Index? {
    return array.index { $0 == object }
}
