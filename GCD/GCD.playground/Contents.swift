//: Playground - noun: a place where people can play

// Recursive version
func gcd(_ a: Int, _ b: Int) -> Int {
  let r = a % b
  if r != 0 {
    return gcd(b, r)
  } else {
    return b
  }
}

/*
// Iterative version
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
*/

func lcm(_ m: Int, _ n: Int) -> Int {
  return m / gcd(m, n) * n // we divide before multiplying to avoid integer overflow
}

gcd(52, 39)       // 13
gcd(228, 36)      // 12
gcd(51357, 3819)  // 57
gcd(841, 299)     // 1

lcm(2, 3)   // 6
lcm(10, 8)  // 40
