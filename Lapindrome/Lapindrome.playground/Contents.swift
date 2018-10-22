import Foundation

/**
 Validate that a string is a lapindrome
 - parameter str: The string to validate
 - returns: `true` if string is lapindrome, `false` if string is not
 */
public func isLapindrome(_ str: String) -> Bool {
    let strippedStr = str.replacingOccurrences(of: "\\W", with: "", options: .regularExpression, range: nil)
    let length = strippedStr.count
    
    if length > 1 {
        var median: Int = length / 2
        if length % 2 == 0 {
            let leftMedian = strippedStr.index(str.startIndex, offsetBy: median)
            let rightMedian = strippedStr.index(str.startIndex, offsetBy: 3)
            if strippedStr[leftMedian] == strippedStr[rightMedian] {
                median = median - 1
            }
        }
        
        let leftEndIndex = strippedStr.index(str.startIndex, offsetBy: median)
        let rightStartIndex = strippedStr.index(str.startIndex, offsetBy: length - median)
        let leftSubstring = strippedStr.prefix(upTo: leftEndIndex)
        let rightSubstring = strippedStr.suffix(from: rightStartIndex)
        return leftSubstring == rightSubstring
    }
    
    return false
}

// true
isLapindrome("xyzzxy")
isLapindrome("abab")
isLapindrome("xydxy")
isLapindrome("ABCDABCD")

// false
isLapindrome("c")
isLapindrome("")
isLapindrome("abcAbc")
isLapindrome("abccba")
isLapindrome("efghefgy")
isLapindrome("////")
isLapindrome("😀😀")
