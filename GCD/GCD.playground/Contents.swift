gcd(52, 39)       // 13
gcd(228, 36)      // 12
gcd(51357, 3819)  // 57
gcd(841, 299)     // 1

gcd(52, 39, using: gcdRecursiveEuklid)       // 13
gcd(228, 36, using:  gcdRecursiveEuklid)      // 12
gcd(51357, 3819, using: gcdRecursiveEuklid)  // 57
gcd(841, 299, using: gcdRecursiveEuklid)     // 1

gcd(52, 39, using: gcdBinaryRecursiveStein)       // 13
gcd(228, 36, using: gcdBinaryRecursiveStein)      // 12
gcd(51357, 3819, using: gcdBinaryRecursiveStein)  // 57
gcd(841, 299, using: gcdBinaryRecursiveStein)     // 1

do {
    try lcm(2, 3)   // 6
    try lcm(10, 8, using: gcdRecursiveEuklid)  // 40
} catch {
    dump(error)
}
