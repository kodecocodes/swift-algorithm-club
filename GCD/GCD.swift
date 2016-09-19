/*
  Euclid's algorithm for finding the greatest common divisor
*/
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

/*
// Recursive version
func gcd(_ a: Int, _ b: Int) -> Int {
  let r = a % b
  if r != 0 {
    return gcd(b, r)
  } else {
    return b
  }
}
*/

/*
  Returns the least common multiple of two numbers.
*/
func lcm(_ m: Int, _ n: Int) -> Int {
  return m*n / gcd(m, n)
}
