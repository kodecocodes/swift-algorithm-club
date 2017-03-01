import Foundation

// Returns a random number between the given range.
public func random(min: Int, max: Int) -> Int {
  return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}

// Generates a random alphanumeric string of a given length.
extension String {
  public static func random(length: Int = 8) -> String {
    let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString: String = ""

    for _ in 0..<length {
      let randomValue = arc4random_uniform(UInt32(base.characters.count))
      randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
    }
    return randomString
  }
}
