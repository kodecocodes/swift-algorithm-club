/*
  Euclid's algorithm for finding the greatest common divisor
*/
func gcd(m: Int, _ n: Int) -> Int {
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

/*
  Returns the least common multiple of two numbers.
*/
func lcm(m: Int, _ n: Int) -> Int {
  return m*n / gcd(m, n)
}
