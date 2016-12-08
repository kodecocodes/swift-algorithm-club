/*
  Euclid's algorithm for finding the greatest common divisor
*/
func gcd(_ a: Int, _ b: Int) -> Int {
    var x = a, y = b
    while y != 0 {
        let r = x % y
        x = y
        y = r
    }
    return x
}
/*
// Recursive version
func gcd(_ a: Int, _ b: Int) -> Int {
    guard b != 0 else { return a }
    return gcd(b, a % b)
}
*/

/*
  Returns the least common multiple of two numbers.
*/
func lcm(_ m: Int, _ n: Int) -> Int {
  return m*n / gcd(m, n)
}
