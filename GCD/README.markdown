# Greatest Common Divisor

The *greatest common divisor* (or Greatest Common Factor) of two numbers `a` and `b` is the largest positive integer that divides both `a` and `b` without a remainder. The GCD.swift file contains three different algorithms of how to calculate the greatest common divisor.
For example, `gcd(39, 52) = 13` because 13 divides 39 (`39 / 13 = 3`) as well as 52 (`52 / 13 = 4`). But there is no larger number than 13 that divides them both.
You've probably had to learn about this in school at some point. :-)

You probably won't need to use the GCD or LCM in any real-world problems, but it's cool to play around with this ancient algorithm. It was first described by Euklid in his [Elements](http://publicdomainreview.org/collections/the-first-six-books-of-the-elements-of-euclid-1847/) around 300 BC. Rumor has it that he discovered this algorithm while he was hacking on his Commodore 64.

## Different Algorithms

This example includes three different algorithms to find the same result. 

### Iterative Euklidean

The laborious way to find the GCD of two numbers is to first figure out the factors of both numbers, then take the greatest number they have in common. The problem is that factoring numbers is quite difficult, especially when they get larger. (On the plus side, that difficulty is also what keeps your online payments secure.)
There is a smarter way to calculate the GCD: Euklid's algorithm. The big idea here is that,

	gcd(a, b) = gcd(b, a % b)

where `a % b` calculates the remainder of `a` divided by `b`.

Here is an implementation of this idea in Swift:

```swift
func gcdIterativeEuklid(_ m: Int, _ n: Int) -> Int {
    var a: Int = 0
    var b: Int = max(m, n)
    var r: Int = min(m, n)

    while r != 0 {
        a = b
        b = r
        r = a % b
    }
    return b
}
```

Put it in a playground and try it out with these examples:

```swift
gcd(52, 39, using: gcdIterativeEuklid)        // 13
gcd(228, 36, using: gcdIterativeEuklid)       // 12
gcd(51357, 3819, using: gcdIterativeEuklid)   // 57
```

### Recursive Euklidean

Here is a slightly different implementation of Euklid's algorithm. Unlike the first version this doesn't use a `while` loop, but leverages recursion.

```swift
func gcdRecursiveEuklid(_ m: Int, _ n: Int) -> Int {
    let r: Int = m % n
    if r != 0 {
        return gcdRecursiveEuklid(n, r)
    } else {
        return n
    }
}
```

Put it in a playground and compare it with the results of the iterative Eulidean gcd. They should return the same results:

```swift
gcd(52, 39, using: gcdRecursiveEuklid)        // 13
gcd(228, 36, using: gcdRecursiveEuklid)       // 12
gcd(51357, 3819, using: gcdRecursiveEuklid)   // 57
```

The `max()` and `min()` at the top of the function make sure we always divide the larger number by the smaller one.

Let's step through the third example using the *recursive Euklidean algorithm* here:

	gcd(51357, 3819)

According to Euklid's rule, this is equivalent to,

	gcd(3819, 51357 % 3819) = gcd(3819, 1710)

because the remainder of `51357 % 3819` is `1710`. If you work out this division you get `51357 = (13 * 3819) + 1710` but we only care about the remainder part.

So `gcd(51357, 3819)` is the same as `gcd(3819, 1710)`. That's useful because we can keep simplifying:

	gcd(3819, 1710) = gcd(1710, 3819 % 1710) =
	gcd(1710, 399)  = gcd(399, 1710 % 399)   =
	gcd(399, 114)   = gcd(114, 399 % 114)    =
	gcd(114, 57)    = gcd(57, 114 % 57)      =
	gcd(57, 0)

And now can't divide any further. The remainder of `114 / 57` is zero because `114 = 57 * 2` exactly. That means we've found the answer:

	gcd(3819, 51357) = gcd(57, 0) = 57

So in each step of Euklid's algorithm the numbers become smaller and at some point it ends when one of them becomes zero.

By the way, it's also possible that two numbers have a GCD of 1. They are said to be *relatively prime*. This happens when there is no number that divides them both, for example:

```swift
gcd(841, 299)     // 1
```

### Binary Recursive Stein

The binary GCD algorithm, also known as Stein's algorithm, is an algorithm that computes the greatest common divisor of two nonnegative integers. Stein's algorithm is very similar to the recursive Eulidean algorithm, but uses arithmetical operations, which are simpler for computers to perform, than the conventional Euclidean algorithm does. It replaces division with arithmetic shifts, comparisons, and subtraction.

```swift
func gcdBinaryRecursiveStein(_ m: Int, _ n: Int) -> Int {
    if let easySolution = findEasySolution(m, n) { return easySolution }

    if (m & 1) == 0 {
        // m is even
        if (n & 1) == 1 {
            // and n is odd
            return gcdBinaryRecursiveStein(m >> 1, n)
        } else {
            // both m and n are even
            return gcdBinaryRecursiveStein(m >> 1, n >> 1) << 1
        }
    } else if (n & 1) == 0 {
        // m is odd, n is even
        return gcdBinaryRecursiveStein(m, n >> 1)
    } else if (m > n) {
        // reduce larger argument
        return gcdBinaryRecursiveStein((m - n) >> 1, n)
    } else {
        // reduce larger argument
        return gcdBinaryRecursiveStein((n - m) >> 1, m)
    }
}
```

Depending on your application and your input expectations, it might be reasonable to also search for an "easy solution" using the other gcd implementations:

```swift
func findEasySolution(_ m: Int, _ n: Int) -> Int? {
    if m == n {
        return m
    }
    if m == 0 {
        return n
    }
    if n == 0 {
        return m
    }
    return nil
}

```

Put it in a playground and compare it with the results of the other gcd implementations:

```swift
gcd(52, 39, using: gcdBinaryRecursiveStein)        // 13
gcd(228, 36, using: gcdBinaryRecursiveStein)       // 12
gcd(51357, 3819, using: gcdBinaryRecursiveStein)   // 57
```

### Least Common Multiple

Another algorithm related to the GCD is the *least common multiple* or LCM.

The least common multiple of two numbers `a` and `b` is the smallest positive integer that is a multiple of both. In other words, the LCM is evenly divisible by `a` and `b`. The example implementation of the LCM takes two numbers and an optional specification which GCD algorithm is used.

For example: `lcm(2, 3, using: gcdRecursiveEuklid) = 6` , which tells us that 6 is the smallest number that can be devided by 2 as well as 3.

We can calculate the LCM using Euklid's algorithm too:

a * b
lcm(a, b) = ---------
gcd(a, b)

In code:

```swift
func lcm(_ m: Int, _ n: Int, using gcdAlgorithm: (Int, Int) -> (Int) = gcdIterativeEuklid) throws -> Int {
guard (m & n) != 0 else { throw LCMError.divisionByZero }
return m / gcdAlgorithm(m, n) * n
}
```

And to try it out in a playground:

```swift
lcm(10, 8)    // 40
```

## Discussion

While these algorithms all calculate the same result, comparing their plane complexity might not be enough to decide for one of them, though. The original iterative Euklidean algorithm is easier to understand. The recursive Euklidean and Stein's algorithm, while being generally faster, their runtime is heavily dependend on the environment they are running on.
_If a fast calculation of the gcd is necessary, a runtime comparison for the specific platform and compiler optimization level should be done for the rekursive Euklidean and Stein's algorithm._

*Written for Swift Algorithm Club by Matthijs Hollemans*

*Extended by Simon C. Krüger*
