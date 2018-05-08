/// Conformers of this protocol represent a pair of comparable values
/// This can be useful in many data structures and algorithms where items
/// stored contain a value, but are ordered or retrieved according to a key.
public protocol KeyValuePair : Comparable {
    
  associatedtype K : Comparable, Hashable
  associatedtype V : Comparable, Hashable
  
  // Identifier used in many algorithms to search by, order by, etc
  var key : K {get set}
  
  // A data container
  var value : V {get set}
  
  
  /// Initializer
  ///
  /// - Parameters:
  ///   - key: Identifier used in many algorithms to search by, order by, etc.
  ///   - value: A data container.
  init(key: K, value: V)
  
  
  /// Creates a copy
  ///
  /// - Abstract: Conformers of this class can be either value or reference types.
  ///   Some algorithms might need to guarantee that a conformer instance gets copied.
  ///   This will perform an innecessary in the case of value types.
  ///   TODO: is there a better way?
  /// - Returns: A new instance with the old one's values copied.
  func copy() -> Self
}


/// Conformance to Equatable and Comparable protocols
extension KeyValuePair {
    
  // MARK: - Equatable protocol
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    return lhs.key == rhs.key
  }
  
  
  
  // MARK: - Comparable protocol
  
  public static func <(lhs: Self, rhs: Self) -> Bool {
    return lhs.key < rhs.key
  }
  
  public static func <=(lhs: Self, rhs: Self) -> Bool {
    return lhs.key <= rhs.key
  }
  
  public static func >=(lhs: Self, rhs: Self) -> Bool {
    return lhs.key >= rhs.key
  }
  
  public static func >(lhs: Self, rhs: Self) -> Bool {
    return lhs.key > rhs.key
  }
}



/// Concrete impletation of a KeyValuePair where  both the key and the value
/// are Integers.
struct IntegerPair : KeyValuePair {
    
  // MARK - KeyValuePair protocol
  var key : Int
  var value : Int
  
  func copy() -> IntegerPair {
    return IntegerPair(key: self.key, value: self.value)
  }
}
