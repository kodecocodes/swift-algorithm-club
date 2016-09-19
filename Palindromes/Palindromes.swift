import Cocoa

public func palindromeCheck(text: String?) -> Bool {
  if let text = text {
    let mutableText = text.trimmingCharacters(in: NSCharacterSet.whitespaces).lowercased()
    let length: Int = mutableText.characters.count
    
    if length == 1 || length == 0 {
      return true
    } else if mutableText[mutableText.startIndex] == mutableText[mutableText.index(mutableText.endIndex, offsetBy: -1)] {
      let range = Range<String.Index>(mutableText.index(mutableText.startIndex, offsetBy: 1)..<mutableText.index(mutableText.endIndex, offsetBy: -1))
      return palindromeCheck(text: mutableText.substring(with: range))
    }
  }
  
  return false
}
