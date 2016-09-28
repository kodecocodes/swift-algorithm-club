# Fizz Buzz

Fizz buzz is a group word game for children to teach them about division. Players take turns to count incrementally, replacing any number divisible by three with the word "fizz", and any number divisible by five with the word "buzz".

Fizz buzz has been used as an interview screening device for computer programmers.

## Example

A typical round of fizz buzz:

`1`, `2`, `Fizz`, `4`, `Buzz`, `Fizz`, `7`, `8`, `Fizz`, `Buzz`, `11`, `Fizz`, `13`, `14`, `Fizz Buzz`, `16`, `17`, `Fizz`, `19`, `Buzz`, `Fizz`, `22`, `23`, `Fizz`, `Buzz`, `26`, `Fizz`, `28`, `29`, `Fizz Buzz`, `31`, `32`, `Fizz`, `34`, `Buzz`, `Fizz`, ...

## 	Modulus Operator

The modulus operator `%` is the key to solving fizz buzz.

The modulus operator returns the remainder after an integer division. Here is an example of the modulus operator:

| Division      | Division Result            | Modulus         | Modulus Result  |
| ------------- | -------------------------- | --------------- | ---------------:|
| 1 / 3       | 0 with a remainder of 3  | 1 % 3         | 1             |
| 5 / 3       | 1 with a remainder of 2  | 5 % 3         | 2             |
| 16 / 3      | 5 with a remainder of 1  | 16 % 3        | 1             |

A common approach to determine if a number is even or odd is to use the modulus operator:

| Modulus       | Result          | Swift Code                      | Swift Code Result | Comment                                       |
| ------------- | ---------------:| ------------------------------- | -----------------:| --------------------------------------------- |
| 6 % 2       | 0               | `let isEven = (number % 2 == 0)`  | `true`            | If a number is divisible by 2 it is *even*    |
| 5 % 2       | 1               | `let isOdd = (number % 2 != 0)`   | `true`            | If a number is not divisible by 2 it is *odd* |

## Solving fizz buzz

Now we can use the modulus operator `%` to solve fizz buzz.

Finding numbers divisible by three:

| Modulus | Modulus Result | Swift Code    | Swift Code Result |
| ------- | --------------:| ------------- |------------------:|
| 1 % 3 | 1            | `1 % 3 == 0`  | `false`           |
| 2 % 3 | 2            | `2 % 3 == 0`  | `false`           |
| 3 % 3 | 0            | `3 % 3 == 0`  | `true`            |
| 4 % 3 | 1            | `4 % 3 == 0`  | `false`           |

Finding numbers divisible by five:

| Modulus | Modulus Result | Swift Code    | Swift Code Result |
| ------- | --------------:| ------------- |------------------:|
| 1 % 5 | 1            | `1 % 5 == 0`  | `false`           |
| 2 % 5 | 2            | `2 % 5 == 0`  | `false`           |
| 3 % 5 | 3            | `3 % 5 == 0`  | `false`           |
| 4 % 5 | 4            | `4 % 5 == 0`  | `false`           |
| 5 % 5 | 0            | `5 % 5 == 0`  | `true`            |
| 6 % 5 | 1            | `6 % 5 == 0`  | `false`           |

## The code

Here is a simple implementation in Swift:

```swift
func fizzBuzz(_ numberOfTurns: Int) {
  for i in 1...numberOfTurns {
    var result = ""

    if i % 3 == 0 {
      result += "Fizz"
    }

    if i % 5 == 0 {
      result += (result.isEmpty ? "" : " ") + "Buzz"
    }

    if result.isEmpty {
      result += "\(i)"
    }

    print(result)
  }
}
```

Put this code in a playground and test it like so:

```swift
fizzBuzz(15)
```

This will output:

	1, 2, Fizz, 4, Buzz, Fizz, 7, 8, Fizz, Buzz, 11, Fizz, 13, 14, Fizz Buzz

## See also

[Fizz buzz on Wikipedia](https://en.wikipedia.org/wiki/Fizz_buzz)

*Written by [Chris Pilcher](https://github.com/chris-pilcher)*
