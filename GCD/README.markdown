# Greatest Common Divisor

The *greatest common divisor* (or Greatest Common Factor) of two numbers `a` and `b` is the largest positive integer that divides both `a` and `b` without a remainder.

For example, `gcd(39, 52) = 13` because 13 divides 39 (`39/13 = 3`) as well as 52 (`52/13 = 4`). But there is no larger number than 13 that divides them both.

You've probably had to learn about this in school at some point. :-)

The laborious way to find the GCD of two numbers is to first figure out the factors of both numbers, then take the greatest number they have in common. The problem is that factoring numbers is quite difficult, especially when they get larger. (On the plus side, that difficulty is also what keeps your online payments secure.)

There is a smarter way to calculate the GCD: Euclid's algorithm. The big idea here is that,

	gcd(a, b) = gcd(b, a % b)

where `a % b` calculates the remainder of `a` divided by `b`.

Here is an implementation of this idea in Swift:

```swift
func gcd(_ a: Int, _ b: Int) -> Int {
  let r = a % b
  if r != 0 {
    return gcd(b, r)
  } else {
    return b
  }
}
```

Put it in a playground and try it out with these examples:

```swift
gcd(52, 39)        // 13
gcd(228, 36)       // 12
gcd(51357, 3819)   // 57
```

Let's step through the third example:

	gcd(51357, 3819)

According to Euclid's rule, this is equivalent to,

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

So in each step of Euclid's algorithm the numbers become smaller and at some point it ends when one of them becomes zero.

By the way, it's also possible that two numbers have a GCD of 1. They are said to be *relatively prime*. This happens when there is no number that divides them both, for example:

```swift
gcd(841, 299)     // 1
```

Here is a slightly different implementation of Euclid's algorithm. Unlike the first version this doesn't use recursion but only a basic `while` loop.

```swift
func gcd(_ m: Int, _ n: Int) -> Int {
  var a = 0
  var b = max(m, n)
  var r = min(m, n)

  while r != 0 {
    a = b
    b = r
    r = a % b
  }
  return b
}
```

The `max()` and `min()` at the top of the function make sure we always divide the larger number by the smaller one.

## Least Common Multiple

An idea related to the GCD is the *least common multiple* or LCM.

The least common multiple of two numbers `a` and `b` is the smallest positive integer that is a multiple of both. In other words, the LCM is evenly divisible by `a` and `b`. 

For example: `lcm(2, 3) = 6` because 6 can be divided by 2 and also by 3.

We can calculate the LCM using Euclid's algorithm too:

	              a * b
	lcm(a, b) = ---------
	            gcd(a, b)

In code:

```swift
func lcm(_ m: Int, _ n: Int) -> Int {
  return m / gcd(m, n) * n
}
```

And to try it out in a playground:

```swift
lcm(10, 8)    // 40
```

You probably won't need to use the GCD or LCM in any real-world problems, but it's cool to play around with this ancient algorithm. It was first described by Euclid in his [Elements](http://publicdomainreview.org/collections/the-first-six-books-of-the-elements-of-euclid-1847/) around 300 BC. Rumor has it that he discovered this algorithm while he was hacking on his Commodore 64.

*Written for Swift Algorithm Club by Matthijs Hollemans*
