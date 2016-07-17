import Cocoa

public func palindromeCheck (text: String?) -> Bool {
  if let text = text {
    let mutableText = text.stringByTrimmingCharactersInSet(.whitespaceCharacterSet()).lowercaseString
    let length: Int = mutableText.characters.count
    
    guard length >= 1 else {
      return false
    }
    
    if length == 1 {
      return true
    } else if mutableText[mutableText.startIndex] == mutableText[mutableText.endIndex.predecessor()] {
      let range = Range<String.Index>(mutableText.startIndex.successor()..<mutableText.endIndex.predecessor())
      return palindromeCheck(mutableText.substringWithRange(range))
    }
  }
  
  return false
}
