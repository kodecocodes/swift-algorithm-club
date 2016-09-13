//: Playground - noun: a place where people can play

import Foundation

infix operator ^^ { associativity left precedence 160 }
func ^^ (radix: Int, power: Int) -> Int {
  return Int(pow(Double(radix), Double(power)))
}

// Long Multiplication - O(n^2)
func multiply(num1: Int, _ num2: Int, base: Int = 10) -> Int {
  let num1Array = String(num1).characters.reverse().map{ Int(String($0))! }
  let num2Array = String(num2).characters.reverse().map{ Int(String($0))! }
  
  var product = Array(count: num1Array.count + num2Array.count, repeatedValue: 0)

  for i in num1Array.indices {
    var carry = 0
    for j in num2Array.indices {
      product[i + j] += carry + num1Array[i] * num2Array[j]
      carry = product[i + j] / base
      product[i + j] %= base
    }
    product[i + num2Array.count] += carry
  }
  
  return Int(product.reverse().map{ String($0) }.reduce("", combine: +))!
}

// Karatsuba Multiplication - O(nlogn)
func karatsuba(num1: Int, _ num2: Int) -> Int {
  let num1Array = String(num1).characters
  let num2Array = String(num2).characters
  
  guard num1Array.count > 1 && num2Array.count > 1 else {
    return multiply(num1, num2)
  }
  
  let n = max(num1Array.count, num2Array.count)
  let nBy2 = n / 2
  
  let a = num1 / 10^^nBy2
  let b = num1 % 10^^nBy2
  let c = num2 / 10^^nBy2
  let d = num2 % 10^^nBy2
  
  let ac = karatsuba(a, c)
  let bd = karatsuba(b, d)
  let adPluscd = karatsuba(a+b, c+d) - ac - bd
  
  let product = ac * 10^^(2 * nBy2) + adPluscd * 10^^nBy2 + bd
  
  return product
}

print(multiply(236742342, 1231234224))
print(karatsuba(236742342, 1231234224))