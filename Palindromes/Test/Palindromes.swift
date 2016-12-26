import Foundation

func isPalindrome(_ str: String) -> Bool {
    let strippedString = str.replacingOccurrences(of: "\\W", with: "", options: .regularExpression, range: nil)
    let length = strippedString.characters.count
    
    if length > 1 {
        return palindrome(strippedString.lowercased(), left: 0, right: length - 1)
    }
    return false
}

private func palindrome(_ str: String, left: Int, right: Int) -> Bool {
    if left >= right {
        return true
    }
    
    let lhs = str[str.index(str.startIndex, offsetBy: left)]
    let rhs = str[str.index(str.startIndex, offsetBy: right)]
    
    if lhs != rhs {
        return false
    }
    
    return palindrome(str, left: left + 1, right: right - 1)
}
