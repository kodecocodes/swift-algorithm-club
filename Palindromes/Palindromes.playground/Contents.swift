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

// Test to check that non-palindromes are handled correctly:
palindromeCheck(text: "owls")

// Test to check that palindromes are accurately found (regardless of case and whitespace:
palindromeCheck(text: "lol")
palindromeCheck(text: "race car")
palindromeCheck(text: "Race fast Safe car")

// Test to check that palindromes are found regardless of case:
palindromeCheck(text: "HelloLLEH")

palindromeCheck(text: "moom")

// Test that nil and empty Strings return false:
palindromeCheck(text: "")
palindromeCheck(text: nil)
