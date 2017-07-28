# Find Primes
A prime number is a whole number greater than 1, whose only two whole-number factors are 1 and itself.  The first few prime numbers are 2, 3, 5, 7, 11, 13, 17, 19, 23, and 29. 

Given `N`, find all prime numbers from `0 to N`.

## Solution
Based on the prime definition, check whether a number is prime pretty straight forward. So, simple answer is looping all numbers from `0 to N`, and check each of them.

```swift
public func findPrimes(_ n: Int) -> [Int] {
    var ret: [Int] = []
    for i in 0...n {
        if isPrime(i) {
            ret.append(i)
        }
    }

    return ret
}

private func isPrime(_ n: Int) -> Bool {
    if n <= 1 {
        return false
    }

    for i in 2..<n {
        if n % i == 0 {
            return false
        }
    }

    return true
}
```

### Time complexity
For each number `K`, it needs to check `2..<K`. It’s `O(n)` . We need to loop all numbers. The total time complexity will be `O(n^2)`

How to improve this?

## Filters
One thing we notice is all factors for a number `K` must be smaller than `K`. Another thing is that if  `K % 4  == 0` , then `K % 2 == 0`. That means that we just need to check all primes smaller than `K` to see if they are the factors of `K`. If yes, `K` is not prime. Otherwise, it is.

```swift
public func findPrimes(_ n: Int) -> [Int] {
    var ret: [Int] = []
    for i in 0...n {
        if isPrime(i, primes: &ret) {
            ret.append(i)
        }
    }

    return ret
}

private func isPrime(_ n: Int, primes: inout [Int]) -> Bool {
    if n <= 1 {
        return false
    }

    for prime in primes {
        if n % prime == 0 {
            return false
        }
    }

    return true
}
```
