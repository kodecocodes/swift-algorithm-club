/*
 Finds the largest positive integer that divides both
 m and n without a remainder.

 - Parameter m: First natural number
 - Parameter n: Second natural number
 - Parameter using: The used algorithm to calculate the gcd.
                    If nothing provided, the Iterative Euclidean
                    algorithm is used.
 - Returns: The natural gcd of m and n.
 */
public func gcd(_ m: Int, _ n: Int, using gcdAlgorithm: (Int, Int) -> (Int) = gcdIterativeEuklid) -> Int {
    return gcdAlgorithm(m, n)
}

/*
 Iterative approach based on the Euclidean algorithm.
 The Euclidean algorithm is based on the principle that the greatest
 common divisor of two numbers does not change if the larger number
 is replaced by its difference with the smaller number.
 - Parameter m: First natural number
 - Parameter n: Second natural number
 - Returns: The natural gcd of m and n.
 */
public func gcdIterativeEuklid(_ m: Int, _ n: Int) -> Int {
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

/*
 Recursive approach based on the Euclidean algorithm.
 
 - Parameter m: First natural number
 - Parameter n: Second natural number
 - Returns: The natural gcd of m and n.
 - Note: The recursive version makes only tail recursive calls.
 Most compilers for imperative languages do not optimize these.
 The swift compiler as well as the obj-c compiler is able to do
 optimizations for tail recursive calls, even though it still ends
 up to be the same in terms of complexity. That said, tail call
 elimination is not mutually exclusive to recursion.
 */
public func gcdRecursiveEuklid(_ m: Int, _ n: Int) -> Int {
    let r: Int = m % n
    if r != 0 {
        return gcdRecursiveEuklid(n, r)
    } else {
        return n
    }
}

/*
 The binary GCD algorithm, also known as Stein's algorithm,
 is an algorithm that computes the greatest common divisor of two
 nonnegative integers. Stein's algorithm uses simpler arithmetic
 operations than the conventional Euclidean algorithm; it replaces
 division with arithmetic shifts, comparisons, and subtraction.
 
 - Parameter m: First natural number
 - Parameter n: Second natural number
 - Returns: The natural gcd of m and n
 - Complexity: worst case O(n^2), where n is the number of bits
 in the larger of the two numbers. Although each step reduces
 at least one of the operands by at least a factor of 2,
 the subtract and shift operations take linear time for very
 large integers
 */
public func gcdBinaryRecursiveStein(_ m: Int, _ n: Int) -> Int {
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

/*
 Finds an easy solution for the gcd.
 - Parameter m: First natural number
 - Parameter n: Second natural number
 - Returns: A natural gcd of m and n if possible.
 - Note: It might be relevant for different usecases to
 try finding an easy solution for the GCD calculation
 before even starting more difficult operations.
 */
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


public enum LCMError: Error {
    case divisionByZero
}

/*
 Calculates the lcm for two given numbers using a specified gcd algorithm.
 
 - Parameter m: First natural number.
 - Parameter n: Second natural number.
 - Parameter using: The used gcd algorithm to calculate the lcm.
                    If nothing provided, the Iterative Euclidean
                    algorithm is used.
 - Throws: Can throw a `divisionByZero` error if one of the given
 attributes turns out to be zero or less.
 - Returns: The least common multiplier of the two attributes as
 an unsigned integer
 */
public func lcm(_ m: Int, _ n: Int, using gcdAlgorithm: (Int, Int) -> (Int) = gcdIterativeEuklid) throws -> Int {
    guard m & n != 0 else { throw LCMError.divisionByZero }
    return m / gcdAlgorithm(m, n) * n
}
