# String And Int Operations
The importance of various number like binary numbers, hexadecimals, ASCII values are well known.

Hence, this file aims to simply and aid in the process of conversion to required result within a tap of few buttons by the help of extensions.

## Binary Numbers
A base-2 numerical system where an integer is defined using only 1's and 0's
Example : 13 in binary is 1101

## Hexadecimal Numbers
A system of representation of numbers where the radix present is 16 i.e. the numbers used in this system range from 0...9 & A,B,C,D,E,F.
Example : 10 in hexadecimal is a

## ASCII
A method adapted that represents characters as numbers
Example : 'a'(lowercase) in terms of ASCII code is 97

## Implementation
```swift
let value = "10".intToHex // returns "10" as Hexadecimal
print(value) // prints "a"
```

```swift
let value = "A".ascii // returns "A" as Ascii value
print(value) // prints 65
```

```swift
let value = 13.binString // returns 13 as Binary String
print(value) // prints "1101"
```

```swift
let value = 97.intToAscii // returns 97 as a character taking in the integer as ASCII value
print(value) // prints "a"
```

*Written for Swift Algorithm Club by Jayant Sogikar*
