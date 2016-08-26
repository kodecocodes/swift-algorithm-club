# Palindromes

A palindrome is a word or phrase that is spelled the exact same when read forwards or backwards. 
For this example puzzle, palindromes will not take case into account, meaning that uppercase and
lowercase text will be treated the same. In addition, spaces will not be considered, allowing 
for multi-word phrases to constitute palindromes too. 

Algorithms that check for palindromes are a common programming interview question. 

## Example 

The word "radar" is spelled the exact same both forwards and backwards, and as a result is a palindrome. 
The phrase "race car" is another common palindrome that is spelled the same forwards and backwards. 

## Algorithm 

To check for palindromes, the first and last characters of a String must be compared for equality. 
When the first and last characters are the same, they are removed from the String, resulting in a 
substring starting with the second character and ending at the second to last character. 

In this implementation of a palindrome checker, recursion is used to check each substring of the 
original String. 

## The code 

Here is a recursive implementation of this in Swift: 

```swift
func palindromeCheck (text: String?) -> Bool {
  if let text = text {
    let mutableText = text.trimmingCharacters(in: NSCharacterSet.whitespaces()).lowercased()
    let length: Int = mutableText.characters.count
    
    guard length >= 1 else {
      return false
    }

    if length == 1 {
      return true
    } else if mutableText[mutableText.startIndex] == mutableText[mutableText.index(mutableText.endIndex, offsetBy: -1)] {
      let range = Range<String.Index>(mutableText.index(mutableText.startIndex, offsetBy: 1)..<mutableText.index(mutableText.endIndex, offsetBy: -1))
      return palindromeCheck(text: mutableText.substring(with: range))
    }
  }

  return false
}
```


This code can be tested in a playground using the following: 

```swift
palindromeCheck(text: "Race car")
```

Since the phrase "Race car" is a palindrome, this will return true. 

## Additional Resources

[Palindrome Wikipedia](https://en.wikipedia.org/wiki/Palindrome)


*Written by [Stephen Rutstein](https://github.com/srutstein21)*
