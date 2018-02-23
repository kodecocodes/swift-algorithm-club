public class OrderedSet<T: Hashable> {
  private var objects: [T] = []
  private var indexOfKey: [T: Int] = [:]
  
  public init() {}
  
  // O(1)
  public func add(_ object: T) {
    guard indexOfKey[object] == nil else {
      return
    }
    
    objects.append(object)
    indexOfKey[object] = objects.count - 1
  }
  
  // O(n)
  public func insert(_ object: T, at index: Int) {
    assert(index < objects.count, "Index should be smaller than object count")
    assert(index >= 0, "Index should be bigger than 0")
    
    guard indexOfKey[object] == nil else {
      return
    }
    
    objects.insert(object, at: index)
    indexOfKey[object] = index
    for i in index+1..<objects.count {
      indexOfKey[objects[i]] = i
    }
  }
  
  // O(1)
  public func object(at index: Int) -> T {
    assert(index < objects.count, "Index should be smaller than object count")
    assert(index >= 0, "Index should be bigger than 0")
    
    return objects[index]
  }
  
  // O(1)
  public func set(_ object: T, at index: Int) {
    assert(index < objects.count, "Index should be smaller than object count")
    assert(index >= 0, "Index should be bigger than 0")
    
    guard indexOfKey[object] == nil else {
      return
    }
    
    indexOfKey.removeValue(forKey: objects[index])
    indexOfKey[object] = index
    objects[index] = object
  }
  
  // O(1)
  public func indexOf(_ object: T) -> Int {
    return indexOfKey[object] ?? -1
  }
  
  // O(n)
  public func remove(_ object: T) {
    guard let index = indexOfKey[object] else {
      return
    }
    
    indexOfKey.removeValue(forKey: object)
    objects.remove(at: index)
    for i in index..<objects.count {
      indexOfKey[objects[i]] = i
    }
  }
  
  public func all() -> [T] {
    return objects
  }
}

