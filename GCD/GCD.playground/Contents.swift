//: Playground - noun: a place where people can play

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

func lcm(m: Int, _ n: Int) -> Int {
  return m*n / gcd(m, n)
}

gcd(39, 52)       // 13
gcd(36, 228)      // 12
gcd(3819, 51357)  // 57
gcd(841, 299)     // 1

lcm(2, 3)   // 6
lcm(10, 8)  // 40
