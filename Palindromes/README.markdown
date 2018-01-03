# Palindromes

A palindrome is a word or phrase that is spelled the exact same when reading it forwards or backward. Palindromes are allowed to be lowercase or uppercase, contain spaces, punctuation, and word dividers.

Algorithms that check for palindromes are a common programming interview question. 

## Example 

The word racecar is a valid palindrome, as it is a word spelled the same when backgrounds and forwards. The examples below shows valid cases of the palindrome `racecar`.

```
raceCar
r a c e c a r
r?a?c?e?c?a?r?
RACEcar
```

## Algorithm 

To check for palindromes, a string's characters are compared starting from the beginning and end then moving inward toward the middle of the string while maintaining the same distance apart. In this implementation of a palindrome algorithm, recursion is used to check each of the characters on the left-hand side and right-hand side moving inward.

## The code 

Here is a recursive implementation of this in Swift: 

```swift
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
```

This algorithm has a two-step process.

1. The first step is to pass the string to validate as a palindrome into the `isPalindrome` method. This method first removes occurrences of non-word pattern matches `\W` [Regex reference](http://regexr.com). It is written with two \\ to escape the \ in the String literal. 

```swift
let strippedString = str.replacingOccurrences(of: "\\W", with: "", options: .regularExpression, range: nil)
```

The length of the string is then checked to make sure that the string after being stripped of non-word characters is still in a valid length. It is then passed into the next step after being lowercased.

2. The second step is to pass the string in a recursive method. This method takes a string, a left index, and a right index. The method checks the characters of the string using the indexes to compare each character on both sides. The method checks if the left is greater or equal to the right if so the entire string has been run through without returning false so the string is equal on both sides thus returning true. 
```swift
if left >= right {
  return true
}
```
If the check doesn't pass it continues to get the characters at the specified indexes and compare each. If they are not the same the method returns false and exits. 
```swift
let lhs = str[str.index(str.startIndex, offsetBy: left)]
let rhs = str[str.index(str.startIndex, offsetBy: right)]

if lhs != rhs {
  return false
}
```
If they are the same the method calls itself again and updates the indexes accordingly to continue to check the rest of the string. 
```swift
return palindrome(str, left: left + 1, right: right - 1)
```

Step 1:
`race?C ar -> raceCar -> racecar`

Step 2:
```
|     |
racecar -> r == r

 |   |
racecar -> a == a

  | |
racecar -> c == c

   |
racecar -> left index == right index -> return true
```

## Additional Resources

[Palindrome Wikipedia](https://en.wikipedia.org/wiki/Palindrome)


*Written by [Joshua Alvarado](https://github.com/lostatseajoshua)*
