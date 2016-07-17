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

// Test to check that non-palindromes are handled correctly:
palindromeCheck("owls")

// Test to check that palindromes are accurately found (regardless of case and whitespace:
palindromeCheck("lol")
palindromeCheck("race car")
palindromeCheck("Race fast Safe car")

// Test to check that palindromes are found regardless of case:
palindromeCheck("HelloLLEH")

// Test that nil and empty Strings return false:
palindromeCheck("")
palindromeCheck(nil)
